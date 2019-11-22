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
        ZStack {
            CardRectangle()
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.black, lineWidth: 0.5)
                )

            ZStack(alignment: .topLeading) {
                Rectangle()
                    .foregroundColor(.clear)
                CardTabView(card: card)
                    .padding(5.0)
            }
            ZStack(alignment: .bottomTrailing) {
                Rectangle()
                    .foregroundColor(.clear)
                CardTabView(card: card)
                    .rotationEffect(Angle.degrees(180))
                    .padding(5.0)
            }
        }
                    
//            .shadow(color: .black, radius: 0.2, x: 0, y: 0)
    }
}

struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        CardView(card: Card.ace.ofSpades)
            .frame(width: 125, height: 187)
            .frame(width: 200, height: 300)
            .background(Color.green)
            .previewLayout(.fixed(width: 200, height: 300))
        
    }
}

struct CardTabView: View {
    let card: Card
    
    init(card: Card) {
        self.card = card
    }
    
    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            Text(card.rank.displayTitle)
                .font(.system(size: 15, weight: .semibold, design: .default))
            Text(card.suit.displayTitle)
                .font(.system(size: 7, weight: .semibold, design: .default))
        }
    }
}
