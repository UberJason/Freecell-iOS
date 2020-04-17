//
//  MiniBoard.swift
//  FreecellKit
//
//  Created by Jason Ji on 4/17/20.
//  Copyright © 2020 Jason Ji. All rights reserved.
//

import SwiftUI

struct MiniBoard: View, Content {
    let id = UUID()
    let cornerRadius: CGFloat = 4.0
    let cardSize = CGSize(width: 55, height: 80)
    let board = BoardParser().parse(fromFile: "AUI+Screenshots", bundle: Bundle.freecellKit)!
    
    var body: some View {
        VStack {
            HStack {
                miniFreecells
                Spacer()
                miniFoundations
            }
            miniColumns
        }
        .padding(8)
    }
    
    var miniFreecells: some View {
        FreecellsContent(cornerRadius: cornerRadius, cardSize: cardSize)
    }
    
    var miniFoundations: some View {
        VStack {
            HStack(spacing: 2) {
                ForEach(0..<4) { _ in
                    EmptySpotView(cornerRadius: self.cornerRadius).frame(size: self.cardSize)
                }
            }
            Text("Foundations").font(.system(.body)).foregroundColor(.white).bold()
        }
    }
    
    var miniColumns: some View {
        VStack {
            ColumnsContent(
                cardSize: cardSize,
                titleSize: 16,
                tabPadding: 2.0,
                cornerRadius: cornerRadius,
                columnSpacing: 8,
                stackSpacing: 25,
                highlightAvailableCard: false,
                columns: board.columns
            )
            Text("Columns").font(.system(.body)).foregroundColor(.white).bold()
        }
    }
}
