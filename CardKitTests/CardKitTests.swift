//
//  CardKitTests.swift
//  CardKitTests
//
//  Created by Jason Ji on 11/13/19.
//  Copyright © 2019 Jason Ji. All rights reserved.
//

import XCTest
@testable import CardKit
@testable import Freecell

class CardKitTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testDisplay() {
        let ace = Rank.ace
        let king = Rank.king
        let queen = Rank.queen
        let jack = Rank.jack
        let seven = Rank.seven
        
        XCTAssertEqual(ace.displayTitle, "A")
        XCTAssertEqual(king.displayTitle, "K")
        XCTAssertEqual(queen.displayTitle, "Q")
        XCTAssertEqual(jack.displayTitle, "J")
        XCTAssertEqual(seven.displayTitle, "7")
    }
    
    func testDeckInit() {
        let deck = Deck(shuffled: false)
        XCTAssertEqual(deck.cards.count, 52)
        XCTAssertEqual(deck.cards.first!, Card(suit: .clubs, rank: .ace))
        XCTAssertEqual(deck.cards[12], Card(suit: .clubs, rank: .king))
        XCTAssertEqual(deck.cards[13], Card(suit: .diamonds, rank: .ace))
    }
    
    func testDeckDraw() {
        let deck = Deck(shuffled: false)
        XCTAssertEqual(deck.cards.count, 52)
        
        let card = deck.draw()
        XCTAssertEqual(deck.cards.count, 51)
        XCTAssertFalse(deck.cards.contains(card))
    }
}
