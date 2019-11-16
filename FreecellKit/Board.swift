//
//  Board.swift
//  FreecellKit
//
//  Created by Jason Ji on 11/14/19.
//  Copyright © 2019 Jason Ji. All rights reserved.
//

import Foundation
import DeckKit

public class Board {
    public let freecells: [FreeCell]
    public let foundations: [Foundation]
    public let columns: [Column]
    
    public init() {
        let deck = Deck(shuffled: true)
        
        freecells = (1...4).map { _ in FreeCell() }
        foundations = [
            Foundation(suit: .diamonds),
            Foundation(suit: .clubs),
            Foundation(suit: .hearts),
            Foundation(suit: .spades)
        ]
        columns = (1...8).map { _ in Column() }
        
        for i in 0 ..< Deck.maxCardCount {
            guard let card = deck.draw() else { fatalError("Deck empty during new game setup") }
            columns[i % columns.count].setupPush(card)
        }
    }
}
