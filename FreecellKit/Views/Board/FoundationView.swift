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
    let foundation: Foundation
    
    public init(foundation: Foundation) {
        self.foundation = foundation
    }
    
    public var body: some View {
        ZStack {
            EmptySpotView(suit: foundation.suit)
        }
        .accessibilityElement(children: .combine)
        .accessibility(identifier: foundation.id)
        .accessibility(hidden: foundation.topItem != nil)
    }
}

struct FoundationView_Previews: PreviewProvider {
    static let emptyFoundation = Foundation(suit: .spades)
    static let filledFoundation: Foundation = {
        let f = Foundation(suit: .hearts)
        try! f.push(Card.ace.ofHearts)
        try! f.push(Card.two.ofHearts)
        try! f.push(Card.three.ofHearts)
        try? f.push(Card.four.ofHearts)
        return f
    }()
    
    static var previews: some View {
        ForEach([filledFoundation]) { foundation in
            FoundationView(foundation: foundation)
                .frame(width: 125, height: 187)
                .frame(width: 200, height: 262)
                .background(Color.green)
                .previewLayout(.fixed(width: 200, height: 262))
        }
    }
}
