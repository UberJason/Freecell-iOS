//
//  Column.swift
//  FreecellKit
//
//  Created by Jason Ji on 11/14/19.
//  Copyright © 2019 Jason Ji. All rights reserved.
//

import Foundation
import DeckKit

public class Column: Stack {
    var stack = [Card]()
    public var maxSize: Int { return Deck.maxCardCount }
    public var topItem: Card? { return stack.last }

    public func push(_ item: Card) throws {
        if let topCard = topItem,
            !topCard.isOppositeColor(of: item) {
            throw FreecellError.invalidSuitForColumn(baseCard: topCard, newCard: item)
        }
        
        if let topCard = topItem,
            item.rank.value != topCard.rank.value - 1 {
            throw FreecellError.invalidRankForColumn(baseCard: topCard, newCard: item)
        }
        
        _push(item)
    }
    
    public func pop() -> Card? {
        guard !stack.isEmpty else { return nil }
        return stack.removeFirst()
    }
    
    public func item(at index: Int) -> Card? {
        guard index < stack.count else { return nil }
        return stack[index]
    }
    
    public func pushStack(_ cardStack: CardStack) throws {
        fatalError("Implement pushStack(_:)")
//        stack.insert(contentsOf: cardStack.stack, at: 0)
    }
    
    func setupPush(_ card: Card) {
        _push(card)
    }
    
    private func _push(_ item: Card) {
        stack.insert(item, at: 0)
    }
}
