//
//  BoardViewDriver.swift
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

public class BoardViewDriver: ObservableObject {
    internal var _board = Board(deck: Deck(shuffled: true))
    internal var previousBoards = [Board]()

    public var freecells: [FreeCell] { return renderingBoard.freecells }
    public var foundations: [Foundation] { return renderingBoard.foundations }
    public var columns: [Column] { return renderingBoard.columns }
    
    @Published public var renderingBoard: Board
    @Published public var selectedCard: Card?
    
    public var allCards: [Card] {
        fatalError("implement in subclass")
    }
    
    var selectionState: SelectionState { selectedCard.map { .selected(card: $0) } ?? .idle }
    internal var animationOffsetInterval = 75
    internal var moveEventSubscriber: AnyCancellable?
    
    var undoManager: UndoManager?
    
    public init() {
        renderingBoard = _board.copy
        configureRendering()
    }
    
    internal func configureRendering() {
        renderingBoard = _board.copy
        
        moveEventSubscriber = _board.movePublisher
        .modulated(.milliseconds(animationOffsetInterval), scheduler: RunLoop.main)
        .map { $0.afterBoard }
        .assign(to: \.renderingBoard, on: self)
    }
    
    public func location(containing card: Card) -> CardLocation {
        fatalError("Implement in subclass")
    }
    
    public func itemTapped<T>(_ item: T) {
        fatalError("Implement in subclass")
    }
    
    internal func registerMove() {
        previousBoards.append(_board.copy)
        undoManager?.registerUndo(withTarget: self, selector: #selector(performUndo), object: nil)
    }
    
    public func undo() {
        undoManager?.undo()
    }
    
    @objc internal func performUndo() {
        guard previousBoards.count > 0 else { return }
        
        _board = previousBoards.removeLast()
        configureRendering()
    }
}

public class ClassicViewDriver: BoardViewDriver {
    
    public override var allCards: [Card] {
        return freecells.flatMap({ $0.items }) +
            foundations.flatMap({ $0.items }) +
            columns.flatMap({ $0.items })
    }
    
    public override func location(containing card: Card) -> CardLocation {
        return renderingBoard.location(containing: card)
    }

    public override func itemTapped<T>(_ item: T) {
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
    
    #warning("TODO: Quality of life - if tap on a Freecell card when another Freecell card is selected, select new Freecell card.")
    private func handleTap(in location: CardLocation) {
        switch selectionState {
        case .idle:
            selectedCard = location.selectableCard()
        case .selected(let card):
            do {
                registerMove()
                try _board.performValidMove(from: card, to: location)
                selectedCard = nil
            } catch {
                previousBoards.removeLast()
                #if os(macOS)
                NSSound.beep()
                #endif
                selectedCard = nil
                print(error.localizedDescription)
            }
        }
    }
}

public class ModernViewDriver: BoardViewDriver {
    public override var allCards: [Card] {
        return freecells.flatMap({ $0.items }) +
            foundations.flatMap({ $0.items }) +
            columns.flatMap({ $0.items })
    }
    
    public override func location(containing card: Card) -> CardLocation {
        return renderingBoard.location(containing: card)
    }

    public override func itemTapped<T>(_ item: T) {
        print("itemTapped, I do nothing")
    }
}
