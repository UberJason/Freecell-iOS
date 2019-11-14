//
//  FreecellTests.swift
//  FreecellTests
//
//  Created by Jason Ji on 11/13/19.
//  Copyright © 2019 Jason Ji. All rights reserved.
//

import XCTest
@testable import DeckKit
@testable import Freecell

class FreecellTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testValues() {
        let aceOfSpades = Card(suit: .spades, rank: .ace)
        XCTAssertEqual(aceOfSpades.rank.value, 14)
    }

}
