//
//  BoardView.swift
//  Freecell
//
//  Created by Jason Ji on 11/22/19.
//  Copyright © 2019 Jason Ji. All rights reserved.
//

import SwiftUI
import DeckKit

public struct BoardView: View {
    @ObservedObject var board: Board
    
    public init(board: Board) {
        self.board = board
    }
    
    public var body: some View {
        ZStack(alignment: .top) {
            WindowView()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        
            VStack(spacing: 60.0) {
                HStack {
                    HStack {
                        ForEach(board.freecells) { freeCell in
                            FreeCellView(freeCell: freeCell, selected: self.$board.selectedCard, onTapHandler: self.board.handleTap(from:))
                                .frame(width: 125, height: 187)
                                .onTapGesture {
                                    self.board.handleTap(from: freeCell)
                                }
                        }
                    }
                    Spacer()
                    HStack {
                        ForEach(board.foundations) { foundation in
                            FoundationView(foundation: foundation)
                                .frame(width: 125, height: 187)
                                .onTapGesture {
                                    self.board.handleTap(from: foundation)
                                }
                        }
                    }
                }
                
                HStack(spacing: 20.0) {
                    ForEach(board.columns) { column in
                        ColumnView(column: column, selected: self.$board.selectedCard, onTapHandler: self.board.handleTap(from:))
                            .frame(width: 125, height: 187)
                            .onTapGesture {
                                self.board.handleTap(from: column)
                            }
                    }
                }
                
                HStack {
                    Button(action: {
                        let card = self.board.columns[0].pop()
                        self.board.columns[1].setupPush(card!)
                    }, label: {
                        Text("Column")
                            .foregroundColor(.white)
                            .padding()
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color.white, lineWidth: 2.0)
                            )
                        })
                        .offset(x: 0, y: 190)
                    
                    Button(action: {
                        let card = self.board.columns[0].pop()
                        try! self.board.freecells[0].push(card!)
                    }, label: {
                        Text("FreeCell")
                            .foregroundColor(.white)
                            .padding()
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color.white, lineWidth: 2.0)
                            )
                        })
                        .offset(x: 0, y: 190)
                    
                    Button(action: {
                        let card = self.board.columns[0].pop()
                        try! self.board.foundations[3].push(card!)
                    }, label: {
                        Text("Foundation")
                            .foregroundColor(.white)
                            .padding()
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color.white, lineWidth: 2.0)
                            )
                        })
                        .offset(x: 0, y: 190)
                }
            }.padding(EdgeInsets(top: 40, leading: 20, bottom: 40, trailing: 20))
            
        }.edgesIgnoringSafeArea(.all)
    }
}

struct WindowView: View {
    var body: some View {
        Spacer().background(Color.green)
    }
}

struct BoardView_Previews: PreviewProvider {
    static var previews: some View {
        BoardView(board: Board())
            .previewDevice("iPad Pro 11")
            .previewLayout(.fixed(width: 1194, height: 834))
    }
}
