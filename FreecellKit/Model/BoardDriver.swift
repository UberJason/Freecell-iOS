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
    private var _board = Board(deck: Deck(shuffled: true))
    
    public var freecells: [FreeCell] { return currentRenderedBoard.freecells }
    public var foundations: [Foundation] { return currentRenderedBoard.foundations }
    public var columns: [Column] { return currentRenderedBoard.columns }
    
    @Published public var currentRenderedBoard: Board
    @Published public var selectedCard: Card?
    
    public var allCards: [Card] {
        return freecells.flatMap({ $0.items }) +
                foundations.flatMap({ $0.items }) +
                columns.flatMap({ $0.items })
    }
    
    private var selectionState: SelectionState { selectedCard.map { .selected(card: $0) } ?? .idle }
    private var animationOffsetInterval = 75
    private var moveEventSubscriber: AnyCancellable?
    
    public init() {
        currentRenderedBoard = _board.copy
        configureSubscribers()
    }
    
    private func configureSubscribers() {
        moveEventSubscriber = _board.movePublisher
            .modulated(.milliseconds(animationOffsetInterval), scheduler: RunLoop.main)
            .map { $0.afterBoard }
            .assign(to: \.currentRenderedBoard, on: self)
    }
    
    public func location(containing card: Card) -> CardLocation {
        return currentRenderedBoard.location(containing: card)
    }
    

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
