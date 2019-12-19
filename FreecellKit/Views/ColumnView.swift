//
//  ColumnView.swift
//  FreecellKit
//
//  Created by Jason Ji on 11/17/19.
//  Copyright © 2019 Jason Ji. All rights reserved.
//

import SwiftUI
import DeckKit

public struct ColumnView: View, SelectedOverlaying, StackOffsetting {
    @ObservedObject var column: Column
    @Binding var selectedCard: Card?
    @Binding var hiddenCard: Card?
    var onTapHandler: CardTapHandler?
    
    public init(column: Column, selected: Binding<Card?>, hidden: Binding<Card?>, onTapHandler: CardTapHandler? = nil) {
        self.column = column
        self._selectedCard = selected
        self._hiddenCard = hidden
        self.onTapHandler = onTapHandler
    }
    
    #warning("TODO: scale effect should be a custom view modifier that applies to both ColumnView and FreeCellView")
    public var body: some View {
        ZStack {
            EmptySpotView()
//            ForEach(column.items) { card in
//                CardView(card: card)
//                    .overlay(
//                        self.overlayView(for: card)
//                    )
//                    .scaleEffect(card == self.selectedCard ? 1.05 : 1.0, anchor: .top)
//                    .animation(.spring(response: 0.10, dampingFraction: 0.95, blendDuration: 0.0))
//                    .opacity(card == self.hiddenCard ? 0.0 : 1.0)
//                    .offset(self.offset(for: card, orderIndex: self.column.orderIndex(for: card)))
//                    .onTapGesture {
//                        self.onTapHandler?(card)
//                    }
//            }
        }
    }
}

struct ColumnView_Previews: PreviewProvider {
    @State static var selected: Card? = Card.ace.ofSpades
    @State static var hidden: Card? = nil
    
    static var previews: some View {
        let column = Column(id: 0)
        column.setupPush(Card.king.ofDiamonds)
        column.setupPush(Card.seven.ofSpades)
        column.setupPush(Card.four.ofHearts)
        column.setupPush(Card.ace.ofSpades)
        
        return ColumnView(column: column, selected: $selected, hidden: $hidden)
            .frame(width: 125, height: 187)
            .frame(width: 200, height: 700)
            .background(Color.green)
            .previewLayout(.fixed(width: 200, height: 700))
    }
}
