//
//  GameView.swift
//  FreecellKit
//
//  Created by Jason Ji on 2/23/20.
//  Copyright © 2020 Jason Ji. All rights reserved.
//

import SwiftUI
import DeckKit

public struct GameView: View {
    @ObservedObject var boardDriver: BoardViewDriver
    
    public init(boardDriver: BoardViewDriver) {
        self.boardDriver = boardDriver
    }
    
    public var body: some View {
        ZStack {
            BoardView(boardDriver: boardDriver)
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
            if boardDriver.gameState == .won {
                YouWinView()
                    .offset(x: 0, y: 100)
                    .environmentObject(boardDriver)
                    .animation(.default)
                    .transition(.opacity)
            }
            #endif

        }.edgesIgnoringSafeArea(.all)
    }
}

struct GameView_Previews: PreviewProvider {
    static let driver: BoardViewDriver = {
        let d = BoardViewDriver(controlStyle: .modern)
        d._board = Board.preconfigured(withFreecells: (0..<4).map { _ in FreeCell() },
                                       foundations: [
                                        Foundation(topCard: Card.king.ofClubs)!,
                                        Foundation(topCard: Card.king.ofDiamonds)!,
                                        Foundation(topCard: Card.king.ofHearts)!,
                                        Foundation(topCard: Card.king.ofSpades)!
                                        ],
                                       columns: (0...7).map { _ in Column() })
        d.renderingBoard = d._board
        d.gameState = .won
        return d
    }()
    
    static var previews: some View {
        Group {
        GameView(boardDriver: driver)
            .previewDevice("iPad Mini")
            .previewLayout(.fixed(width: 1024, height: 768))
        GameView(boardDriver: driver)
            .previewDevice("iPad Pro 11")
            .previewLayout(.fixed(width: 1194, height: 834))
        }
    }
}
