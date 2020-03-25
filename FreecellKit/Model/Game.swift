//
//  Game.swift
//  FreecellKit
//
//  Created by Jason Ji on 3/25/20.
//  Copyright © 2020 Jason Ji. All rights reserved.
//

import Combine

public class Game: ObservableObject {
    var undoManager: UndoManager?
    @Published public var boardDriver = BoardViewDriver(controlStyle: .modern)
    let store = FreecellStore()
    
    var cancellables = Set<AnyCancellable>()
    
    @UserDefault(key: "controlStyle", defaultValue: .modern)
    var controlStyle: ControlStyle
    
    public init(undoManager: UndoManager? = nil) {
        self.undoManager = undoManager
        self.boardDriver = BoardViewDriver(controlStyle: controlStyle, undoManager: undoManager)
        
        NotificationCenter.default
            .publisher(for: .newGame)
            .sink { [unowned self] _ in
                self.boardDriver = BoardViewDriver(controlStyle: self.controlStyle, undoManager: undoManager)
            }
            .store(in: &cancellables)
        
        NotificationCenter.default
            .publisher(for: .restartGame)
            .sink { [weak self] _ in
                self?.boardDriver.restartGame()
            }
            .store(in: &cancellables)
        
        NotificationCenter.default
            .publisher(for: .recordResult)
            .decode(to: JSONGameRecord.self)
            .sink(receiveCompletion: { _ in }, receiveValue: { [weak self] result in
                _ = self?.store.createRecord(from: result)
                try? self?.store.save()
            })
            .store(in: &cancellables)
    }
}
