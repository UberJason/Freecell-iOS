//
//  ContentView.swift
//  Freecell-Mac
//
//  Created by Jason Ji on 11/27/19.
//  Copyright © 2019 Jason Ji. All rights reserved.
//

import SwiftUI
import DeckKit
import FreecellKit
import Combine

class Game: ObservableObject {
    var undoManager: UndoManager?
    @Published var boardDriver: BoardViewDriver
    
    var cancellables = Set<AnyCancellable>()
    
    init(undoManager: UndoManager? = nil) {
        self.undoManager = undoManager
        self.boardDriver = ClassicViewDriver(undoManager: undoManager)
        
        NotificationCenter.default
            .publisher(for: .newGame)
            .sink { [weak self] _ in
                self?.boardDriver = ClassicViewDriver(undoManager: undoManager)
            }
            .store(in: &cancellables)
        
        NotificationCenter.default
        .publisher(for: .performUndo)
        .sink { [weak self] _ in
            self?.boardDriver.undo()
        }
        .store(in: &cancellables)
        
        NotificationCenter.default
        .publisher(for: .performRedo)
        .sink { [weak self] _ in
            print("Redo...")
//            self?.boardDriver.redo()
        }
        .store(in: &cancellables)
    }
}

struct GameView: View {
    @ObservedObject var game: Game
    
    init(game: Game) {
        self.game = game
    }
    
    var body: some View {
        BoardView(boardDriver: game.boardDriver)
    }
}

struct GameView_Previews: PreviewProvider {
    static var previews: some View {
        GameView(game: Game())
            .previewDevice("iPad Pro 11")
            .previewLayout(.fixed(width: 1194, height: 834))
    }
}
