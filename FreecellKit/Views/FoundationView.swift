//
//  FoundationView.swift
//  FreecellKit
//
//  Created by Jason Ji on 11/17/19.
//  Copyright © 2019 Jason Ji. All rights reserved.
//

import SwiftUI
import DeckKit

struct FoundationView: View {
    let foundation: Foundation
    public init(foundation: Foundation) {
        self.foundation = foundation
    }
    
    public var body: some View {
        CardView(card: Card.ace.ofSpades)
    }
}

struct FoundationView_Previews: PreviewProvider {
    static var previews: some View {
        FoundationView(foundation: Foundation(id: 0, suit: .spades))
            .previewLayout(.fixed(width: 200, height: 262))
    }
}
