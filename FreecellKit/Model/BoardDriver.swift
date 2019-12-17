//
//  BoardDriver.swift
//  FreecellKit
//
//  Created by Jason Ji on 11/30/19.
//  Copyright © 2019 Jason Ji. All rights reserved.
//

import Combine
import Foundation
import DeckKit
#if os(macOS)
import Cocoa
#endif

enum SelectionState {
    case idle, selected(card: Card)
}

public struct MoveState {
    let card: Card
    let location: CardLocation
}

public class BoardDriver: ObservableObject {
    public var board = Board(deck: Deck(shuffled: false))
    
    public var freecells: [FreeCell] { return board.freecells }
    public var foundations: [Foundation] { return board.foundations }
    public var columns: [Column] { return board.columns }
    
    var selectionState: SelectionState {
        return selectedCard.map { .selected(card: $0) } ?? .idle
    }
    
    @Published public var selectedCard: Card?
    @Published public var hiddenCard: Card?
    @Published public var inFlightMove: MoveState? = nil
    
    public var animationTimeMilliseconds = 750
    
    private var moveEventSubscriber: AnyCancellable?
    private var assignHiddenCardSubscriber: AnyCancellable?
    private var assignInFlightMoveSubscriber: AnyCancellable?
    private var assignDelayedInFlightMoveSubscriber: AnyCancellable?
    private var animationCompleteSubscriber: AnyCancellable?
    
    public init() {
        configureSubscribers()
    }
    
    private func configureSubscribers() {
        assignHiddenCardSubscriber = board.movePublisher
            .map { $0.card }
            .receive(on: RunLoop.main)
            .print("assign hidden card")
            .assign(to: \.hiddenCard, on: self)
        
        assignInFlightMoveSubscriber = board.movePublisher
            .map { MoveState(card: $0.card, location: $0.fromLocation) }
            .receive(on: RunLoop.main)
            .print("assign inFlight - fromLocation")
            .assign(to: \.inFlightMove, on: self)
        
        assignDelayedInFlightMoveSubscriber = board.movePublisher
            .delay(for: .milliseconds(5), scheduler: RunLoop.main)
            .map { MoveState(card: $0.card, location: $0.toLocation) }
            .print("assign inFlight - toLocation")
            .assign(to: \.inFlightMove, on: self)
    
        animationCompleteSubscriber = board.movePublisher
            .delay(for: .milliseconds(animationTimeMilliseconds + 5), scheduler: RunLoop.main)
            .print("animation complete, nil out inFlightMove and hiddenCard")
            .sink { [weak self] _ in
                self?.inFlightMove = nil
                self?.hiddenCard = nil
            }
    }
    
//    private func animateMove(_ move: MoveEvent) {
//        hiddenCard = move.card
//        inFlightMove = MoveState(card: move.card, location: move.fromLocation)
//        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(1)) { [weak self] in
//            guard let strongSelf = self else { return }
//            strongSelf.inFlightMove = MoveState(card: move.card, location: move.toLocation)
//            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(strongSelf.animationTimeMilliseconds)) {
//                strongSelf.inFlightMove = nil
//                strongSelf.hiddenCard = nil
//            }
//        }
//    }
    
    public func itemTapped<T>(_ item: T) {
        switch item {
        case let card as Card:
            handleTap(in: board.location(containing: card))
        case let location as CardLocation:
            handleTap(in: location)
        case _ as BoardView:
            selectedCard = nil
        default:
            break
        }
    }
    
    #warning("TODO: Quality of life - if tap on selected Freecell card, de-select it.")
    #warning("TODO: Quality of life - if tap on a Freecell card when another Freecell card is selected, select new Freecell card.")
    private func handleTap(in location: CardLocation) {
        switch selectionState {
        case .idle:
            selectedCard = location.selectableCard()
        case .selected(let card):
            do {
                try board.performValidMove(from: card, to: location)
                selectedCard = nil
            } catch {
                #if os(macOS)
                NSSound.beep()
                #endif
                selectedCard = nil
                print(error.localizedDescription)
            }
        }
    }
}
