//
//  GameView.swift
//  Freecell
//
//  Created by Jason Ji on 11/13/19.
//  Copyright © 2019 Jason Ji. All rights reserved.
//

import SwiftUI
import DeckKit
import FreecellKit
import Combine

#warning("CMD+Z on iPad causes two undo actions")
class Game: ObservableObject {
    var undoManager: UndoManager?
    @Published var boardDriver: BoardViewDriver
    
    init(undoManager: UndoManager? = nil) {
        self.undoManager = undoManager
        self.boardDriver = ClassicViewDriver(undoManager: undoManager)
    }
}

struct GameView: View {
    @ObservedObject var game: Game
    
    var body: some View {
        BoardView(boardDriver: game.boardDriver)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        GameView(game: Game())
            .previewDevice("iPad Pro 11")
            .previewLayout(.fixed(width: 1194, height: 834))
    }
}
