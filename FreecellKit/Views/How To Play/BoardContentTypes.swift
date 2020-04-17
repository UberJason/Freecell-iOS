//
//  BoardContentTypes.swift
//  FreecellKit
//
//  Created by Jason Ji on 4/17/20.
//  Copyright © 2020 Jason Ji. All rights reserved.
//

import SwiftUI
import DeckKit

struct FreecellsContent: View, Content {
    let id = UUID()
    let cornerRadius: CGFloat
    let cardSize: CGSize

    var body: some View {
        miniFreecells
    }
    
    var miniFreecells: some View {
        VStack {
            HStack(spacing: 2) {
                ForEach(0..<4) { _ in
                    EmptySpotView(cornerRadius: self.cornerRadius).frame(size: self.cardSize)
                }
            }
            Text("Freecells").font(.system(.body)).foregroundColor(.white).bold()
        }
    }
}

struct ColumnsContent: View, Content {
    let id = UUID()
    let cardSize: CGSize
    let titleSize: CGFloat
    let tabPadding: CGFloat
    let cornerRadius: CGFloat
    let columnSpacing: CGFloat
    let stackSpacing: CGFloat
    let highlightAvailableCard: Bool
    let columns: [Column]
    
    init(cardSize: CGSize, titleSize: CGFloat, tabPadding: CGFloat = 5.0, cornerRadius: CGFloat = 8.0, columnSpacing: CGFloat, stackSpacing: CGFloat, highlightAvailableCard: Bool = true, columns: [Column]) {
        self.cardSize = cardSize
        self.titleSize = titleSize
        self.tabPadding = tabPadding
        self.cornerRadius = cornerRadius
        self.columnSpacing = columnSpacing
        self.stackSpacing = stackSpacing
        self.highlightAvailableCard = highlightAvailableCard
        self.columns = columns
    }
    
    var body: some View {
        HStack(alignment: .top, spacing: columnSpacing) {
            ForEach(columns) { column in
                ZStack(alignment: .top) {
                    EmptySpotView(cornerRadius: self.cornerRadius)
                        .frame(width: self.cardSize.width, height: self.cardSize.height)
                    ForEach(column.stack) { card in
                        CardView(card: card, titleSize: self.titleSize, tabPadding: self.tabPadding, cornerRadius: self.cornerRadius)
                            .frame(width: self.cardSize.width, height: self.cardSize.height)
                            .overlay(
                                CardRectangle(foregroundColor: self.foregroundColor(for: card, in: column), cornerRadius: self.cornerRadius, opacity: 0.3)
                        )
                            .offset(x: 0, y: self.stackSpacing*CGFloat(column.orderIndex(for: card)))
                            .padding(.bottom, self.stackSpacing*CGFloat(column.orderIndex(for: card)))
                    }
                }
            }
        }.padding([.top, .bottom], 8)
    }
    
    func foregroundColor(for card: Card, in column: Column) -> Color {
        guard highlightAvailableCard else { return .clear }
        return card == column.stack.last ? .yellow : .clear
    }
}

struct FreecellAndColumnContent: View, Content {
    let id = UUID()
    let cardSize: CGSize
    let titleSize: CGFloat
    let tabPadding: CGFloat
    let cornerRadius: CGFloat
    let columnSpacing: CGFloat
    let stackSpacing: CGFloat
    
    init(cardSize: CGSize, titleSize: CGFloat, tabPadding: CGFloat = 5.0, cornerRadius: CGFloat = 8.0, columnSpacing: CGFloat, stackSpacing: CGFloat) {
        self.cardSize = cardSize
        self.titleSize = titleSize
        self.tabPadding = tabPadding
        self.cornerRadius = cornerRadius
        self.columnSpacing = columnSpacing
        self.stackSpacing = stackSpacing
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            FreecellsContent(cornerRadius: cornerRadius, cardSize: cardSize)
            ColumnsContent(
                cardSize: cardSize,
                titleSize: titleSize,
                tabPadding: tabPadding,
                cornerRadius: cornerRadius,
                columnSpacing: columnSpacing,
                stackSpacing: stackSpacing,
                highlightAvailableCard: false,
                columns: [
                    Column(text: "[❤️6, ❤️J, ♣️10, ♦️9, ♠️8, ❤️7]")!,
                    Column(text: "[♠️4, ♠️Q]")!
                ]
            )
        }
        .padding(8)
    }
}
