//
//  ModulatedPublisher.swift
//  CustomPublisher
//
//  Created by Jason Ji on 12/17/19.
//  Copyright © 2019 Jason Ji. All rights reserved.
//

import Foundation
import Combine

public extension Publisher {
    func modulated<Context: Scheduler>(_ pace: Context.SchedulerTimeType.Stride, scheduler: Context) -> AnyPublisher<Output, Failure> {
        let upstream = buffer(size: 1000, prefetch: .byRequest, whenFull: .dropNewest).eraseToAnyPublisher()
        return PacePublisher<Context, AnyPublisher>(pace: pace, scheduler: scheduler, source: upstream).eraseToAnyPublisher()
    }
}

final class PacePublisher<Context: Scheduler, Source: Publisher>: Publisher {
    typealias Output = Source.Output
    typealias Failure = Source.Failure

    var internalSubject: PassthroughSubject<Output, Failure>
    let scheduler: Context
    let pace: Context.SchedulerTimeType.Stride

    lazy var internalSubscriber: SteppingSubscriber<Output, Failure> = SteppingSubscriber<Output, Failure>(stepper: stepper)
    lazy var stepper: ((SteppingSubscriber<Output, Failure>.Event) -> ()) = { [unowned self] in 
        switch $0 {
        case .input(let input, let promise):
            // Send the input from upstream now.
            self.internalSubject.send(input)

            // Wait for the pace interval to elapse before requesting the
            // next input from upstream.
            self.scheduler.schedule(after: self.scheduler.now.advanced(by: self.pace)) {
                promise(.more)
            }

        case .completion(let completion):
            self.internalSubject.send(completion: completion)
        }
    }

    init(pace: Context.SchedulerTimeType.Stride, scheduler: Context, source: Source) {
        self.scheduler = scheduler
        self.pace = pace
        self.internalSubject = PassthroughSubject<Source.Output, Source.Failure>()

        source.subscribe(internalSubscriber)
    }

    public func receive<S>(subscriber: S) where S : Subscriber, Failure == S.Failure, Output == S.Input {
        internalSubject.subscribe(subscriber)
        internalSubject.send(subscription: PaceSubscription(subscriber: subscriber))
    }
    
    deinit {
        terminate()
    }
    
    func terminate() {
        internalSubject.send(completion: .finished)
        internalSubscriber.cancel()
    }
}

public class PaceSubscription<S: Subscriber>: Subscription {
    private var subscriber: S?

    init(subscriber: S) {
        self.subscriber = subscriber
    }

    public func request(_ demand: Subscribers.Demand) {

    }

    public func cancel() {
        subscriber = nil
    }
}
