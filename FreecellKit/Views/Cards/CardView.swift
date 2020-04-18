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
    let titleSize: CGFloat
    let tabPadding: CGFloat
    let cornerRadius: CGFloat
    
    public init(card: Card, titleSize: CGFloat = 22.0, tabPadding: CGFloat = 5.0, cornerRadius: CGFloat = 8.0) {
        self.card = card
        self.titleSize = titleSize
        self.tabPadding = tabPadding
        self.cornerRadius = cornerRadius
    }
    
    public var body: some View {
        ZStack {
            CardRectangle(cornerRadius: cornerRadius)
                .overlay(
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .stroke(Color.black, lineWidth: 0.5)
                )
                .accessibility(identifier: card.displayTitle)

            ZStack(alignment: .topLeading) {
                Rectangle()
                    .foregroundColor(.clear)
                CardTabView(card: card, titleSize: titleSize)
                    .accessibilityElement(children: .combine)
                    .accessibility(identifier: "\(card.displayTitle)-tab")
                    .padding(tabPadding)
            }
            ZStack(alignment: .bottomTrailing) {
                Rectangle()
                    .foregroundColor(.clear)
                CardTabView(card: card, titleSize: titleSize)
                    .rotationEffect(Angle.degrees(180))
                    .padding(tabPadding)
            }
        }
        
    }
}

struct CardTabView: View {
    let card: Card
    let titleSize: CGFloat
    
    init(card: Card, titleSize: CGFloat) {
        self.card = card
        self.titleSize = titleSize
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(card.rank.displayTitle)
                .font(.system(size: titleSize, weight: .semibold, design: .rounded))
                .foregroundColor(card.suit.swiftUIColor)
                .frame(minWidth: 15, minHeight: 15)
                .alignmentGuide(.leading) { d in d[.leading] + 1.0 }
            card.suit.displayImage
                .font(.system(size: 0.63*titleSize, weight: .regular, design: .default))
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
        Group {
            HStack {
                ForEach(cards) {
                    CardView(card: $0)
                        .frame(width: 90, height: 134)
                        .frame(width: 200, height: 300)
                        .background(Color.green)
                    
                }
            }.previewLayout(.fixed(width: 800, height: 300))
            
            HStack {
                ForEach(cards) {
                    CardView(card: $0, titleSize: 20)
                        .frame(width: 80, height: 116)
                        .frame(width: 200, height: 300)
                        .background(Color.green)
                    
                }
            }.previewLayout(.fixed(width: 800, height: 300))
            
            HStack {
                ForEach(cards) {
                    CardView(card: $0, titleSize: 16, tabPadding: 3, cornerRadius: 6)
                        .frame(width: 50, height: 70)
                        .frame(width: 200, height: 300)
                        .background(Color.green)
                    
                }
            }.previewLayout(.fixed(width: 800, height: 300))
        }
    }
}
