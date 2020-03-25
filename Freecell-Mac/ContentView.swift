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
        self.boardDriver = BoardViewDriver(controlStyle: .classic, undoManager: undoManager)
        
        NotificationCenter.default
            .publisher(for: .newGame)
            .sink { [weak self] _ in
                self?.boardDriver = BoardViewDriver(controlStyle: .classic, undoManager: undoManager)
            }
            .store(in: &cancellables)
    }
}

struct ContentView: View {
    @ObservedObject var game: Game
    
    init(game: Game) {
        self.game = game
    }
    
    var body: some View {
        BoardView(boardDriver: game.boardDriver)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(game: Game())
            .previewDevice("iPad Pro 11")
            .previewLayout(.fixed(width: 1194, height: 834))
    }
}
