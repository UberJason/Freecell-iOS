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
                .accessibility(identifier: card.displayTitle)

            ZStack(alignment: .topLeading) {
                Rectangle()
                    .foregroundColor(.clear)
                CardTabView(card: card)
                    .accessibilityElement(children: .combine)
                    .accessibility(identifier: "\(card.displayTitle)-tab")
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
                .font(.system(size: 22, weight: .semibold, design: .rounded))
                .foregroundColor(card.suit.swiftUIColor)
                .frame(minWidth: 15, minHeight: 15)
                .alignmentGuide(.leading) { d in d[.leading] + 1.0 }
            card.suit.displayImage
                .font(.system(size: 14, weight: .regular, design: .default))
                .modifyImageForPlatform()
        }
    }
}

extension View {
    func modifyImageForPlatform() -> some View {
        #if os(macOS)
        return self.frame(width: 12, height: 10, alignment: .leading)
        #else
        return self.frame(minWidth: 15, alignment: .leading)
        #endif
    }
}

struct CardView_Previews: PreviewProvider {
    static let cards = [Card.seven.ofHearts, Card.ten.ofSpades, Card.jack.ofDiamonds, Card.queen.ofClubs]
    static var previews: some View {
        ForEach(cards) {
            CardView(card: $0)
                .frame(width: 90, height: 134)
                .frame(width: 200, height: 300)
                .background(Color.green)
                .previewLayout(.fixed(width: 200, height: 300))
        }
    }
}
