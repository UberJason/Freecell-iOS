//
//  TextInitializing.swift
//  FreecellKit
//
//  Created by Jason Ji on 4/6/20.
//  Copyright © 2020 Jason Ji. All rights reserved.
//

import Foundation
import DeckKit

// Expect string to have format like "♠️3, ❤️4, ♦️K, ♣️Q"
struct TextParser {
    func parseCards(from text: String) -> [Card] {
        return text.split(separator: ",")
            .map { $0.trimmingCharacters(in: .whitespaces) }
            .compactMap(Card.init)
    }
}

public extension FreeCell {
      convenience init?(text: String) {
        let cards = TextParser().parseCards(from: text)
        
        guard cards.count < 2 else { return nil }
        self.init(card: cards.first)
    }
}

public extension Foundation {
    convenience init?(text: String) {
        let cards = TextParser().parseCards(from: text)
        if cards.count == 0 { return nil }
        else if cards.count == 1 {
            let first = cards.first!
            guard first.rank == .ace else { return nil }
            self.init(topCard: first)
        }
        else {
            var previous = cards.first!
            for i in 1..<cards.count {
                let current = cards[i]
                guard current.suit == previous.suit && current.rank.value == previous.rank.value + 1 else { return nil }
                previous = current
            }
            self.init(topCard: cards[cards.count - 1])
        }
    }
}

public extension Column {
    convenience init?(text: String) {
        let cards = TextParser().parseCards(from: text)
        self.init(cards: cards)
    }
}
