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
    
    func testFreeCellStringInit() {
        // case: 0 cards - init empty
        // case: 1 card - init with card
        // case: 2 cards - fail
    }
    
    func testFoundationStringInit() {
        // case: 0 cards - fail
        // case: 1 card as Ace - init with card
        // case: 1 card not as Ace: - fail
        // case: 2 cards Ace+2 - init with sequence
        // case: 2 cards Ace+2-different suit - fail
        // case: 5 cards Ace-5 - init with sequence
    }
    
    func testColumnStringInit() {
        // case: 0 cards - init empty
        // case: 5 cards: init with cards
    }
}
