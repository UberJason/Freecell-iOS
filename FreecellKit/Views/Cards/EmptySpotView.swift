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
    let cornerRadius: CGFloat
    
    public init(suit: Suit? = nil, cornerRadius: CGFloat = 8.0) {
        self.suit = suit
        self.cornerRadius = cornerRadius
    }
    
    public var body: some View {
        ZStack {
            CardRectangle(cornerRadius: cornerRadius, opacity: 0.5)
            
            Text(suit?.displayTitle ?? "")
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
