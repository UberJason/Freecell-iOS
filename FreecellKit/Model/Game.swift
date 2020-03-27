//
//  Game.swift
//  FreecellKit
//
//  Created by Jason Ji on 3/25/20.
//  Copyright © 2020 Jason Ji. All rights reserved.
//

import Combine

public class Game: ObservableObject, GameStateProvider {
    var undoManager: UndoManager?
    @Delayed public var boardDriver: BoardViewDriver
    let store = FreecellStore()
    
    @Published public private(set) var gameState = GameState.new {
        didSet {
            if gameState == .won {
                handleWinState()
            }
        }
    }
    
    public var moveTimeString: String {
        return (moveTime == 0) ? "00:00" : moveTimerFormatter.string(from: moveTime)!
    }
    
    @Published public var moves: Int = 0
    @Published private var moveTime: TimeInterval = 0.0
    internal var timerCancellable: AnyCancellable?
    
    var moveTimerFormatter: DateComponentsFormatter = {
        let f = DateComponentsFormatter()
        f.allowedUnits = [.minute, .second]
        f.zeroFormattingBehavior = .pad
        f.unitsStyle = .positional
        return f
    }()
    
    var cancellables = Set<AnyCancellable>()
    
    @UserDefault(key: "controlStyle", defaultValue: .default)
    var controlStyle: ControlStyle
    
    public init(undoManager: UndoManager? = nil) {
        self.undoManager = undoManager
        self.boardDriver = BoardViewDriver(controlStyle: controlStyle, gameStateProvider: self, undoManager: undoManager)
        
        NotificationCenter.default
            .publisher(for: .newGame)
            .sink { [unowned self] _ in
                self.resetState()
                self.boardDriver = BoardViewDriver(controlStyle: self.controlStyle, gameStateProvider: self, undoManager: undoManager)
            }
            .store(in: &cancellables)
        
        NotificationCenter.default
            .publisher(for: .restartGame)
            .sink { [weak self] _ in
                self?.moves = 0
                self?.configureMoveTimer()
                self?.boardDriver.restartGame()
            }
            .store(in: &cancellables)
        
        NotificationCenter.default
            .publisher(for: .postLoss)
            .sink { [weak self] _ in self?.postResult(.loss) }
            .store(in: &cancellables)
        
        NotificationCenter.default
            .publisher(for: .postWin)
            .map { _ in GameState.won }
            .sink { [weak self] in self?.gameState = $0 }
            .store(in: &cancellables)
        
        NotificationCenter.default
            .publisher(for: .recordResult)
            .decode(to: JSONGameRecord.self)
            .sink(receiveCompletion: { _ in }, receiveValue: { [weak self] result in
                _ = self?.store.createRecord(from: result)
                try? self?.store.save()
            })
            .store(in: &cancellables)

        configureMoveTimer()
    }
    
    func configureMoveTimer() {
        timerCancellable?.cancel()
        timerCancellable = Timer.publish(every: 1.0, on: .main, in: .common)
            .autoconnect()
            .scan(0.0, { (value, _) in
                value + 1.0
            })
            .map { [weak self] in (time: $0, string: self?.moveTimerFormatter.string(from: $0) ?? "") }
            .sink { [weak self] in
                self?.moveTime = $0.time
            }
    }
    
    func handleWinState() {
        postResult(.win)
        NotificationCenter.default.post(name: .performBombAnimation, object: nil)
        timerCancellable?.cancel()
        boardDriver.handleWinState()
    }
    
    func resetState() {
        gameState = .new
        moves = 0
        moveTime = 0.0
        configureMoveTimer()
    }
    
    private func postResult(_ result: GameResult) {
        let result = JSONGameRecord(result: result, moves: moves, time: moveTime)
        try? NotificationCenter.default.post(.recordResult, value: result)
    }
    
    public func undo() {
        undoManager?.undo()
    }
}

public protocol GameStateProvider: AnyObject {
    var moveTimeString: String { get }
    var moves: Int { get set }
    var gameState: GameState { get }
    
    func incrementMoves()
    func decrementMoves()
    func undo()
}

public extension GameStateProvider {
    func incrementMoves() {
        moves += 1
    }
    func decrementMoves() {
        moves -= 1
    }
}
