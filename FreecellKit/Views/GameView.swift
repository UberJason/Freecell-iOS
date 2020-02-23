//
//  GameView.swift
//  FreecellKit
//
//  Created by Jason Ji on 2/23/20.
//  Copyright © 2020 Jason Ji. All rights reserved.
//

import SwiftUI

public struct GameView: View {
    @ObservedObject var boardDriver: BoardViewDriver
    
    public init(boardDriver: BoardViewDriver) {
        self.boardDriver = boardDriver
    }
    
    public var body: some View {
        ZStack {
            BoardView(boardDriver: boardDriver)
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
            YouWinView()
            .offset(x: 0, y: 300)

        }.edgesIgnoringSafeArea(.all)
    }
}

struct GameView_Previews: PreviewProvider {
    static var previews: some View {
        GameView(boardDriver: ClassicViewDriver())
    }
}
