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
    
    static var fullStackBoard1: Board {
        let freecells: [FreeCell] = [
            FreeCell(id: 0, card: Card.six.ofDiamonds),
            FreeCell(id: 1, card: Card.four.ofHearts),
            FreeCell(id: 2),
            FreeCell(id: 3)
        ]
        
        let foundations: [Foundation] = [
            Foundation(id: 0, topCard: Card.three.ofDiamonds)!,
            Foundation(id: 1, suit: .clubs),
            Foundation(id: 2, topCard: Card.ace.ofHearts)!,
            Foundation(id: 3, topCard: Card.two.ofSpades)!
        ]
        
        let columns: [Column] = [
            Column(id: 0, cards: [
                Card.ace.ofClubs,
                Card.five.ofClubs,
                Card.nine.ofHearts,
                Card.two.ofHearts,
                Card.three.ofSpades,
                Card.six.ofHearts,
                Card.five.ofSpades,
                Card.four.ofDiamonds
            ]),
            Column(id: 1, cards: [
                
            ]),
            Column(id: 2, cards: [
                Card.four.ofSpades,
                Card.seven.ofClubs,
                Card.king.ofClubs,
                Card.eight.ofHearts,
                Card.jack.ofHearts,
                Card.ten.ofClubs
            ]),
            Column(id: 3, cards: [
                Card.jack.ofDiamonds,
                Card.king.ofSpades,
                Card.queen.ofDiamonds,
                Card.jack.ofSpades,
                Card.ten.ofDiamonds,
                Card.nine.ofClubs,
                Card.eight.ofDiamonds
            ]),
            Column(id: 4, cards: [
                Card.six.ofSpades,
                Card.king.ofHearts,
                Card.five.ofDiamonds,
                Card.eight.ofClubs,
                Card.ten.ofSpades,
                Card.nine.ofDiamonds,
                Card.eight.ofSpades,
                Card.seven.ofDiamonds,
                Card.six.ofClubs,
                Card.five.ofHearts
            ]),
            Column(id: 5, cards: [

            ]),
            Column(id: 6, cards: [
                Card.seven.ofHearts,
                Card.queen.ofClubs,
                Card.four.ofClubs,
                Card.three.ofHearts,
                Card.two.ofClubs
            ]),
            Column(id: 7, cards: [
                Card.three.ofClubs,
                Card.king.ofDiamonds,
                Card.queen.ofHearts,
                Card.queen.ofSpades,
                Card.seven.ofSpades,
                Card.jack.ofClubs,
                Card.ten.ofHearts,
                Card.nine.ofSpades
            ])
        ]
        
        return Board.preconfigured(withFreecells: freecells, foundations: foundations, columns: columns)
    }
    
    static var fullStackBoard2: Board {
        let freecells: [FreeCell] = [
            FreeCell(id: 0, card: Card.five.ofDiamonds),
            FreeCell(id: 1, card: Card.nine.ofHearts),
            FreeCell(id: 2),
            FreeCell(id: 3)
        ]
        
        let foundations: [Foundation] = [
            Foundation(id: 0, topCard: Card.three.ofDiamonds)!,
            Foundation(id: 1, topCard: Card.ace.ofClubs)!,
            Foundation(id: 2, topCard: Card.ace.ofHearts)!,
            Foundation(id: 3, topCard: Card.two.ofSpades)!
        ]
        
        let columns: [Column] = [
            Column(id: 0, cards: [
                Card.seven.ofHearts,
                Card.six.ofSpades,
                Card.two.ofHearts,
                Card.seven.ofDiamonds,
                Card.three.ofSpades,
                Card.five.ofSpades
            ]),
            Column(id: 1, cards: [
                
            ]),
            Column(id: 2, cards: [
                Card.king.ofClubs,
                Card.queen.ofDiamonds,
                Card.jack.ofClubs
            ]),
            Column(id: 3, cards: [
                Card.two.ofClubs,
                Card.four.ofClubs,
                Card.queen.ofSpades,
                Card.nine.ofSpades,
                Card.eight.ofDiamonds,
                Card.seven.ofClubs,
                Card.six.ofDiamonds,
                Card.five.ofClubs,
                Card.four.ofDiamonds,
                Card.three.ofClubs
            ]),
            Column(id: 4, cards: [
                Card.eight.ofHearts,
                Card.ten.ofDiamonds,
                Card.jack.ofDiamonds,
                Card.ten.ofClubs,
                Card.six.ofClubs,
                Card.king.ofSpades,
                Card.queen.ofHearts,
                Card.jack.ofSpades,
                Card.ten.ofHearts,
                Card.nine.ofClubs
            ]),
            Column(id: 5, cards: [
                Card.king.ofDiamonds,
                Card.queen.ofClubs,
                Card.jack.ofHearts,
                Card.ten.ofSpades,
                Card.nine.ofDiamonds,
                Card.eight.ofSpades
            ]),
            Column(id: 6, cards: [
                Card.four.ofHearts,
                Card.king.ofHearts
            ]),
            Column(id: 7, cards: [
                Card.seven.ofSpades,
                Card.eight.ofClubs,
                Card.six.ofHearts,
                Card.five.ofHearts,
                Card.four.ofSpades,
                Card.three.ofHearts
            ])
        ]
        
        return Board.preconfigured(withFreecells: freecells, foundations: foundations, columns: columns)
    }
    
    static var fullStackBoard3: Board {
        let freecells: [FreeCell] = [
            FreeCell(id: 0),
            FreeCell(id: 1, card: Card.four.ofDiamonds),
            FreeCell(id: 2),
            FreeCell(id: 3)
        ]
        
        let foundations: [Foundation] = [
            Foundation(id: 0, topCard: Card.two.ofDiamonds)!,
            Foundation(id: 1, topCard: Card.three.ofClubs)!,
            Foundation(id: 2, topCard: Card.ace.ofHearts)!,
            Foundation(id: 3, topCard: Card.three.ofSpades)!
        ]
        
        let columns: [Column] = [
            Column(id: 0, cards: [
                Card.ten.ofSpades,
                Card.nine.ofDiamonds
            ]),
            Column(id: 1, cards: [
                
            ]),
            Column(id: 2, cards: [
                Card.eight.ofDiamonds,
                Card.three.ofDiamonds,
                Card.eight.ofClubs,
                Card.king.ofSpades,
                Card.seven.ofHearts,
                Card.six.ofClubs,
                Card.five.ofDiamonds
            ]),
            Column(id: 3, cards: [
                Card.king.ofDiamonds,
                Card.queen.ofClubs
            ]),
            Column(id: 4, cards: [
                Card.six.ofHearts,
                Card.king.ofClubs,
                Card.five.ofSpades,
                Card.jack.ofDiamonds,
                Card.queen.ofDiamonds,
                Card.jack.ofClubs,
                Card.ten.ofDiamonds,
                Card.nine.ofClubs
            ]),
            Column(id: 5, cards: [

            ]),
            Column(id: 6, cards: [
                Card.seven.ofClubs,
                Card.four.ofClubs,
                Card.two.ofHearts,
                Card.king.ofHearts,
                Card.queen.ofSpades,
                Card.jack.ofHearts,
                Card.ten.ofClubs,
                Card.nine.ofHearts,
                Card.eight.ofSpades,
                Card.seven.ofDiamonds,
                Card.six.ofSpades,
                Card.five.ofHearts,
                Card.four.ofSpades,
                Card.three.ofHearts
            ]),
            Column(id: 7, cards: [
                Card.queen.ofHearts,
                Card.jack.ofSpades,
                Card.ten.ofHearts,
                Card.nine.ofSpades,
                Card.eight.ofHearts,
                Card.seven.ofSpades,
                Card.six.ofDiamonds,
                Card.five.ofClubs,
                Card.four.ofHearts
            ])
        ]
        
        return Board.preconfigured(withFreecells: freecells, foundations: foundations, columns: columns)
    }
    
    static var fullStackBugBoard4: Board {
        let freecells: [FreeCell] = [
            FreeCell(id: 0, card: Card.four.ofSpades),
            FreeCell(id: 1, card: Card.king.ofSpades),
            FreeCell(id: 2, card: Card.nine.ofDiamonds),
            FreeCell(id: 3)
        ]
        
        let foundations: [Foundation] = [
            Foundation(id: 0, topCard: Card.two.ofDiamonds)!,
            Foundation(id: 1, topCard: Card.ace.ofClubs)!,
            Foundation(id: 2, topCard: Card.three.ofHearts)!,
            Foundation(id: 3, topCard: Card.two.ofSpades)!
        ]
        
        let columns: [Column] = [
            Column(id: 0, cards: [

            ]),
            Column(id: 1, cards: [
                Card.king.ofDiamonds,
                Card.four.ofDiamonds,
                Card.three.ofDiamonds,
                Card.three.ofClubs,
                Card.nine.ofSpades,
                Card.eight.ofClubs,
                Card.seven.ofDiamonds,
                Card.six.ofSpades,
                Card.five.ofDiamonds,
                Card.four.ofClubs
            ]),
            Column(id: 2, cards: [
                Card.three.ofSpades,
                Card.ten.ofClubs,
                Card.queen.ofClubs,
                Card.six.ofClubs,
                Card.king.ofHearts,
                Card.queen.ofSpades,
                Card.jack.ofDiamonds,
                Card.ten.ofSpades,
                Card.nine.ofHearts,
                Card.eight.ofSpades
            ]),
            Column(id: 3, cards: [
                Card.queen.ofDiamonds,
                Card.two.ofClubs,
                Card.five.ofHearts,
                Card.jack.ofClubs,
                Card.ten.ofHearts,
                Card.king.ofClubs,
                Card.queen.ofHearts,
                Card.jack.ofSpades,
                Card.ten.ofDiamonds,
                Card.nine.ofClubs,
                Card.eight.ofDiamonds
            ]),
            Column(id: 4, cards: [
                Card.seven.ofHearts,
                Card.seven.ofClubs,
                Card.jack.ofHearts
            ]),
            Column(id: 5, cards: [
                Card.six.ofDiamonds,
                Card.five.ofSpades
            ]),
            Column(id: 6, cards: [
                Card.eight.ofHearts,
                Card.seven.ofSpades,
                Card.six.ofHearts,
                Card.five.ofClubs,
                Card.four.ofHearts
            ]),
            Column(id: 7, cards: [
                
            ])
        ]
        
        return Board.preconfigured(withFreecells: freecells, foundations: foundations, columns: columns)
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
