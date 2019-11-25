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
                                .frame(width: self.cardSize.width, height: self.cardSize.height)
                                .onTapGesture {
                                    self.board.handleTap(from: freeCell)
                                }
                        }
                    }
                    
                    Spacer()
                    
                    HStack {
                        ForEach(board.foundations) { foundation in
                            FoundationView(foundation: foundation)
                                .frame(width: self.cardSize.width, height: self.cardSize.height)
                                .onTapGesture {
                                    self.board.handleTap(from: foundation)
                                }
                        }
                    }
                }
                
                HStack(spacing: 20.0) {
                    ForEach(board.columns) { column in
                        ColumnView(column: column, selected: self.$board.selectedCard, onTapHandler: self.board.handleTap(from:))
                            .frame(width: self.cardSize.width, height: self.cardSize.height)
                            .onTapGesture {
                                self.board.handleTap(from: column)
                            }
                    }
                }
            }.padding(EdgeInsets(top: 40, leading: 20, bottom: 40, trailing: 20))
            
        }.edgesIgnoringSafeArea(.all)
    }
    
    var cardSize: CGSize {
//        return CGSize(width: 125, height: 187)
        return CGSize(width: 107, height: 160)
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
