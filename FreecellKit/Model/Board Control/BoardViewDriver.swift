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

class ColumnExpansionState {
    let id: String
    var isCollapsed = false
    
    init(id: String) {
        self.id = id
    }
}

public class BoardViewDriver: ObservableObject {
    public var freecells: [FreeCell] { return renderingBoard.freecells }
    public var foundations: [Foundation] { return renderingBoard.foundations }
    public var columns: [Column] { return renderingBoard.columns }
    private var columnTilingStates: [ColumnExpansionState]
    
    @Published public var renderingBoard: Board
    
    public var controlStyle: ControlStyle = .modern {
        didSet {
            configureControlManager()
        }
    }
    
    weak var gameStateProvider: GameStateProvider?
    lazy var controlManager: ControlManager = ModernControlManager(boardProvider: self)
 
    public var allCards: [Card] {
        return freecells.flatMap({ $0.items }) +
        foundations.flatMap({ $0.items }) +
        columns.flatMap({ $0.items })
    }
    
    internal var animationOffsetInterval = 75
    internal var moveEventSubscriber: AnyCancellable?
    internal var cancellable = Set<AnyCancellable>()
    internal var undoManager: UndoManager?
    internal var _board = Board(deck: Deck(shuffled: true))
    internal var previousBoards = [Board]()
    
    #warning("Investigate memory leaks")
    public init(controlStyle: ControlStyle, gameStateProvider: GameStateProvider, undoManager: UndoManager? = nil) {
        self.controlStyle = controlStyle
        self.gameStateProvider = gameStateProvider
        self.undoManager = undoManager
        
        renderingBoard = _board.copy
        
        columnTilingStates = _board.columns.map { ColumnExpansionState(id: $0.id) }
        
        configureControlManager()
        configureRendering()
    }
    
    private func configureControlManager() {
        switch controlStyle {
        case .classic:
            controlManager = ClassicControlManager(boardProvider: self)
        case .modern:
            controlManager = ModernControlManager(boardProvider: self)
        }
    }
    
    private func configureRendering() {
        renderingBoard = _board.copy
        
        // Assign seems to cause a memory leak, so I'm using sink instead:
        // https://forums.swift.org/t/does-assign-to-produce-memory-leaks/29546
        _board.movePublisher
            .modulated(.milliseconds(animationOffsetInterval), scheduler: RunLoop.main)
            .map { $0.afterBoard }
            .sink { [weak self] in
                guard let self = self else { return }
                self.renderingBoard = $0
                if $0.isCompleted {
                    self.gameStateProvider?.win()
                }
            }
            .store(in: &cancellable)
        
        NotificationCenter.default
            .publisher(for: .updateControlStyle)
            .decode(to: ControlStyle.self)
            .sink(receiveCompletion: { _ in }, receiveValue: { [unowned self] result in
                self.controlStyle = result
            })
            .store(in: &cancellable)
    }
    
    public func undo() {
        undoManager?.undo()
    }
    
    @objc func performUndo() {
        guard previousBoards.count > 0 else { return }
        gameStateProvider?.decrementMoves()
        
        setBoard(previousBoards.removeLast())
    }
    
    public func restartGame() {
        guard let first = previousBoards.first else { return }
        previousBoards = []

        setBoard(first)
    }
    
    private func setBoard(_ board: Board) {
        _board = board
        configureRendering()
    }
    
    func clearUndoStack() {
        previousBoards = []
    }

}

// MARK: - Column Expansion State -
extension BoardViewDriver: StackOffsetting {
    var cardSize: CGSize {
        //        return CGSize(width: 125, height: 187)  // iPad Pro
        //        return CGSize(width: 107, height: 160)  // iPad Mini
        CGSize(width: 100, height: 145)  // iPad Mini, reduced
    }
    
    var defaultColumnSpacing: CGFloat {
        40.0
    }
    
    func columnIsCollapsed(_ id: String) -> Bool {
        return columnTilingStates.filter({ $0.id == id }).first?.isCollapsed ?? false
    }
    
    func tilingButtonVisible(for column: Column) -> Bool {
        #if os(iOS)
        return SpacingCalculator().stackRequiresCompression(column.items.count, cardHeight: cardSize.height)
        #else
        return false
        #endif
    }

    func setTilingState(for columnId: String, isCollapsed: Bool) {
        columnTilingStates.filter({ $0.id == columnId }).first?.isCollapsed = isCollapsed
        objectWillChange.send()
    }
}

// MARK: - Control Manager Passthrough -
extension BoardViewDriver {
    func cell(containing card: Card) -> Cell {
        return renderingBoard.cell(containing: card)
    }
    
    func itemTapped<T>(_ item: T) {
        controlManager.itemTapped(item)
    }
    
    func scale(for card: Card) -> CGFloat {
        return controlManager.scale(for: card)
    }
    
    func cardOverlayColor(for card: Card) -> Color {
        return controlManager.cardOverlayColor(for: card)
    }
    
    func dragStarted(from card: Card) {
        controlManager.dragStarted(from: card)
    }
    
    func dragEnded(with translation: CGSize) {
        controlManager.dragEnded(with: translation)
    }
    
    func cardOffset(for card: Card, relativeTo bounds: CGRect, dragState: BoardView.DragState? = nil) -> CGSize {
        return controlManager.cardOffset(for: card, relativeTo: bounds, dragState: dragState)
    }
    
    func zIndex(for card: Card) -> Double {
        return controlManager.zIndex(for: card)
    }
    
    func storeCellPositions(_ anchors: [CellInfo], using geometry: GeometryProxy) {
        controlManager.storeCellPositions(anchors, using: geometry)
    }
    
    var dragGestureAvailable: Bool { return controlManager.dragGestureAvailable }
}

// MARK: - BoardProvider -
extension BoardViewDriver: BoardProvider {
    var board: Board { return _board }

    func registerMove() {
        gameStateProvider?.incrementMoves()
        previousBoards.append(_board.copy)
        undoManager?.registerUndo(withTarget: self, selector: #selector(performUndo), object: nil)
    }
    
    func rollbackFailedMove(with error: Error) {
        previousBoards.removeLast()
        gameStateProvider?.decrementMoves()
        #if os(macOS)
        NSSound.beep()
        #endif
        print(error.localizedDescription)
    }
    
    func performUpdate() {
        objectWillChange.send()
    }
    
    func cardSpacing(for column: Column) -> CGFloat {
        #if os(iOS)
        let calculator = SpacingCalculator()
        guard calculator.stackRequiresCompression(column.items.count, cardHeight: cardSize.height) else { return defaultColumnSpacing }
        
        let isCollapsed = columnIsCollapsed(column.id)
        let optimalSpacing = calculator.spacingThatFits(calculator.availableVerticalSpace(bottomPadding: 20), cardHeight: cardSize.height, numberOfCards: column.items.count)
        
        return isCollapsed ? optimalSpacing : SpacingConstants.defaultSpacing
        #else
        return SpacingConstants.defaultSpacing
        #endif
    }
}
