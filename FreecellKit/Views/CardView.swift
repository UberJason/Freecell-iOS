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
    }
}

struct CardTabView: View {
    let card: Card
    
    init(card: Card) {
        self.card = card
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(card.rank.displayTitle)
                .font(.system(size: 22, weight: .semibold, design: .default))
                .foregroundColor(card.suit.swiftUIColor)
                .alignmentGuide(.leading) { d in d[.leading] + 1.0 }
//            Text(card.suit.displayTitle)
//            .font(.system(size: 11, weight: .regular, design: .default))
            card.suit.displayImage
                .font(.system(size: 14, weight: .regular, design: .default))
                
        }
    }
}


struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        CardView(card: Card.ace.ofSpades)
//            .frame(width: 125, height: 187)
            .frame(width: 90, height: 134)
            .frame(width: 200, height: 300)
            .background(Color.green)
            .previewLayout(.fixed(width: 200, height: 300))
        
    }
}
