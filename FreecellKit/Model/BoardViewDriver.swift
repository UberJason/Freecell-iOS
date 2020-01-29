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
import SwiftUI
#if os(macOS)
import Cocoa
#endif

enum SelectionState {
    case idle, selected(card: Card)
}

public class BoardViewDriver: ObservableObject {
    public var freecells: [FreeCell] { return renderingBoard.freecells }
    public var foundations: [Foundation] { return renderingBoard.foundations }
    public var columns: [Column] { return renderingBoard.columns }
    
    @Published public var renderingBoard: Board
    
    public var allCards: [Card] {
        fatalError("implement in subclass")
    }
    
    internal var animationOffsetInterval = 75
    internal var moveEventSubscriber: AnyCancellable?
    internal var undoManager: UndoManager?
    internal var _board = Board(deck: Deck(shuffled: true))
    internal var previousBoards = [Board]()
    
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
    
    public func cell(containing card: Card) -> Cell {
        fatalError("Implement in subclass")
    }
    
    public func itemTapped<T>(_ item: T) {}
    
    public func scale(for card: Card) -> CGFloat {
        fatalError("Implement in subclass")
    }
    
    public func cardOverlayColor(for card: Card) -> Color {
        fatalError("Implement in subclass")
    }
    
    public func dragStarted(from card: Card) {}
    
    public func dragEnded(with translation: CGSize) {}
    
    #warning("cardOffset(for:relativeTo:stackOffset:dragState:) is leaking details about drag to boards that don't have drag. How can I fix this?")
    public func cardOffset(for card: Card, relativeTo bounds: CGRect, dragState: BoardView.DragState? = nil) -> CGSize {
        fatalError("Implement in subclass")
    }
}

public class ClassicViewDriver: BoardViewDriver {
    // Because selectedCard isn't directly referenced in BoardView, we have to manually send the change notification.
    // @Published apparently doesn't do the trick.
    public var selectedCard: Card? {
        willSet {
            objectWillChange.send()
        }
    }
    
    var selectionState: SelectionState { selectedCard.map { .selected(card: $0) } ?? .idle }
    
    public override var allCards: [Card] {
        return freecells.flatMap({ $0.items }) +
            foundations.flatMap({ $0.items }) +
            columns.flatMap({ $0.items })
    }
    
    public override func cell(containing card: Card) -> Cell {
        return renderingBoard.cell(containing: card)
    }

    public override func itemTapped<T>(_ item: T) {
        switch item {
        case let card as Card:
            handleTap(in: _board.cell(containing: card))
        case let location as Cell:
            handleTap(in: _board.cell(for: location.id))
        case _ as BoardView:
            selectedCard = nil
        default:
            break
        }
    }
    
    #warning("TODO: Quality of life - if tap on a Freecell card when another Freecell card is selected, select new Freecell card.")
    private func handleTap(in location: Cell) {
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
    
    public override func scale(for card: Card) -> CGFloat {
        return card == selectedCard ? 1.05 : 1.0
    }
    
    public override func cardOverlayColor(for card: Card) -> Color {
        return selectedCard == card ? .yellow : .clear
    }
    
    public override func cardOffset(for card: Card, relativeTo bounds: CGRect, dragState: BoardView.DragState? = nil) -> CGSize {
        return .zero
    }
}

public class ModernViewDriver: BoardViewDriver {
    public override var allCards: [Card] {
        return freecells.flatMap({ $0.items }) +
            foundations.flatMap({ $0.items }) +
            columns.flatMap({ $0.items })
    }
    
    public var draggingStack: CardStack?
    private var cellPositions = [CellPosition]()
    
    public override func cell(containing card: Card) -> Cell {
        return renderingBoard.cell(containing: card)
    }

    public override func itemTapped<T>(_ item: T) {
        // HACK - quick - move card to a valid location
        if let card = item as? Card {
            for column in _board.columns {
                if column.canReceive(card) {
                    registerMove()
                    try! _board.move(card, to: column)
                    return
                }
            }
        }
    }
    
    public override func scale(for card: Card) -> CGFloat {
        return 1.0
    }
    
    public override func cardOverlayColor(for card: Card) -> Color {
        return .clear
    }
    
    public override func dragStarted(from card: Card) {
        if let origin = cell(containing: card) as? Column,
            let substack = origin.validSubstack(cappedBy: card) {
            draggingStack = substack
        }
    }
    
    public override func dragEnded(with translation: CGSize) {
        // Algorithm:
        // - Use draggingStack's bottomItem
        // - Find cell(containing:) that item
        // - Get that cell's center from cellPositions
        // - Use translation to determine dragged card's final position
        // - PRINT dragged card's final position
        // - Compute distance from every cell's position and sort; closest cell is intended target
        // - PRINT intended target
        // - Model updates to try to move the draggingStack to the intended target
        
        guard let baseCard = draggingStack?.bottomItem else { return }
        let containingCell = _board.cell(containing: baseCard)
        
        guard let containingCellPosition = cellPositions.filter({ $0.cellId == containingCell.id }).first?.position else { return }
        let baseCardPosition = containingCellPosition.position(byAdding: translation)
        
        let relativeDistances = cellPositions
            .map { CellDistance(cellId: $0.cellId, distance: $0.position.distance(from: baseCardPosition)) }
            .sorted { $0.distance < $1.distance }
        
        guard let closestCellId = relativeDistances.first?.cellId else { return }
        let closestCell = _board.cell(for: closestCellId)
        
        //****************************************************//
        
        if let closestCell = closestCell as? FreeCell {
            print("Freecell: \(_board.freecells.firstIndex(where: { $0.id == closestCell.id })!)")
        }
        if let closestCell = closestCell as? Foundation {
            print("Foundation: \(_board.foundations.firstIndex(where: { $0.id == closestCell.id })!)")
        }
        if let closestCell = closestCell as? Column {
            print("Closest cell: \(closestCell)")
        }
        
//        try! _board.move(baseCard, to: closestCell)
        //****************************************************//
        draggingStack = nil
    }
    
    public override func cardOffset(for card: Card, relativeTo bounds: CGRect, dragState: BoardView.DragState? = nil) -> CGSize {
        var dragOffset = CGSize.zero
        
        if case .active(let translation) = dragState, let draggingStack = draggingStack, draggingStack.items.contains(card) {
            dragOffset = translation
        }
        
        return CGSize(width: dragOffset.width, height: dragOffset.height)
    }
    
    public func storeCellPositions(_ anchors: [CellInfo], using geometry: GeometryProxy) {
        if cellPositions.isEmpty {
            cellPositions = anchors.map { CellPosition(cellId: $0.cellId, position: geometry[$0.bounds].center) }
        }
    }
}
