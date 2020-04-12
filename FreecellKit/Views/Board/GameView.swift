//
//  GameView.swift
//  FreecellKit
//
//  Created by Jason Ji on 2/23/20.
//  Copyright © 2020 Jason Ji. All rights reserved.
//

import SwiftUI
import DeckKit

public struct GameView: View, GameAlerting {

    @ObservedObject var game: Game
    
    public init(game: Game) {
        self.game = game
    }
    
    public var body: some View {
        ZStack {
            BackgroundColorView()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            BoardView(boardDriver: game.boardDriver)
            #if os(iOS)
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
            if game.gameState == .won {
                YouWinView()
                    .offset(x: 0, y: 100)
                    .environmentObject(game.boardDriver)
                    .animation(.default)
                    .transition(.opacity)
            }
            #endif
            }.conditionalEdgesIgnoringSafeArea()
        .overlayPreferenceValue(TopStackBoundsKey.self) { preferences in
            #if os(macOS)
            EmptyView()
            #else
            GeometryReader { geometry in
                ControlsView(timeString: self.game.moveTimeString, moves: self.game.moves, gameManager: self.game)
                    .position(geometry[preferences.bounds!].center)
                self.game.currentMessageBubble.map {
                    MessageView(message: $0.message)
                        .id($0.id)
                        .position(CGPoint(x: geometry[preferences.bounds!].center.x, y: geometry[preferences.bounds!].origin.y))
                        .offset(x: 0, y: -20)
                        .transition(AnyTransition.opacity.animation(.easeInOut(duration: 1.0)))
                }
                
            }
            #endif
        }
        .alert(isPresented: $game.presentAlert) {
            switch game.alertType {
            case .newGame:
                return newGameAlert()
            case .restartGame:
                return restartGameAlert()
            }
        }
    }
}

extension View {
    func conditionalEdgesIgnoringSafeArea() -> some View {
        #if targetEnvironment(macCatalyst)
        return edgesIgnoringSafeArea([.leading, .trailing, .bottom])
        #else
        return edgesIgnoringSafeArea(.all)
        #endif
    }
}

struct GameView_Previews: PreviewProvider {
    static let game: Game = {
        let g = Game()
        
        let d = BoardViewDriver(controlStyle: .modern, gameStateProvider: g)
        d._board = Board.preconfigured(withFreecells: (0..<4).map { _ in FreeCell() },
                                       foundations: [
                                        Foundation(topCard: Card.king.ofClubs)!,
                                        Foundation(topCard: Card.king.ofDiamonds)!,
                                        Foundation(topCard: Card.king.ofHearts)!,
                                        Foundation(topCard: Card.king.ofSpades)!
                                        ],
                                       columns: (0...7).map { _ in Column() })
        d.renderingBoard = d._board
        
        g.boardDriver = d
        return g
    }()
    
    static var previews: some View {
        Group {
            GameView(game: game)
                .previewDevice("iPad Mini")
                .previewLayout(.fixed(width: 1024, height: 768))
            GameView(game: game)
                .previewDevice("iPad Pro 11")
                .previewLayout(.fixed(width: 1194, height: 834))
        }
    }
}

struct MessageView: View {
    let message: String
    
    var body: some View {
        HStack {
            Image(systemName: "xmark.circle")
            Text(message)
        }
        .font(.system(size: 13, weight: .bold))
        .foregroundColor(Color.white)
        .padding(EdgeInsets(top: 4, leading: 12, bottom: 4, trailing: 12))
        .background((Color.yellow))
        .cornerRadius(16)
    }
}
