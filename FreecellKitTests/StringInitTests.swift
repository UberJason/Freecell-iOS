//
//  StringInitTests.swift
//  FreecellKitTests
//
//  Created by Jason Ji on 4/6/20.
//  Copyright © 2020 Jason Ji. All rights reserved.
//

import XCTest
@testable import FreecellKit
import DeckKit

class StringInitTests: XCTestCase {
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testTextParser() {
        // case: good sequence - return cards
        // case: garbage - return empty array
        let parser = CardParser()
        
        let cards = parser.parse(from: "[♠️3, ❤️4, ♦️K, ♣️Q]")
        XCTAssertEqual(cards, [Card.three.ofSpades, Card.four.ofHearts, Card.king.ofDiamonds, Card.queen.ofClubs])
        let garbage = parser.parse(from: "asdf foo !!")
        XCTAssertEqual(garbage, [])
    }
    
    func testFreeCellStringInit() throws {
        // case: 0 cards - init empty
        // case: 1 card - init with card
        // case: 2 cards - fail
        
        let emptyFreecell = try XCTUnwrap(FreeCell(text: ""))
        XCTAssertNil(emptyFreecell.topItem)
        XCTAssertFalse(emptyFreecell.isOccupied)
        
        let occupiedFreecell = try XCTUnwrap(FreeCell(text: "[♠️3]"))
        XCTAssertEqual(occupiedFreecell.topItem, Card.three.ofSpades)
        
        let nilFreecell = FreeCell(text: "[♠️3, ♠️4]")
        XCTAssertNil(nilFreecell)
    }
    
    func testFoundationStringInit() throws {
        // case 0: 1 card - init with card
        // case 1: suit - init with suit
        // case 2: 3 cards - fail
        // case 3: garbage - fail
        
        let case0 = try XCTUnwrap(Foundation(text: "[♠️4]"))
        XCTAssertEqual(case0.topItem, Card.four.ofSpades)
        
        let case1 = try XCTUnwrap(Foundation(text: "[❤️]"))
        XCTAssert(case1.suit == .hearts)
        XCTAssertNil(case1.topItem)
        
        let case2 = Foundation(text: "[♠️A, ♠️2]")
        XCTAssertNil(case2)
        
        let case3 = Foundation(text: "[oo bah]")
        XCTAssertNil(case3)
    }
    
    func testColumnStringInit() throws {
        // case: 0 cards - init empty
        // case: 5 cards: init with cards
        
        let emptyColumn = try XCTUnwrap(Column(text: ""))
        XCTAssertEqual(emptyColumn.stack.count, 0)
        
        let filledColumn = try XCTUnwrap(Column(text: "[♠️3, ❤️4, ♦️K, ♣️Q]"))
        XCTAssertEqual(filledColumn.stack, [Card.three.ofSpades, Card.four.ofHearts, Card.king.ofDiamonds, Card.queen.ofClubs])
    }
    
    func testBoardStringInit() {
        let boardText =
"""
Freecells:
[❤️J] [❤️Q] [x] [x]

Foundations:
[♦️] [♣️] [❤️A] [♠️]

Columns:
[♦️3, ♣️Q, ♦️J, ❤️2, ♣️4, ❤️K]
[❤️8, ♦️9, ♠️6, ❤️9, ♣️K, ♠️7]
[♦️5, ♠️J, ♣️3, ♠️2, ♠️9, ♦️A, ♦️Q, ♣️J]
[♦️10, ❤️4, ♦️8, ♠️K, ♠️Q, ♦️6, ♣️10]
[♠️4, ♦️2, ♠️10, ♠️8, ❤️Q]
[♦️K, ♣️9, ❤️7, ♣️A, ♣️6]
[♦️4, ♣️7, ❤️3, ❤️5, ❤️10, ♠️5]
[♣️2, ♠️3, ♣️8, ♦️7, ❤️6, ♣️5]
"""
        let parser = BoardParser()
        let board = parser.parse(from: boardText)
        
        XCTAssert(board?.freecells[0].topItem == Card.jack.ofHearts)
        XCTAssert(board?.freecells[1].topItem == Card.queen.ofHearts)
        XCTAssertNil(board?.freecells[2].topItem)
        XCTAssertNil(board?.freecells[3].topItem)
        
        XCTAssert(board?.foundations[0].suit == .diamonds)
        XCTAssert(board?.foundations[1].suit == .clubs)
        XCTAssert(board?.foundations[2].suit == .hearts)
        XCTAssert(board?.foundations[3].suit == .spades)
        
        XCTAssertNil(board?.foundations[0].topItem)
        XCTAssert(board?.foundations[2].topItem == Card.ace.ofHearts)
        
        XCTAssert(board?.columns[0].stack.count == 6)
    }
}
