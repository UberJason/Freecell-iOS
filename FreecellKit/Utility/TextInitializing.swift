//
//  TextInitializing.swift
//  FreecellKit
//
//  Created by Jason Ji on 4/6/20.
//  Copyright © 2020 Jason Ji. All rights reserved.
//

import Foundation
import DeckKit

// Expect string to have format like "[♠️3, ❤️4, ♦️K, ♣️Q]"

protocol Parser {
    associatedtype Output
    func parse(from text: String) -> Output
}

struct TextParser: Parser {
    func parse(from text: String) -> [Card] {
        guard let firstBracketIndex = text.firstIndex(of: "["),
            let secondBracketIndex = text.lastIndex(of: "]") else { return [] }
        
        let startIndex = text.index(after: firstBracketIndex)
        let endIndex = text.index(before: secondBracketIndex)
        
        return text[startIndex...endIndex]
            .split(separator: ",")
            .map { $0.trimmingCharacters(in: .whitespaces) }
            .compactMap(Card.init)
    }
}

struct SuitParser {
    func parse(from text: String) -> Suit? {
        guard let firstBracketIndex = text.firstIndex(of: "["),
            let secondBracketIndex = text.lastIndex(of: "]") else { return nil }
        
        let startIndex = text.index(after: firstBracketIndex)
        let endIndex = text.index(before: secondBracketIndex)
        
        return Suit(text: String(text[startIndex...endIndex]))
    }
}

public extension FreeCell {
      convenience init?(text: String) {
        let cards = TextParser().parse(from: text)
        
        guard cards.count < 2 else { return nil }
        self.init(card: cards.first)
    }
}

public extension Foundation {
    // First try to parse a card. Requirement: should have one card representing the top card. e.g. "[♠️3]"
    // If that's not available, try to parse a suit. Requirement: should look like "[♠️]" to represent an empty Spade foundation.
    convenience init?(text: String) {
        let cards = TextParser().parse(from: text)
        
        if cards.count == 1 {
            self.init(topCard: cards.first!)
        }
        else {
            guard let suit = SuitParser().parse(from: text) else { return nil }
            self.init(suit: suit)
        }
    }
}

public extension Column {
    convenience init?(text: String) {
        let cards = TextParser().parse(from: text)
        self.init(cards: cards)
    }
}
