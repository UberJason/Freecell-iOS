//
//  DeckKitTests.swift
//  DeckKitTests
//
//  Created by Jason Ji on 11/13/19.
//  Copyright © 2019 Jason Ji. All rights reserved.
//

import XCTest
@testable import DeckKit
@testable import Freecell

class DeckKitTests: XCTestCase {

    let aceOfSpades = Card.ace.ofSpades
    let aceOfClubs = Card.ace.ofClubs
    let twoOfDiamonds = Card.two.ofDiamonds
    let twoOfClubs = Card.two.ofClubs
    
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
        XCTAssertEqual(deck.cards.first!, twoOfClubs)
        XCTAssertEqual(deck.cards[12], aceOfClubs)
        XCTAssertEqual(deck.cards[13], twoOfDiamonds)
    }
    
    func testDeckDraw() {
        let deck = Deck(shuffled: false)
        XCTAssertEqual(deck.cards.count, 52)
        
        let card = deck.draw()
        XCTAssertNotNil(card)
        XCTAssertEqual(deck.cards.count, 51)
        XCTAssertEqual(card, aceOfSpades)
        XCTAssertFalse(deck.cards.contains(card!))
        
        for _ in 0 ..< 51 {
            let _ = deck.draw()
        }
        
        let notACard = deck.draw()
        XCTAssertNil(notACard)
        XCTAssertTrue(deck.cards.count == 0)
    }
    
    func testSuitColor() {
        XCTAssertEqual(aceOfSpades.suit.color, SuitColor.black)
        XCTAssertFalse(aceOfSpades.isOppositeColor(of: aceOfClubs))
        
        XCTAssertEqual(twoOfDiamonds.suit.color, SuitColor.red)
        XCTAssertTrue(aceOfClubs.isOppositeColor(of: twoOfDiamonds))
    }
    
    func testDisplayTitle() {
        XCTAssertEqual(aceOfSpades.displayTitle, "♠️A")
        XCTAssertEqual(twoOfDiamonds.displayTitle, "♦️2")
    }
}
