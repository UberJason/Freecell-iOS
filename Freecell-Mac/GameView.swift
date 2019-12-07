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

class Game {
    var boardDriver = BoardDriver()
}

struct GameView: View {
    var game = Game()
    
    var body: some View {
        BoardView(boardDriver: game.boardDriver)
//        .onCommand(<#T##selector: Selector##Selector#>, perform: <#T##(() -> Void)?##(() -> Void)?##() -> Void#>)
    }
}

struct GameView_Previews: PreviewProvider {
    static var previews: some View {
        GameView()
            .previewDevice("iPad Pro 11")
            .previewLayout(.fixed(width: 1194, height: 834))
    }
}
