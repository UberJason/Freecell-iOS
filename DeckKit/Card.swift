//
//  Card.swift
//  DeckKit
//
//  Created by Jason Ji on 11/13/19.
//  Copyright © 2019 Jason Ji. All rights reserved.
//

import Foundation

public protocol CardProtocol {
    var suit: Suit { get }
    var rank: Rank { get }
}

public struct Card: CardProtocol, Equatable {
    public let suit: Suit
    public let rank: Rank
    
    public init(suit: Suit, rank: Rank) {
        self.suit = suit
        self.rank = rank
    }
    
    public var displayTitle: String {
        return "\(suit.displayTitle)\(rank.displayTitle)"
    }
    
    public func isOppositeColor(of otherCard: Card) -> Bool {
        return suit.color != otherCard.suit.color
    }
}
