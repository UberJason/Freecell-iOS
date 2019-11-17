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
            Rectangle()
                .foregroundColor(.white)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.black, lineWidth: 0.5)
            )
                .clipShape(RoundedRectangle(cornerRadius: 8))

            ZStack(alignment: .topLeading) {
                Rectangle()
                    .foregroundColor(.clear)
                VStack(alignment: .center, spacing: 0) {
                    Text(card.rank.displayTitle)
                        .font(.system(size: 15, weight: .semibold, design: .default))
                    Text(card.suit.displayTitle)
                        .font(.system(size: 7, weight: .semibold, design: .default))
                }.padding(EdgeInsets(top: 5, leading: 5, bottom: 0, trailing: 0))
            }
            ZStack(alignment: .topLeading) {
                Rectangle()
                    .foregroundColor(.red)
                VStack(alignment: .center, spacing: 0) {
                    Text(card.rank.displayTitle)
                        .font(.system(size: 15, weight: .semibold, design: .default))
                        .foregroundColor(.red)
                    Text(card.suit.displayTitle)
                        .font(.system(size: 7, weight: .semibold, design: .default))
                }
                .padding(EdgeInsets(top: 5, leading: 5, bottom: 0, trailing: 0))
            }
            .transformEffect(.init(rotationAngle: CGFloat.pi))
        }
                    
//            .shadow(color: .black, radius: 0.2, x: 0, y: 0)
    }
}

struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        CardView(card: Card.ace.ofSpades)
            .frame(width: 125, height: 187)
            .previewLayout(.fixed(width: 200, height: 300))
    }
}
