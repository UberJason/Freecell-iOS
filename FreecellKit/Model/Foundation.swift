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
    
    public convenience init?(id: Int, topCard: Card) {
        self.init(id: id, suit: topCard.suit)
        for i in 1 ... topCard.rank.value {
            guard let rank = Rank(value: i) else { return nil }
            do {
                try push(Card(suit: suit, rank: rank))
            } catch {
                return nil
            }
        }
    }
    
    public func push(_ item: Card) throws {
        switch validate(card: item, canStackOn: topItem, foundationSuit: suit) {
        case .success:
            stack.append(item)
        case .failure(let error):
            throw error
        }
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
    
    func validate(card newCard: Card, canStackOn baseCard: Card?, foundationSuit suit: Suit) -> Result<Void, Error> {
        guard newCard.suit == suit else {
            return .failure(FreecellError.invalidSuitForFoundation(baseSuit: suit, newCard: newCard))
        }
        
        guard let topCard = baseCard else { return newCard.rank == .ace ? .success : .failure(FreecellError.invalidRankForFoundation(baseCard: nil, newCard: newCard)) }
        
        guard newCard.rank.value == topCard.rank.value + 1 else {
            return .failure(FreecellError.invalidRankForFoundation(baseCard: topCard, newCard: newCard))
        }
        
        return .success
    }
    
    public func canReceive(_ card: Card) -> Bool {
        switch validate(card: card, canStackOn: topItem, foundationSuit: suit) {
        case .success: return true
        case .failure(_): return false
        }
    }
    
    public func selectableCard() -> Card? {
        return nil
    }
}
