//
//  Board+Convenience.swift
//  FreecellKit
//
//  Created by Jason Ji on 12/13/19.
//  Copyright © 2019 Jason Ji. All rights reserved.
//

import DeckKit

extension Board {
    static func preconfigured(withFreecells freecells: [FreeCell], foundations: [Foundation], columns: [Column]) -> Board {
        var board = Board()
        board.freecells = freecells
        board.foundations = foundations
        board.columns = columns
        return board
    }
}

extension Deck {
    static var winnable: Deck {
        let deck = Deck(shuffled: false)
        
        deck.cards = Rank.allCases.sorted(by: { $0.value < $1.value }).flatMap { rank in
            Suit.allCases.map { suit in
                Card(suit: suit, rank: rank)
            }
        }
        
        return deck
    }
}
