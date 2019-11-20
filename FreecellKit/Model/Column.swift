//
//  Column.swift
//  FreecellKit
//
//  Created by Jason Ji on 11/14/19.
//  Copyright © 2019 Jason Ji. All rights reserved.
//

import Foundation
import DeckKit

public class Column: Stack, CardLocation, Identifiable, ObservableObject {
    public let id: Int
    @Published var stack = [Card]()
    public var maxSize: Int { return Deck.maxCardCount }
    public var topItem: Card? { return stack.last }

    public init(id: Int) {
        self.id = id
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
    
//    public func pushStack(_ cardStack: CardStack) throws {
//        fatalError("Implement pushStack(_:)")
////        stack.append(contentsOf: cardStack.stack)
//    }
    
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
}
