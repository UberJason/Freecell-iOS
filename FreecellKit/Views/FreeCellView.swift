//
//  FreeCellView.swift
//  FreecellKit
//
//  Created by Jason Ji on 11/17/19.
//  Copyright © 2019 Jason Ji. All rights reserved.
//

import SwiftUI
import DeckKit

public struct FreeCellView: View {
    @ObservedObject var freeCell: FreeCell
    @Binding var selectedCard: Card?
    var onTapHandler: CardTapHandler?
    
    public init(freeCell: FreeCell, selected: Binding<Card?>, onTapHandler: CardTapHandler? = nil) {
        self.freeCell = freeCell
        self._selectedCard = selected
        self.onTapHandler = onTapHandler
    }
    
    public var body: some View {
        ZStack {
            EmptySpotView()
            freeCell.item.map { card in
                CardView(card: card)
                    .onTapGesture {
                        self.onTapHandler?(card)
                    }
            }
            
        }
    }
}

struct FreeCellView_Previews: PreviewProvider {
    static var emptyFreeCell = FreeCell(id: 0)
    static var occupiedFreeCell: FreeCell = {
        let f = FreeCell(id: 1)
        try! f.push(Card.ace.ofSpades)
        return f
    }()
    @State static var selected: Card? = Card.ace.ofSpades
    
    static var previews: some View {
        ForEach([emptyFreeCell, occupiedFreeCell]) { freeCell in
            FreeCellView(freeCell: freeCell, selected: $selected)
                .frame(width: 125, height: 187)
                .frame(width: 200, height: 262)
                .background(Color.green)
                .previewLayout(.fixed(width: 200, height: 262))
        }
    }
}
