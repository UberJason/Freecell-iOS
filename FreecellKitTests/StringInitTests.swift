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
        let parser = TextParser()
        
        let cards = parser.parseCards(from: "♠️3, ❤️4, ♦️K, ♣️Q")
        XCTAssertEqual(cards, [Card.three.ofSpades, Card.four.ofHearts, Card.king.ofDiamonds, Card.queen.ofClubs])
        let garbage = parser.parseCards(from: "asdf foo !!")
        XCTAssertEqual(garbage, [])
    }
    
    func testFreeCellStringInit() throws {
        // case: 0 cards - init empty
        // case: 1 card - init with card
        // case: 2 cards - fail
        
        let emptyFreecell = try XCTUnwrap(FreeCell(text: ""))
        XCTAssertNil(emptyFreecell.topItem)
        XCTAssertFalse(emptyFreecell.isOccupied)
        
        let occupiedFreecell = try XCTUnwrap(FreeCell(text: "♠️3"))
        XCTAssertEqual(occupiedFreecell.topItem, Card.three.ofSpades)
        
        let nilFreecell = FreeCell(text: "♠️3, ♠️4")
        XCTAssertNil(nilFreecell)
    }
    
    func testFoundationStringInit() throws {
        // case 0: 0 cards - fail
        // case 1: 1 card as Ace - init with card
        // case 2: 1 card not as Ace: - fail
        // case 3: 2 cards Ace+2 - init with sequence
        // case 4: 2 cards Ace+2-different suit - fail
        // case 5: 5 cards Ace-5 - init with sequence
        
        let case0 = Foundation(text: "")
        XCTAssertNil(case0)
        
        let case1 = try XCTUnwrap(Foundation(text: "♠️A"))
        XCTAssert(case1.suit == .spades)
        XCTAssert(case1.topItem == Card.ace.ofSpades)
        
        let case2 = Foundation(text: "♠️4")
        XCTAssertNil(case2)
        
        let case3 = try XCTUnwrap(Foundation(text: "♠️A, ♠️2"))
        XCTAssert(case3.suit == .spades)
        XCTAssert(case3.topItem == Card.two.ofSpades)
        
        let case4 = Foundation(text: "♠️A, ❤️2")
        XCTAssertNil(case4)
        
        let case5 = try XCTUnwrap(Foundation(text: "♠️A, ♠️2, ♠️3, ♠️4, ♠️5"))
        XCTAssert(case5.suit == .spades)
        XCTAssert(case5.topItem == Card.five.ofSpades)
    }
    
    func testColumnStringInit() throws {
        // case: 0 cards - init empty
        // case: 5 cards: init with cards
        
        let emptyColumn = try XCTUnwrap(Column(text: ""))
        XCTAssertEqual(emptyColumn.stack.count, 0)
        
        let filledColumn = try XCTUnwrap(Column(text: "♠️3, ❤️4, ♦️K, ♣️Q"))
        XCTAssertEqual(filledColumn.stack, [Card.three.ofSpades, Card.four.ofHearts, Card.king.ofDiamonds, Card.queen.ofClubs])
    }
}
