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
    @Published var boardDriver: BoardViewDriver = ClassicViewDriver()
    
    var cancellable: AnyCancellable?
    
    func connect(_ publisher: AnyPublisher<GameEvent, Never>) {
        cancellable = publisher.sink { [weak self] event in
            switch event {
            case .newGame:
                self?.boardDriver = ClassicViewDriver()
                NotificationCenter.default.post(name: .newGame, object: nil)
            case .undo:
                self?.boardDriver.undo()
            case .redo:
                print("Redo event received")
            }
            
        }
    }
}

struct GameView: View {
    @ObservedObject var game = Game()
    
    init(gameEventPublisher: AnyPublisher<GameEvent, Never>) {
        game.connect(gameEventPublisher)
    }
    
    var body: some View {
        BoardView(boardDriver: game.boardDriver)
    }
}

struct GameView_Previews: PreviewProvider {
    static var previews: some View {
        GameView(gameEventPublisher: PassthroughSubject<GameEvent, Never>().eraseToAnyPublisher())
            .previewDevice("iPad Pro 11")
            .previewLayout(.fixed(width: 1194, height: 834))
    }
}
