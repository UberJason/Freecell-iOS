//
//  SteppingSubscriber.swift
//  CustomPublisher
//
//  Created by Jason Ji on 12/18/19.
//  Copyright © 2019 Jason Ji. All rights reserved.
//


import Combine
import Foundation

public class SteppingSubscriber<Input, Failure: Error> {
    public init(stepper: @escaping Stepper) {
        l_state = .subscribing(stepper)
    }
    public typealias Stepper = (Event) -> ()
    public enum Event {
        case input(Input, Promise)
        case completion(Completion)
    }
    public typealias Promise = (Request) -> ()
    public enum Request {
        case more
        case cancel
    }
    public typealias Completion = Subscribers.Completion<Failure>
    private let lock = NSLock()
    // The l_ prefix means it must only be accessed while holding the lock.
    private var l_state: State
    private var l_nextPromiseId: PromiseId = 1
    private typealias PromiseId = Int
    private var noPromiseId: PromiseId { 0 }
}

extension SteppingSubscriber {
    private enum State {
        // Completed or cancelled.
        case dead
        // Waiting for Subscription from upstream.
        case subscribing(Stepper)
        // Waiting for a signal from upstream or for the latest promise to be completed.
        case subscribed(Subscribed)
        // Calling out to the stopper.
        case stepping(Stepping)
        var subscription: Subscription? {
            switch self {
            case .dead: return nil
            case .subscribing(_): return nil
            case .subscribed(let subscribed): return subscribed.subscription
            case .stepping(let stepping): return stepping.subscribed.subscription
            }
        }
        struct Subscribed {
            var stepper: Stepper
            var subscription: Subscription
            var validPromiseId: PromiseId
        }
        struct Stepping {
            var subscribed: Subscribed
            // If the stepper completes the current promise synchronously with .more,
            // I set this to true.
            var shouldRequestMore: Bool
        }
    }
}

extension SteppingSubscriber: Cancellable {
    public func cancel() {
        let sub: Subscription? = lock.sync {
            defer { l_state = .dead }
            return l_state.subscription
        }
        sub?.cancel()
    }
}

extension SteppingSubscriber: Subscriber {
    public func receive(subscription: Subscription) {
        let action: () -> () = lock.sync {
            guard case .subscribing(let stepper) = l_state else {
                return { subscription.cancel() }
            }
            l_state = .subscribed(.init(stepper: stepper, subscription: subscription, validPromiseId: noPromiseId))
            return { subscription.request(.max(1)) }
        }
        action()
    }
    
    public func receive(completion: Subscribers.Completion<Failure>) {
        let action: (() -> ())? = lock.sync {
            // The only state in which I have to handle this call is .subscribed:
            // - If I'm .dead, either upstream already completed (and shouldn't call this again),
            //   or I've been cancelled.
            // - If I'm .subscribing, upstream must send me a Subscription before sending me a completion.
            // - If I'm .stepping, upstream is currently signalling me and isn't allowed to signal
            //   me again concurrently.
            guard case .subscribed(let subscribed) = l_state else {
                return nil
            }
            l_state = .dead
            return { [stepper = subscribed.stepper] in
                stepper(.completion(completion))
            }
        }
        action?()
    }

    public func receive(_ input: Input) -> Subscribers.Demand {
        let action: (() -> Subscribers.Demand)? = lock.sync {
            // The only state in which I have to handle this call is .subscribed:
            // - If I'm .dead, either upstream completed and shouldn't call this,
            //   or I've been cancelled.
            // - If I'm .subscribing, upstream must send me a Subscription before sending me Input.
            // - If I'm .stepping, upstream is currently signalling me and isn't allowed to
            //   signal me again concurrently.
            guard case .subscribed(var subscribed) = l_state else {
                return nil
            }
            let promiseId = l_nextPromiseId
            l_nextPromiseId += 1
            let promise: Promise = { request in
                self.completePromise(id: promiseId, request: request)
            }
            subscribed.validPromiseId = promiseId
            l_state = .stepping(.init(subscribed: subscribed, shouldRequestMore: false))
            return { [stepper = subscribed.stepper] in
                stepper(.input(input, promise))
                let demand: Subscribers.Demand = self.lock.sync {
                    // The only possible states now are .stepping and .dead.
                    guard case .stepping(let stepping) = self.l_state else {
                        return .none
                    }
                    self.l_state = .subscribed(stepping.subscribed)
                    return stepping.shouldRequestMore ? .max(1) : .none
                }
                return demand
            }
        }
        return action?() ?? .none
    }
} // end of extension SteppingSubscriber: Publisher

extension SteppingSubscriber {
    private func completePromise(id: PromiseId, request: Request) {
        let action: (() -> ())? = lock.sync {
            switch l_state {
            case .dead, .subscribing(_): return nil
            case .subscribed(var subscribed) where subscribed.validPromiseId == id && request == .more:
                subscribed.validPromiseId = noPromiseId
                l_state = .subscribed(subscribed)
                return { [sub = subscribed.subscription] in
                    sub.request(.max(1))
                }
            case .subscribed(let subscribed) where subscribed.validPromiseId == id && request == .cancel:
                l_state = .dead
                return { [sub = subscribed.subscription] in
                    sub.cancel()
                }
            case .subscribed(_):
                // Multiple completion or stale promise.
                return nil
            case .stepping(var stepping) where stepping.subscribed.validPromiseId == id && request == .more:
                stepping.subscribed.validPromiseId = noPromiseId
                stepping.shouldRequestMore = true
                l_state = .stepping(stepping)
                return nil
            case .stepping(let stepping) where stepping.subscribed.validPromiseId == id && request == .cancel:
                l_state = .dead
                return { [sub = stepping.subscribed.subscription] in
                    sub.cancel()
                }
            case .stepping(_):
                // Multiple completion or stale promise.
                return nil
            }
        }
        action?()
    }
}

fileprivate extension NSLock {
    @inline(__always)
    func sync<Answer>(_ body: () -> Answer) -> Answer {
        lock()
        defer { unlock() }
        return body()
    }
}
