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

public enum GameState {
    case new, inProgress, won
    var title: String {
        switch self {
        case .new: return "New"
        case .inProgress: return "In Progress"
        case .won: return "Won"
        }
    }
}

public class BoardViewDriver: ObservableObject, StackOffsetting {
    public var freecells: [FreeCell] { return renderingBoard.freecells }
    public var foundations: [Foundation] { return renderingBoard.foundations }
    public var columns: [Column] { return renderingBoard.columns }
    
    @Published public var renderingBoard: Board
    public var gameState = GameState.new {
        didSet {
            if gameState == .won {
                handleWinState()
            }
        }
    }
    
    var moveTimerFormatter: DateComponentsFormatter = {
        let f = DateComponentsFormatter()
        f.allowedUnits = [.minute, .second]
        f.zeroFormattingBehavior = .pad
        f.unitsStyle = .positional
        return f
    }()
    
    @Published public var moveTimeString: String = "00:00"
    @Published public var moves: Int = 0
    
    public var allCards: [Card] {
        fatalError("implement in subclass")
    }
    
    internal var animationOffsetInterval = 75
    internal var moveEventSubscriber: AnyCancellable?
    internal var cancellable = Set<AnyCancellable>()
    internal var timerCancellable: AnyCancellable?
    internal var undoManager: UndoManager?
    internal var _board = Board(deck: Deck(shuffled: true))
    internal var previousBoards = [Board]()
    
    public init(undoManager: UndoManager? = nil) {
        self.undoManager = undoManager
        renderingBoard = _board.copy
        configureRendering()
        configureMoveTimer()
    }
    
    internal func configureMoveTimer() {
        timerCancellable = Timer.publish(every: 1.0, on: .main, in: .common)
            .autoconnect()
            .scan(0.0, { (value, _) in
                value + 1.0
            })
            .map { [weak self] in self?.moveTimerFormatter.string(from: $0) ?? "" }
            .sink { [weak self] in self?.moveTimeString = $0 }
    }
    
    internal func configureRendering() {
        renderingBoard = _board.copy
        
        // Assign seems to cause a memory leak, so I'm using sink instead:
        // https://forums.swift.org/t/does-assign-to-produce-memory-leaks/29546
        _board.movePublisher
            .modulated(.milliseconds(animationOffsetInterval), scheduler: RunLoop.main)
            .map { $0.afterBoard }
            .sink { [weak self] in
                guard let self = self else { return }
                self.renderingBoard = $0
                self.gameState = $0.isCompleted ? .won : .inProgress
            }
            .store(in: &cancellable)
    }
    
    internal func registerMove() {
        moves += 1
        previousBoards.append(_board.copy)
        undoManager?.registerUndo(withTarget: self, selector: #selector(performUndo), object: nil)
    }
    
    public func undo() {
        undoManager?.undo()
    }
    
    public func redo() {
        print("Redo...")
    }
    
    public func restartGame() {
        guard let first = previousBoards.first else { return }
        previousBoards = []
        moves = 0
        moveTimeString = "00:00"
        configureMoveTimer()
        setBoard(first)
    }
    
    @objc internal func performUndo() {
        guard previousBoards.count > 0 else { return }
        moves -= 1
        
        setBoard(previousBoards.removeLast())
    }
    
    internal func setBoard(_ board: Board) {
        _board = board
        configureRendering()
    }
    
    internal func handleWinState() {
        previousBoards = []
        NotificationCenter.default.post(name: .performBombAnimation, object: nil)
        timerCancellable?.cancel()
    }
    
    func rollbackFailedMove(with error: Error) {
        previousBoards.removeLast()
        moves -= 1
        #if os(macOS)
        NSSound.beep()
        #endif
        print(error.localizedDescription)
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
    
    public func zIndex(for card: Card) -> Double {
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
                rollbackFailedMove(with: error)
                selectedCard = nil
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
    
    public override func zIndex(for card: Card) -> Double {
        return 0
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
        guard let card = item as? Card else { return }
  
        do {
            registerMove()
            try _board.performValidDirectMove(from: card)
        } catch {
            rollbackFailedMove(with: error)
        }
    }
    
    public override func scale(for card: Card) -> CGFloat {
        return 1.0
    }
    
    public override func cardOverlayColor(for card: Card) -> Color {
        return .clear
    }
    
    public override func dragStarted(from card: Card) {
        draggingStack = _board.substack(cappedBy: card)
    }
    
    public override func dragEnded(with translation: CGSize) {
        defer { self.draggingStack = nil }
        
        guard let draggingStack = draggingStack,
            let baseCard = draggingStack.bottomItem else { return }
        
        // Find the absolute position of the base card of the dragging stack given the translation.
        let containingCell = _board.cell(containing: baseCard)
        let baseCardPosition = position(for: baseCard, translatedBy: translation)
        
        // The target cell is the cell whose position is closest to the base card position.
        let targetCell = closestCell(to: baseCardPosition)
        
        guard targetCell.id != containingCell.id else { return }

        do {
            registerMove()
            try _board.performDirectStackMovement(of: draggingStack, from: containingCell, to: targetCell)
        } catch {
            rollbackFailedMove(with: error)
        }
    }
    
    private func position(for card: Card, translatedBy translation: CGSize = .zero) -> CGPoint {
        let containingCell = _board.cell(containing: card)
        guard let containingCellPosition = cellPositions.filter({ $0.cellId == containingCell.id }).first?.position else { return .zero }
        
        var cardPosition = containingCellPosition
        if let column = containingCell as? Column {
            let stackOffset = self.stackOffset(for: card, orderIndex: column.orderIndex(for: card))
            cardPosition = cardPosition.position(byAdding: stackOffset)
        }
        
        return cardPosition.position(byAdding: translation)
    }
    
    private func closestCell(to position: CGPoint) -> Cell {
        let relativeDistances = cellPositions
            .map { CellDistance(cellId: $0.cellId, distance: $0.position.distance(from: position)) }
            .sorted { $0.distance < $1.distance }
        
        guard let closestCellId = relativeDistances.first?.cellId else { fatalError("No cell found") }
        return _board.cell(for: closestCellId)
    }
    
    public override func cardOffset(for card: Card, relativeTo bounds: CGRect, dragState: BoardView.DragState? = nil) -> CGSize {
        var dragOffset = CGSize.zero
        
        if case .active(let translation) = dragState, let draggingStack = draggingStack, draggingStack.items.contains(card) {
            dragOffset = translation
        }
        
        return CGSize(width: dragOffset.width, height: dragOffset.height)
    }
    
    public override func zIndex(for card: Card) -> Double {
        guard let draggingStack = draggingStack else { return 0 }
        return draggingStack.contains(card) ? 1 : 0
    }
    
    public func storeCellPositions(_ anchors: [CellInfo], using geometry: GeometryProxy) {
        if cellPositions.isEmpty {
            cellPositions = anchors.map { CellPosition(cellId: $0.cellId, position: geometry[$0.bounds].center) }
        }
    }
}
