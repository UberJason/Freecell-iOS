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

struct ContentView: View {
    @ObservedObject var game: Game
    
    var body: some View {
        GameView(game: game)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(game: Game())
            .previewDevice("iPad mini")
            .previewLayout(.fixed(width: 1024, height: 768))
    }
}
