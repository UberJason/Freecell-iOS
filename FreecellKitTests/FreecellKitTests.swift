//
//  FreecellKitTests.swift
//  FreecellKitTests
//
//  Created by Jason Ji on 11/14/19.
//  Copyright © 2019 Jason Ji. All rights reserved.
//

import XCTest
@testable import FreecellKit
import DeckKit

class FreecellKitTests: XCTestCase {
    let spades = Suit.spades
    
    let aceOfSpades = Card.ace.ofSpades
    let aceOfClubs = Card.ace.ofClubs
    let twoOfSpades = Card.two.ofSpades
    let sevenOfSpades = Card.seven.ofSpades
    let sixOfSpades = Card.six.ofSpades
    let sixOfDiamonds = Card.six.ofDiamonds
    let fourOfClubs = Card.four.ofClubs
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testErrorMessages() {
        let invalidSuitForFoundation = FreecellError.invalidSuitForFoundation(baseSuit: spades, newCard: aceOfClubs)
        let invalidRankForFoundation = FreecellError.invalidRankForFoundation(baseCard: twoOfSpades, newCard: sevenOfSpades)
        let invalidSuitForColumn = FreecellError.invalidSuitForColumn(baseCard: sevenOfSpades, newCard: sixOfSpades)
        let invalidRankForColumn = FreecellError.invalidRankForColumn(baseCard: sixOfDiamonds, newCard: fourOfClubs)
        
        XCTAssertEqual(invalidSuitForFoundation.errorDescription, "FreecellError: Attempted to push a card of the wrong suit onto a foundation (\(aceOfClubs.displayTitle) onto a \(spades.displayTitle) foundation).")
        XCTAssertEqual(invalidRankForFoundation.errorDescription, "FreecellError: Attempted to push a card of the wrong rank onto a foundation (\(sevenOfSpades.displayTitle) onto \(twoOfSpades.displayTitle))")
        XCTAssertEqual(invalidSuitForColumn.errorDescription, "FreecellError: Attempted to push a card of the wrong suit onto a column (\(sixOfSpades.displayTitle) onto \(sevenOfSpades.displayTitle))")
        XCTAssertEqual(invalidRankForColumn.errorDescription, "FreecellError: Attempted to push a card of the wrong rank onto a column (\(fourOfClubs.displayTitle) onto \(sixOfDiamonds.displayTitle))")
    }

    func testValues() {
        XCTAssertEqual(aceOfSpades.rank.value, 1)
    }

}
