//
//  ColumnView.swift
//  FreecellKit
//
//  Created by Jason Ji on 11/17/19.
//  Copyright © 2019 Jason Ji. All rights reserved.
//

import SwiftUI
import DeckKit

public struct ColumnView: View, SelectedOverlaying {
    @ObservedObject var column: Column
    @Binding var selectedCard: Card?
    var onTapHandler: CardTapHandler?
    var onDoubleTapHandler: CardDoubleTapHandler?
    
    public init(column: Column, selected: Binding<Card?>, onTapHandler: CardTapHandler? = nil, onDoubleTapHandler: CardDoubleTapHandler? = nil) {
        self.column = column
        self._selectedCard = selected
        self.onTapHandler = onTapHandler
        self.onDoubleTapHandler = onDoubleTapHandler
    }
    
    public var body: some View {
        ZStack {
            EmptySpotView()
            ForEach(column.items) { card in
                CardView(card: card)
                    .overlay(
                        self.overlayView(for: card)
                    )
                    .offset(x: 0, y: 40*CGFloat(self.column.orderIndex(for: card)))
                    .onTapGesture {
                        self.onTapHandler?(card)
                    }
            }
        }
    }
    
//    func exclusiveTapGesture(for card: Card) -> AnyGesture<Void> {
//        let doubleTapGesture = TapGesture(count: 1).onEnded {
//            self.onDoubleTapHandler?(card)
//        }
//        let tapGesture = TapGesture().onEnded {
//            self.onTapHandler?(card)
//        }
//
//        let doubleOrSingleTapGesture = doubleTapGesture.exclusively(before: tapGesture)
//        return AnyGesture<Void>(doubleOrSingleTapGesture)
//    }
}

struct ColumnView_Previews: PreviewProvider {
    @State static var selected: Card? = Card.ace.ofSpades
    
    static var previews: some View {
        let column = Column(id: 0)
        column.setupPush(Card.king.ofDiamonds)
        column.setupPush(Card.seven.ofSpades)
        column.setupPush(Card.four.ofHearts)
        column.setupPush(Card.ace.ofSpades)
        
        return ColumnView(column: column, selected: $selected)
            .frame(width: 125, height: 187)
            .frame(width: 200, height: 700)
            .background(Color.green)
            .previewLayout(.fixed(width: 200, height: 700))
    }
}
