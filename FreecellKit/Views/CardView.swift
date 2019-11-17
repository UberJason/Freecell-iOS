//
//  CardView.swift
//  FreecellKit
//
//  Created by Jason Ji on 11/17/19.
//  Copyright © 2019 Jason Ji. All rights reserved.
//

import SwiftUI
import DeckKit

public struct CardView: View {
    let card: Card
    
    public init(card: Card) {
        self.card = card
    }
    
    public var body: some View {
        ZStack(alignment: .topLeading) {
            Rectangle()
                .frame(width: 125, height: 187) // w x h = 1 x 1.5
                .foregroundColor(.white)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.black, lineWidth: 0.25)
            )
                .clipShape(RoundedRectangle(cornerRadius: 8))

            VStack {
                Text(card.rank.displayTitle)
                Text(card.suit.displayTitle)
            }.padding(EdgeInsets(top: 5, leading: 5, bottom: 0, trailing: 0))
        }
                    
//            .shadow(color: .black, radius: 0.2, x: 0, y: 0)
    }
}

struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        CardView(card: Card.ace.ofSpades)
            .previewLayout(.fixed(width: 200, height: 262))
    }
}
