//
//  CardStack.swift
//  FreecellKit
//
//  Created by Jason Ji on 11/16/19.
//  Copyright © 2019 Jason Ji. All rights reserved.
//

import Foundation
import DeckKit

public class CardStack: Stack, Identifiable {
    
    var stack = [Card]()
    public var maxSize: Int { return Deck.maxCardCount }
    public var topItem: Card? { return stack.last }
    
    public var bottomItem: Card? { return stack.first }
    
    public var items: [Card] {
        return stack
    }
    
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
    
    /// Returns the largest valid movable substack within this CardStack.
    /// For example, if the stack is [♠️K, ❤️9,♦️6, ♣️5, ❤️4], this function returns [♦️6, ♣️5, ❤️4].
    public func largestValidSubstack() -> CardStack? {
        guard let substack = validSubstackArraySlice else { return nil }
        
        return CardStack(cards: Array(substack))
    }
    
    /// Returns a valid substack from this CardStack which is capped by the given capCard,
    /// if exists. For example, if the stack is [♠️K, ❤️9,♦️6, ♣️5, ❤️4], calling
    /// `validSubstack(cappedBy: ♣️5)` will return [♣️5, ❤️4].
    /// - Parameter capCard: Card at the root of the substack. This card would be
    /// stacked onto another column's top card during a stack move.
    public func validSubstack(cappedBy capCard: Card) -> CardStack? {
        guard let largestValidSubstack = validSubstackArraySlice,
            let index = largestValidSubstack.firstIndex(of: capCard) else { return nil }
        
        let substack = largestValidSubstack[index..<largestValidSubstack.endIndex]
        return CardStack(cards: Array(substack))
        
    }
    
    private var validSubstackArraySlice: ArraySlice<Card>? {
        guard let topItem = topItem else { return nil }
        guard stack.count > 1 else { return [topItem] }
        
        var currentIndex = stack.endIndex - 1, nextIndex = currentIndex - 1
        var currentCard = stack[currentIndex], nextCard = stack[nextIndex]
    
        while self.card(currentCard, canStackOn: nextCard) {
            currentIndex -= 1; nextIndex -= 1
            if nextIndex < 0 {
                break
            }
            currentCard = stack[currentIndex]; nextCard = stack[nextIndex]
        }
        
        // At end, currentIndex is top of the valid substack
        return stack[currentIndex..<stack.endIndex]
    }
    
    var isFullyValid: Bool {
        return validSubstackArraySlice?.count == stack.count
    }
    
    var isSingleCard: Bool {
        return stack.count == 1
    }
}
