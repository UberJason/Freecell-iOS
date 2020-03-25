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
    @Published var boardDriver = BoardViewDriver(controlStyle: .modern)
    let store = FreecellStore()
    
    var cancellables = Set<AnyCancellable>()
    
    @UserDefault(key: "controlStyle", defaultValue: .modern)
    var controlStyle: ControlStyle
    
    init(undoManager: UndoManager? = nil) {
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

struct ContentView: View, GameAlerting {
    enum AlertType {
        case newGame, restartGame
    }
    
    @ObservedObject var game: Game
    @State var alertShowing = false
    @State var alertType = AlertType.newGame
    
    var body: some View {
        GameView(boardDriver: game.boardDriver)
            .onReceive(NotificationCenter.default.publisher(for: .newGameRequested)) { _ in
                self.alertType = .newGame
                self.alertShowing.toggle()
            }
            .onReceive(NotificationCenter.default.publisher(for: .restartGameRequested)) { _ in
                self.alertType = .restartGame
                self.alertShowing.toggle()
            }
            .alert(isPresented: $alertShowing) {
                switch alertType {
                case .newGame:
                    return newGameAlert()
                case .restartGame:
                    return restartGameAlert()
                }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(game: Game())
            .previewDevice("iPad mini")
            .previewLayout(.fixed(width: 1024, height: 768))
    }
}
