//
//  ColumnView.swift
//  FreecellKit
//
//  Created by Jason Ji on 11/17/19.
//  Copyright © 2019 Jason Ji. All rights reserved.
//

import SwiftUI
import DeckKit

public struct ColumnView: View {
    @ObservedObject var column: Column
    let selectedIndex = 2
    public init(column: Column) {
        self.column = column
    }
    
    public var body: some View {
        ZStack {
            EmptySpotView()
            ForEach(column.items) { item in
                CardView(card: item)
                    .overlay(
                        self.overlayView(for: item)
                    )
                    .offset(x: 0, y: 35*CGFloat(self.column.orderIndex(for: item)))
                    .frame(width: 125, height: 187)
                    
                    .onTapGesture {
                        print("Tapped card: \(item.displayTitle)")
                    }
            }
        }
    }
    
    func overlayView(for card: Card) -> some View {
        let color: Color = self.column.orderIndex(for: card) == self.selectedIndex ? .yellow : .clear
        return CardRectangle(foregroundColor: color, opacity: 0.5)
    }
}

struct ColumnView_Previews: PreviewProvider {
    static var previews: some View {
        let column = Column(id: 0)
        column.setupPush(Card.king.ofDiamonds)
        column.setupPush(Card.seven.ofSpades)
        column.setupPush(Card.four.ofHearts)
        column.setupPush(Card.ace.ofSpades)
        
        return ColumnView(column: column)
            .previewLayout(.fixed(width: 200, height: 700))
    }
}
