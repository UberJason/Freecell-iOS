//
//  ContentView.swift
//  Freecell
//
//  Created by Jason Ji on 11/13/19.
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
        self.boardDriver = ModernViewDriver(undoManager: undoManager)
        
        NotificationCenter.default
            .publisher(for: .newGame)
            .sink { [weak self] _ in
                self?.boardDriver = ModernViewDriver(undoManager: undoManager)
            }
            .store(in: &cancellables)
        
        NotificationCenter.default
            .publisher(for: .restartGame)
            .sink { [weak self] _ in
                self?.boardDriver.restartGame()
            }
            .store(in: &cancellables)
    }
}

struct ContentView: View {
    @ObservedObject var game: Game

    var body: some View {
        GameView(boardDriver: game.boardDriver)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(game: Game())
            .previewDevice("iPad mini")
            .previewLayout(.fixed(width: 1024, height: 768))
    }
}
