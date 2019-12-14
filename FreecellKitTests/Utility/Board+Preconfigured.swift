//
//  Board+Preconfigured.swift
//  FreecellKitTests
//
//  Created by Jason Ji on 12/13/19.
//  Copyright © 2019 Jason Ji. All rights reserved.
//

import Foundation
@testable import FreecellKit
import DeckKit

extension Board {
    static var empty: Board {
        let board = Board()
        board.freecells = (0...3).map { i in FreeCell(id: i) }
        board.columns = (0...7).map { i in Column(id: i) }
        board.foundations = [
            Foundation(id: 0, suit: .diamonds),
            Foundation(id: 1, suit: .clubs),
            Foundation(id: 2, suit: .hearts),
            Foundation(id: 3, suit: .spades)
        ]
        
        return board
    }

    static var fullStackBugBoard5: Board {
        let freecells: [FreeCell] = [
            FreeCell(id: 0, card: Card.four.ofSpades),
            FreeCell(id: 1, card: Card.king.ofSpades),
            FreeCell(id: 2, card: Card.king.ofClubs),
            FreeCell(id: 3)
        ]
        
        let foundations: [Foundation] = [
            Foundation(id: 0, topCard: Card.three.ofDiamonds)!,
            Foundation(id: 1, topCard: Card.ace.ofClubs)!,
            Foundation(id: 2, topCard: Card.three.ofHearts)!,
            Foundation(id: 3, topCard: Card.two.ofSpades)!
        ]
        
        let columns: [Column] = [
            Column(id: 0, cards: [
                Card.five.ofDiamonds,
                Card.six.ofDiamonds,
                Card.six.ofSpades,
                Card.queen.ofDiamonds,
                Card.nine.ofHearts,
                Card.eight.ofClubs
            ]),
            Column(id: 1, cards: [
                Card.seven.ofClubs,
                Card.queen.ofHearts,
                Card.three.ofClubs,
                Card.four.ofHearts,
                Card.eight.ofSpades,
                Card.seven.ofHearts,
                Card.six.ofClubs,
                Card.five.ofHearts,
                Card.four.ofClubs
            ]),
            Column(id: 2, cards: [
                Card.seven.ofDiamonds,
                Card.king.ofDiamonds,
                Card.eight.ofHearts,
                Card.two.ofClubs,
                Card.jack.ofClubs,
                Card.ten.ofHearts,
                Card.nine.ofSpades,
                Card.eight.ofDiamonds
            ]),
            Column(id: 3, cards: [
                Card.five.ofClubs,
                Card.seven.ofSpades,
                Card.six.ofHearts,
                Card.five.ofSpades,
                Card.four.ofDiamonds
            ]),
            Column(id: 4, cards: [
                Card.ten.ofClubs,
                Card.nine.ofDiamonds,
                Card.nine.ofClubs,
                Card.three.ofSpades,
                Card.ten.ofSpades,
                Card.king.ofHearts,
                Card.queen.ofClubs,
                Card.jack.ofHearts
            ]),
            Column(id: 5, cards: [
                
            ]),
            Column(id: 6, cards: [
                Card.queen.ofSpades,
                Card.jack.ofDiamonds,
                Card.ten.ofDiamonds,
                Card.jack.ofSpades
            ]),
            Column(id: 7, cards: [
                
            ])
        ]
        
        return Board.preconfigured(withFreecells: freecells, foundations: foundations, columns: columns)
    }
    
    static var fullStackBugBoard6: Board {
        let freecells: [FreeCell] = [
            FreeCell(id: 0, card: Card.four.ofSpades),
            FreeCell(id: 1, card: Card.king.ofSpades),
            FreeCell(id: 2, card: Card.king.ofClubs),
            FreeCell(id: 3)
        ]
        
        let foundations: [Foundation] = [
            Foundation(id: 0, topCard: Card.three.ofDiamonds)!,
            Foundation(id: 1, topCard: Card.ace.ofClubs)!,
            Foundation(id: 2, topCard: Card.three.ofHearts)!,
            Foundation(id: 3, topCard: Card.two.ofSpades)!
        ]
        
        let columns: [Column] = [
            Column(id: 0, cards: [
                Card.five.ofDiamonds,
                Card.six.ofDiamonds,
                Card.six.ofSpades,
                Card.queen.ofDiamonds,
                Card.nine.ofHearts,
                Card.eight.ofClubs
            ]),
            Column(id: 1, cards: [
                Card.seven.ofClubs,
                Card.queen.ofHearts,
                Card.three.ofClubs,
                Card.four.ofHearts,
                Card.eight.ofSpades,
                Card.seven.ofHearts,
                Card.six.ofClubs,
                Card.five.ofHearts,
                Card.four.ofClubs
            ]),
            Column(id: 2, cards: [
                Card.seven.ofDiamonds,
                Card.king.ofDiamonds,
                Card.eight.ofHearts,
                Card.two.ofClubs,
                Card.jack.ofClubs,
                Card.ten.ofHearts,
                Card.nine.ofSpades,
                Card.eight.ofDiamonds
            ]),
            Column(id: 3, cards: [
                Card.five.ofClubs,
                Card.seven.ofSpades,
                Card.six.ofHearts,
                Card.five.ofSpades,
                Card.four.ofDiamonds
            ]),
            Column(id: 4, cards: [
                Card.ten.ofClubs,
                Card.nine.ofDiamonds,
                Card.nine.ofClubs,
                Card.three.ofSpades,
                Card.ten.ofSpades,
                Card.king.ofHearts,
                Card.queen.ofClubs,
                Card.jack.ofHearts
            ]),
            Column(id: 5, cards: [
                
            ]),
            Column(id: 6, cards: [
                Card.queen.ofSpades,
                Card.jack.ofDiamonds,
                Card.jack.ofSpades,
                Card.ten.ofDiamonds
                
            ]),
            Column(id: 7, cards: [
                
            ])
        ]
        
        return Board.preconfigured(withFreecells: freecells, foundations: foundations, columns: columns)
    }
}
