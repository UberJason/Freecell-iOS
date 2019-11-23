//
//  CardStack.swift
//  FreecellKit
//
//  Created by Jason Ji on 11/16/19.
//  Copyright © 2019 Jason Ji. All rights reserved.
//

import Foundation
import DeckKit

public class CardStack: Stack, Identifiable, ObservableObject {
    
    @Published var stack = [Card]()
    public var maxSize: Int { return Deck.maxCardCount }
    public var topItem: Card? { return stack.last }
    
    public init() {}
    
    public init(cards: [Card]) {
        stack = cards
    }
    
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
        return stack.removeLast()
    }
    
    public func item(at index: Int) -> Card? {
        guard index < stack.count else { return nil }
        return stack[index]
    }

    public var items: [Card] {
        return stack
    }
    
    public func setupPush(_ card: Card) {
        _push(card)
    }
    
    private func _push(_ item: Card) {
        stack.append(item)
    }
    
    public func orderIndex(for card: Card) -> Int {
        return stack.firstIndex(of: card) ?? -1
    }
    
    public func contains(_ card: Card) -> Bool {
        return stack.contains(card)
    }
    
}
