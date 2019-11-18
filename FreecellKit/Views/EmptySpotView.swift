//
//  EmptySpotView.swift
//  FreecellKit
//
//  Created by Jason Ji on 11/17/19.
//  Copyright © 2019 Jason Ji. All rights reserved.
//

import SwiftUI
import DeckKit

public struct EmptySpotView: View {
    let suit: Suit?
    
    public init(suit: Suit? = nil) {
        self.suit = suit
    }
    
    public var body: some View {
        ZStack {
            Rectangle()
                .frame(width: 125, height: 187) // w x h = 1 x 1.5
                .foregroundColor(.white)
                .opacity(0.5)
//            .overlay(
//                RoundedRectangle(cornerRadius: 8)
//                    .stroke(Color.black, lineWidth: 0.5)
//            )
                .clipShape(RoundedRectangle(cornerRadius: 8))

            
            Text(suit?.displayTitle ?? "!")
                .font(.system(size: 30, weight: .semibold, design: .default))
          
        }
    }
}

struct EmptySpotView_Previews: PreviewProvider {
    static let spadeEmpty = EmptySpotView(suit: .spades)
    static let noEmpty = EmptySpotView()
    
    static var previews: some View {
        Group {
            EmptySpotView()
                .frame(width: 125, height: 187)
                .frame(width: 200, height: 262)
                .background(Color.green)
                .previewLayout(.fixed(width: 200, height: 262))
            
            EmptySpotView(suit: .spades)
                .frame(width: 125, height: 187)
                .frame(width: 200, height: 262)
                .background(Color.green)
                .previewLayout(.fixed(width: 200, height: 262))
        }
    }
}
