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

//class Game {
//    var board = Board()
    
//    var cancellable: AnyCancellable?
//    init() {
//        cancellable = board.objectWillChange.sink { _ in
//            print("Board published a value")
//            self.objectWillChange.send()
//        }
//    }
//}

struct GameView: View {
    var board = Board()
    
    var body: some View {
        ZStack(alignment: .top) {
            WindowView()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        
            VStack(spacing: 60.0) {
                HStack {
                    HStack {
                        ForEach(board.freecells) { freeCell in
                            FreeCellView(freeCell: freeCell)
                                .frame(width: 125, height: 187)
                        }
                    }
                    Spacer()
                    HStack {
                        ForEach(board.foundations) { foundation in
                            FoundationView(foundation: foundation)
                                .frame(width: 125, height: 187)
                        }
                    }
                }
                
                HStack(spacing: 20.0) {
                    ForEach(board.columns) { column in
                        ColumnView(column: column)
                    }
                }
                
                Button(action: {
                    let card = self.board.columns[0].pop()
                    self.board.columns[1].setupPush(card!)
//                    self.board.__testPublisher()
                }, label: {
                    Text("Do It")
                        .foregroundColor(.white)
                        .padding()
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.white, lineWidth: 2.0)
                        )
                    }).offset(x: 0, y: 190)
            }.padding(EdgeInsets(top: 40, leading: 20, bottom: 40, trailing: 20))
            
        }.edgesIgnoringSafeArea(.all)
    }
}

struct WindowView: View {
    var body: some View {
        Spacer().background(Color.green)
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        GameView()
            .previewDevice("iPad Pro 11")
            .previewLayout(.fixed(width: 1194, height: 834))
    }
}
