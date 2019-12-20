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
    private var board = Board(deck: Deck(shuffled: true))
    
    public var freecells: [FreeCell] { return board.freecells }
    public var foundations: [Foundation] { return board.foundations }
    public var columns: [Column] { return board.columns }

    var selectionState: SelectionState {
        return selectedCard.map { .selected(card: $0) } ?? .idle
    }
    
    @Published public var selectedCard: Card?
    
    public var animationTimeMilliseconds = 250
    
    private var moveEventSubscriber: AnyCancellable?
    private var assignHiddenCardSubscriber: AnyCancellable?
    private var assignInFlightMoveSubscriber: AnyCancellable?
    private var assignDelayedInFlightMoveSubscriber: AnyCancellable?
    private var animationCompleteSubscriber: AnyCancellable?
    
    public var allCards: [Card] {
        return freecells.flatMap({ $0.items }) +
                foundations.flatMap({ $0.items }) +
                columns.flatMap({ $0.items })
    }
    
    public func location(containing card: Card) -> CardLocation {
        return board.location(containing: card)
    }
    
    public init() {
//        configureSubscribers()
    }
    
    private func configureSubscribers() {
        let movePublisher = board.movePublisher.modulated(.milliseconds(animationTimeMilliseconds + 10), scheduler: RunLoop.main)
    }

    public func itemTapped<T>(_ item: T) {
        switch item {
        case let card as Card:
            handleTap(in: board.location(containing: card))
        case let location as CardLocation:
            handleTap(in: board.location(id: location.id, locationType: type(of: location)))
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
