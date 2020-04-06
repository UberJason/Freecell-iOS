//
//  TextInitializing.swift
//  FreecellKit
//
//  Created by Jason Ji on 4/6/20.
//  Copyright © 2020 Jason Ji. All rights reserved.
//

import Foundation
import DeckKit

public extension FreeCell {
    // Expect string to have format like "♠️3, ❤️4, ♦️K, ♣️Q"
      convenience init?(text: String) {
        let cards = text.split(separator: ",")
            .map { $0.trimmingCharacters(in: .whitespaces) }
            .compactMap(Card.init)
        
        guard cards.count < 2 else { return nil }
        self.init(card: cards.first)
    }
}
