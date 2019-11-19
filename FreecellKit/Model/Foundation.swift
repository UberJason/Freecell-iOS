//
//  Foundation.swift
//  FreecellKit
//
//  Created by Jason Ji on 11/14/19.
//  Copyright © 2019 Jason Ji. All rights reserved.
//

import Foundation
import DeckKit

public class Foundation: Stack, CardLocation, Identifiable {
    public let id: Int
    public let suit: Suit
    var stack = [Card]()
    
    public var maxSize: Int { return 13 }
    public var topItem: Card? { return stack.first ?? nil }

    public init(id: Int, suit: Suit) {
        self.id = id
        self.suit = suit
    }
    
    public func push(_ item: Card) throws {
        guard item.suit == suit else {
            throw FreecellError.invalidSuitForFoundation(baseSuit: suit, newCard: item)
        }
        
        if let topCard = topItem, item.rank.value != topCard.rank.value + 1 {
            throw FreecellError.invalidRankForFoundation(baseCard: topCard, newCard: item)
        }

        stack.insert(item, at: 0)
    }
    
    public var items: [Card] {
        return stack.reversed()
    }
    
    public func pop() -> Card? {
        assertionFailure("Can't remove a card from Foundation")
        return nil
    }
    
    public func item(at index: Int) -> Card? {
        guard index < stack.count else { return nil }
        return stack.reversed()[index]
    }
}
