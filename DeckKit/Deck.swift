//
//  Deck.swift
//  DeckKit
//
//  Created by Jason Ji on 11/13/19.
//  Copyright © 2019 Jason Ji. All rights reserved.
//

import Foundation

public protocol DeckProtocol {
    var cards: [Card] { get }
    
    func draw() -> Card?
}

public class Deck: DeckProtocol {
    public static let maxCardCount = 52
    
    public var cards: [Card]
    
    public init(shuffled: Bool) {
        cards = [Card]()
        
        Suit.allCases.forEach { suit in
            Rank.allCases.forEach { rank in
                cards.append(Card(suit: suit, rank: rank))
            }
        }
        
        if shuffled {
            cards.shuffle()
        }
    }
    
    public func draw() -> Card? {
        if cards.isEmpty { return nil }
        return cards.removeLast()
    }
}
