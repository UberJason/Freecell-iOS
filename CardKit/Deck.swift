//
//  Deck.swift
//  CardKit
//
//  Created by Jason Ji on 11/13/19.
//  Copyright © 2019 Jason Ji. All rights reserved.
//

import Foundation

public protocol DeckProtocol {
    var cards: [Card] { get }
    
    func draw() -> Card
}

public class Deck: DeckProtocol {
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
    
    public func draw() -> Card {
        return cards.remove(at: 0)
    }
}
