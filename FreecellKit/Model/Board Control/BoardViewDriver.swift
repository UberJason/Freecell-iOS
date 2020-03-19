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

public class BoardViewDriver: ObservableObject {
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
    
    public var controlStyle: ControlStyle = .modern {
        didSet {
            configureControlManager()
        }
    }
    
    lazy var controlManager: ControlManager = ModernControlManager(boardProvider: self)
    
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
        return freecells.flatMap({ $0.items }) +
        foundations.flatMap({ $0.items }) +
        columns.flatMap({ $0.items })
    }
    
    internal var animationOffsetInterval = 75
    internal var moveEventSubscriber: AnyCancellable?
    internal var cancellable = Set<AnyCancellable>()
    internal var timerCancellable: AnyCancellable?
    internal var undoManager: UndoManager?
    internal var _board = Board(deck: Deck(shuffled: true))
    internal var previousBoards = [Board]()
    
    public init(controlStyle: ControlStyle, undoManager: UndoManager? = nil) {
        self.controlStyle = controlStyle
        self.undoManager = undoManager
        
        renderingBoard = _board.copy
        
        configureControlManager()
        configureRendering()
        configureMoveTimer()
    }
    
    internal func configureControlManager() {
        switch controlStyle {
        case .classic:
            controlManager = ClassicControlManager(boardProvider: self)
        case .modern:
            controlManager = ModernControlManager(boardProvider: self)
        }
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
        
        NotificationCenter.default
            .publisher(for: .updateControlStyle)
            .compactMap { $0.userInfo?["controlStyle"] as? String }
            .compactMap { ControlStyle(rawValue: $0) }
            .sink { [unowned self] in
                self.controlStyle = $0
            }
            .store(in: &cancellable)
    }
    
    public func undo() {
        undoManager?.undo()
    }
    
    public func redo() {
        print("Redo...")
    }
    
    @objc internal func performUndo() {
        guard previousBoards.count > 0 else { return }
        moves -= 1
        
        setBoard(previousBoards.removeLast())
    }
    
    public func restartGame() {
        guard let first = previousBoards.first else { return }
        previousBoards = []
        moves = 0
        moveTimeString = "00:00"
        configureMoveTimer()
        setBoard(first)
    }
    
    private func setBoard(_ board: Board) {
        _board = board
        configureRendering()
    }
    
    private func handleWinState() {
        previousBoards = []
        NotificationCenter.default.post(name: .recordWin, object: nil)
        NotificationCenter.default.post(name: .performBombAnimation, object: nil)
        timerCancellable?.cancel()
    }
    
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

extension BoardViewDriver: BoardProvider {
    var board: Board { return _board }

    func registerMove() {
        moves += 1
        previousBoards.append(_board.copy)
        undoManager?.registerUndo(withTarget: self, selector: #selector(performUndo), object: nil)
    }
    
    func rollbackFailedMove(with error: Error) {
        previousBoards.removeLast()
        moves -= 1
        #if os(macOS)
        NSSound.beep()
        #endif
        print(error.localizedDescription)
    }
    
    func performUpdate() {
        objectWillChange.send()
    }
}