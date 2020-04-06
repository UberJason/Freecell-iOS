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
}
