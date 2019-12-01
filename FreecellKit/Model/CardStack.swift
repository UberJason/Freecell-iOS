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
        guard let topItem = topItem else { return nil }
        guard stack.count > 1 else { return CardStack(cards: [topItem]) }
        
        var currentIndex = stack.endIndex - 1, nextIndex = currentIndex - 1
        var currentCard = stack[currentIndex], nextCard = stack[nextIndex]
    
        while self.card(currentCard, canStackOn: nextCard) && nextIndex >= 0 {
            currentIndex -= 1; nextIndex -= 1
            currentCard = stack[currentIndex]; nextCard = stack[nextIndex]
        }
        
        // At end, currentIndex is top of the valid substack
        let substack = Array(stack[currentIndex..<stack.endIndex])
        
        return CardStack(cards: Array(substack))
    }
    
    
    /// Returns a substack from the `largestValidSubstack` starting at the
    /// given index. This method is generally expected to be called on a fully valid
    /// CardStack, but if not, it starts with the largest valid substack before considering
    /// the index. For example, if the stack is [♦️6, ♣️5, ❤️4], calling `substack(from: 1)`
    /// will return [♣️5, ❤️4].
    /// - Parameter index: Index to start the substack.
    public func substack(from index: Int) -> CardStack? {
        guard let largestValidSubstack = largestValidSubstack() else { return nil }
        guard index < largestValidSubstack.stack.count else { return nil }
        
        let stack = largestValidSubstack.stack
        let substack = Array(stack[index..<stack.endIndex])
        
        return CardStack(cards: Array(substack))
    }
}
