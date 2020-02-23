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

class Game: ObservableObject {
    var undoManager: UndoManager?
    @Published var boardDriver: BoardViewDriver
    
    init(undoManager: UndoManager? = nil) {
        self.undoManager = undoManager
        self.boardDriver = ModernViewDriver(undoManager: undoManager)
    }
}

struct GameView: View {
    @ObservedObject var game: Game
    
    var body: some View {
        ZStack {
            BoardView(boardDriver: game.boardDriver)
            HStack {
                EmojiBombView()
                    .frame(width: 300, height: 200)
                    .offset(x: 0, y: 70)
                EmojiBombView()
                    .frame(width: 300, height: 200)
                    .offset(x: 0, y: -70)
                EmojiBombView()
                    .frame(width: 300, height: 200)
                    .offset(x: 0, y: 70)
                }.offset(x: 0, y: -50)
                .allowsHitTesting(false)
        }.edgesIgnoringSafeArea(.all)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        GameView(game: Game())
            .previewDevice("iPad Pro 11")
            .previewLayout(.fixed(width: 1194, height: 834))
    }
}
