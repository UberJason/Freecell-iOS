//
//  FoundationView.swift
//  FreecellKit
//
//  Created by Jason Ji on 11/17/19.
//  Copyright © 2019 Jason Ji. All rights reserved.
//

import SwiftUI
import DeckKit

public struct FoundationView: View {
    @ObservedObject var foundation: Foundation
    @Binding var hiddenCard: Card?
    
    public init(foundation: Foundation, hidden: Binding<Card?>) {
        self.foundation = foundation
        self._hiddenCard = hidden
    }
    
    public var body: some View {
        ZStack {
            EmptySpotView(suit: foundation.suit)
            ForEach(foundation.items) { card in
                CardView(card: card)
                    .opacity(card == self.hiddenCard ? 0.0 : 1.0)
            }
        }
    }
}

struct FoundationView_Previews: PreviewProvider {
    static let emptyFoundation = Foundation(id: 0, suit: .spades)
    static let filledFoundation: Foundation = {
        let f = Foundation(id: 1, suit: .hearts)
        try! f.push(Card.ace.ofHearts)
        try! f.push(Card.two.ofHearts)
        try! f.push(Card.three.ofHearts)
        try? f.push(Card.four.ofHearts)
        return f
    }()
    
    @State static var hidden: Card? = nil
    
    static var previews: some View {
        ForEach([filledFoundation]) { foundation in
            FoundationView(foundation: foundation, hidden: $hidden)
                .frame(width: 125, height: 187)
                .frame(width: 200, height: 262)
                .background(Color.green)
                .previewLayout(.fixed(width: 200, height: 262))
        }
    }
}
