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
        
        if let topItem = topItem {
            switch validate(card: item, canStackOn: topItem) {
            case .success: break
            case .failure(let error): throw error
            }
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
    
    func card(_ newCard: Card, canStackOn baseCard: Card) -> Bool {
        switch validate(card: newCard, canStackOn: baseCard) {
        case .success: return true
        case .failure(_): return false
        }
    }
    
    func validate(card newCard: Card, canStackOn baseCard: Card) -> Result<Void, Error> {
        guard baseCard.isOppositeColor(of: newCard) else {
            return .failure(FreecellError.invalidSuitForColumn(baseCard: baseCard, newCard: newCard))
        }
        
        guard newCard.rank.value == baseCard.rank.value - 1 else {
            return .failure(FreecellError.invalidRankForColumn(baseCard: baseCard, newCard: newCard))
        }
        
        return .success
    }
}
