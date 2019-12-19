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
    private var _board = Board(deck: Deck(shuffled: false))
    
    public var currentBoardToRender: Board
    
    public var freecells: [FreeCell] { return currentBoardToRender.freecells }
    public var foundations: [Foundation] { return currentBoardToRender.foundations }
    public var columns: [Column] { return currentBoardToRender.columns }
    
    var selectionState: SelectionState {
        return selectedCard.map { .selected(card: $0) } ?? .idle
    }
    
    @Published public var selectedCard: Card?
    @Published public var hiddenCard: Card?
    @Published public var inFlightMove: MoveState? = nil
    
    public var animationTimeMilliseconds = 250
    
    private var moveEventSubscriber: AnyCancellable?
    private var assignHiddenCardSubscriber: AnyCancellable?
    private var assignInFlightMoveSubscriber: AnyCancellable?
    private var assignDelayedInFlightMoveSubscriber: AnyCancellable?
    private var animationCompleteSubscriber: AnyCancellable?
    
    public init() {
        currentBoardToRender = _board
        configureSubscribers()
    }
    
    private func configureSubscribers() {
        let movePublisher = _board.movePublisher.modulated(.milliseconds(animationTimeMilliseconds + 10), scheduler: RunLoop.main)
        
        moveEventSubscriber = movePublisher
            .map { $0.afterBoard }
            .assign(to: \.currentBoardToRender, on: self)
        
        assignHiddenCardSubscriber = movePublisher
            .map { $0.card }
            .receive(on: RunLoop.main)
//            .print("assign hidden card")
            .assign(to: \.hiddenCard, on: self)
        
        assignInFlightMoveSubscriber = movePublisher
            .map { MoveState(card: $0.card, location: $0.beforeBoard.location(containing: $0.card)) }
            .receive(on: RunLoop.main)
//            .print("assign inFlight - fromLocation")
            .assign(to: \.inFlightMove, on: self)
        
        assignDelayedInFlightMoveSubscriber = movePublisher
            .delay(for: .milliseconds(5), scheduler: RunLoop.main)
            .map { MoveState(card: $0.card, location: $0.afterBoard.location(containing: $0.card)) }
//            .print("assign inFlight - toLocation")
            .assign(to: \.inFlightMove, on: self)
    
        animationCompleteSubscriber = movePublisher
            .delay(for: .milliseconds(animationTimeMilliseconds + 5), scheduler: RunLoop.main)
//            .print("animation complete, nil out inFlightMove and hiddenCard")
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
            handleTap(in: _board.location(containing: card))
        case let location as CardLocation:
            handleTap(in: _board.location(id: location.id, locationType: type(of: location)))
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
                try _board.performValidMove(from: card, to: location)
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
