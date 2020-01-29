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
        var board = Board()
        board.freecells = (0...3).map { i in FreeCell() }
        board.columns = (0...7).map { i in Column() }
        board.foundations = [
            Foundation(suit: .diamonds),
            Foundation(suit: .clubs),
            Foundation(suit: .hearts),
            Foundation(suit: .spades)
        ]
        
        return board
    }
    
    static var fullStackBoard1: Board {
        let freecells: [FreeCell] = [
            FreeCell(card: Card.six.ofDiamonds),
            FreeCell(card: Card.four.ofHearts),
            FreeCell(),
            FreeCell()
        ]
        
        let foundations: [Foundation] = [
            Foundation(topCard: Card.three.ofDiamonds)!,
            Foundation(suit: .clubs),
            Foundation(topCard: Card.ace.ofHearts)!,
            Foundation(topCard: Card.two.ofSpades)!
        ]
        
        let columns: [Column] = [
            Column(cards: [
                Card.ace.ofClubs,
                Card.five.ofClubs,
                Card.nine.ofHearts,
                Card.two.ofHearts,
                Card.three.ofSpades,
                Card.six.ofHearts,
                Card.five.ofSpades,
                Card.four.ofDiamonds
            ]),
            Column(cards: [
                
            ]),
            Column(cards: [
                Card.four.ofSpades,
                Card.seven.ofClubs,
                Card.king.ofClubs,
                Card.eight.ofHearts,
                Card.jack.ofHearts,
                Card.ten.ofClubs
            ]),
            Column(cards: [
                Card.jack.ofDiamonds,
                Card.king.ofSpades,
                Card.queen.ofDiamonds,
                Card.jack.ofSpades,
                Card.ten.ofDiamonds,
                Card.nine.ofClubs,
                Card.eight.ofDiamonds
            ]),
            Column(cards: [
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
            Column(cards: [

            ]),
            Column(cards: [
                Card.seven.ofHearts,
                Card.queen.ofClubs,
                Card.four.ofClubs,
                Card.three.ofHearts,
                Card.two.ofClubs
            ]),
            Column(cards: [
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
            FreeCell(card: Card.five.ofDiamonds),
            FreeCell(card: Card.nine.ofHearts),
            FreeCell(),
            FreeCell()
        ]
        
        let foundations: [Foundation] = [
            Foundation(topCard: Card.three.ofDiamonds)!,
            Foundation(topCard: Card.ace.ofClubs)!,
            Foundation(topCard: Card.ace.ofHearts)!,
            Foundation(topCard: Card.two.ofSpades)!
        ]
        
        let columns: [Column] = [
            Column(cards: [
                Card.seven.ofHearts,
                Card.six.ofSpades,
                Card.two.ofHearts,
                Card.seven.ofDiamonds,
                Card.three.ofSpades,
                Card.five.ofSpades
            ]),
            Column(cards: [
                
            ]),
            Column(cards: [
                Card.king.ofClubs,
                Card.queen.ofDiamonds,
                Card.jack.ofClubs
            ]),
            Column(cards: [
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
            Column(cards: [
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
            Column(cards: [
                Card.king.ofDiamonds,
                Card.queen.ofClubs,
                Card.jack.ofHearts,
                Card.ten.ofSpades,
                Card.nine.ofDiamonds,
                Card.eight.ofSpades
            ]),
            Column(cards: [
                Card.four.ofHearts,
                Card.king.ofHearts
            ]),
            Column(cards: [
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
            FreeCell(),
            FreeCell(card: Card.four.ofDiamonds),
            FreeCell(),
            FreeCell()
        ]
        
        let foundations: [Foundation] = [
            Foundation(topCard: Card.two.ofDiamonds)!,
            Foundation(topCard: Card.three.ofClubs)!,
            Foundation(topCard: Card.ace.ofHearts)!,
            Foundation(topCard: Card.three.ofSpades)!
        ]
        
        let columns: [Column] = [
            Column(cards: [
                Card.ten.ofSpades,
                Card.nine.ofDiamonds
            ]),
            Column(cards: [
                
            ]),
            Column(cards: [
                Card.eight.ofDiamonds,
                Card.three.ofDiamonds,
                Card.eight.ofClubs,
                Card.king.ofSpades,
                Card.seven.ofHearts,
                Card.six.ofClubs,
                Card.five.ofDiamonds
            ]),
            Column(cards: [
                Card.king.ofDiamonds,
                Card.queen.ofClubs
            ]),
            Column(cards: [
                Card.six.ofHearts,
                Card.king.ofClubs,
                Card.five.ofSpades,
                Card.jack.ofDiamonds,
                Card.queen.ofDiamonds,
                Card.jack.ofClubs,
                Card.ten.ofDiamonds,
                Card.nine.ofClubs
            ]),
            Column(cards: [

            ]),
            Column(cards: [
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
            Column(cards: [
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
            FreeCell(card: Card.four.ofSpades),
            FreeCell(card: Card.king.ofSpades),
            FreeCell(card: Card.nine.ofDiamonds),
            FreeCell()
        ]
        
        let foundations: [Foundation] = [
            Foundation(topCard: Card.two.ofDiamonds)!,
            Foundation(topCard: Card.ace.ofClubs)!,
            Foundation(topCard: Card.three.ofHearts)!,
            Foundation(topCard: Card.two.ofSpades)!
        ]
        
        let columns: [Column] = [
            Column(cards: [

            ]),
            Column(cards: [
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
            Column(cards: [
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
            Column(cards: [
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
            Column(cards: [
                Card.seven.ofHearts,
                Card.seven.ofClubs,
                Card.jack.ofHearts
            ]),
            Column(cards: [
                Card.six.ofDiamonds,
                Card.five.ofSpades
            ]),
            Column(cards: [
                Card.eight.ofHearts,
                Card.seven.ofSpades,
                Card.six.ofHearts,
                Card.five.ofClubs,
                Card.four.ofHearts
            ]),
            Column(cards: [
                
            ])
        ]
        
        return Board.preconfigured(withFreecells: freecells, foundations: foundations, columns: columns)
    }

    static var fullStackBugBoard5: Board {
        let freecells: [FreeCell] = [
            FreeCell(card: Card.four.ofSpades),
            FreeCell(card: Card.king.ofSpades),
            FreeCell(card: Card.king.ofClubs),
            FreeCell()
        ]
        
        let foundations: [Foundation] = [
            Foundation(topCard: Card.three.ofDiamonds)!,
            Foundation(topCard: Card.ace.ofClubs)!,
            Foundation(topCard: Card.three.ofHearts)!,
            Foundation(topCard: Card.two.ofSpades)!
        ]
        
        let columns: [Column] = [
            Column(cards: [
                Card.five.ofDiamonds,
                Card.six.ofDiamonds,
                Card.six.ofSpades,
                Card.queen.ofDiamonds,
                Card.nine.ofHearts,
                Card.eight.ofClubs
            ]),
            Column(cards: [
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
            Column(cards: [
                Card.seven.ofDiamonds,
                Card.king.ofDiamonds,
                Card.eight.ofHearts,
                Card.two.ofClubs,
                Card.jack.ofClubs,
                Card.ten.ofHearts,
                Card.nine.ofSpades,
                Card.eight.ofDiamonds
            ]),
            Column(cards: [
                Card.five.ofClubs,
                Card.seven.ofSpades,
                Card.six.ofHearts,
                Card.five.ofSpades,
                Card.four.ofDiamonds
            ]),
            Column(cards: [
                Card.ten.ofClubs,
                Card.nine.ofDiamonds,
                Card.nine.ofClubs,
                Card.three.ofSpades,
                Card.ten.ofSpades,
                Card.king.ofHearts,
                Card.queen.ofClubs,
                Card.jack.ofHearts
            ]),
            Column(cards: [
                
            ]),
            Column(cards: [
                Card.queen.ofSpades,
                Card.jack.ofDiamonds,
                Card.ten.ofDiamonds,
                Card.jack.ofSpades
            ]),
            Column(cards: [
                
            ])
        ]
        
        return Board.preconfigured(withFreecells: freecells, foundations: foundations, columns: columns)
    }
    
    static var fullStackBugBoard6: Board {
        let freecells: [FreeCell] = [
            FreeCell(card: Card.four.ofSpades),
            FreeCell(card: Card.king.ofSpades),
            FreeCell(card: Card.king.ofClubs),
            FreeCell()
        ]
        
        let foundations: [Foundation] = [
            Foundation(topCard: Card.three.ofDiamonds)!,
            Foundation(topCard: Card.ace.ofClubs)!,
            Foundation(topCard: Card.three.ofHearts)!,
            Foundation(topCard: Card.two.ofSpades)!
        ]
        
        let columns: [Column] = [
            Column(cards: [
                Card.five.ofDiamonds,
                Card.six.ofDiamonds,
                Card.six.ofSpades,
                Card.queen.ofDiamonds,
                Card.nine.ofHearts,
                Card.eight.ofClubs
            ]),
            Column(cards: [
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
            Column(cards: [
                Card.seven.ofDiamonds,
                Card.king.ofDiamonds,
                Card.eight.ofHearts,
                Card.two.ofClubs,
                Card.jack.ofClubs,
                Card.ten.ofHearts,
                Card.nine.ofSpades,
                Card.eight.ofDiamonds
            ]),
            Column(cards: [
                Card.five.ofClubs,
                Card.seven.ofSpades,
                Card.six.ofHearts,
                Card.five.ofSpades,
                Card.four.ofDiamonds
            ]),
            Column(cards: [
                Card.ten.ofClubs,
                Card.nine.ofDiamonds,
                Card.nine.ofClubs,
                Card.three.ofSpades,
                Card.ten.ofSpades,
                Card.king.ofHearts,
                Card.queen.ofClubs,
                Card.jack.ofHearts
            ]),
            Column(cards: [
                
            ]),
            Column(cards: [
                Card.queen.ofSpades,
                Card.jack.ofDiamonds,
                Card.jack.ofSpades,
                Card.ten.ofDiamonds
                
            ]),
            Column(cards: [
                
            ])
        ]
        
        return Board.preconfigured(withFreecells: freecells, foundations: foundations, columns: columns)
    }
}
