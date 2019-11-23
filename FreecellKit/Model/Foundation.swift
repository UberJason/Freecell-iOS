//
//  Foundation.swift
//  FreecellKit
//
//  Created by Jason Ji on 11/14/19.
//  Copyright © 2019 Jason Ji. All rights reserved.
//

import Foundation
import DeckKit

public class Foundation: Stack, CardLocation, Identifiable, ObservableObject {
    
    public let id: Int
    public let suit: Suit
    @Published var stack = [Card]()
    
    public var maxSize: Int { return 13 }
    public var topItem: Card? { return stack.last ?? nil }

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

        stack.append(item)
    }
    
    public var items: [Card] {
        return stack
    }
    
    public func pop() -> Card? {
        assertionFailure("Can't remove a card from Foundation")
        return nil
    }
    
    public func item(at index: Int) -> Card? {
        guard index < stack.count else { return nil }
        return stack[index]
    }
    
    public func contains(_ card: Card) -> Bool {
        return stack.contains(card)
    }
}
