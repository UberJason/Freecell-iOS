//
//  FoundationTests.swift
//  FreecellKitTests
//
//  Created by Jason Ji on 12/13/19.
//  Copyright © 2019 Jason Ji. All rights reserved.
//

import XCTest
@testable import FreecellKit
import DeckKit

class FoundationTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testConvenienceInit() throws {
        var foundation = try XCTUnwrap(Foundation(id: 0, topCard: Card.four.ofSpades))
        XCTAssertEqual(foundation.items, [
            Card.ace.ofSpades,
            Card.two.ofSpades,
            Card.three.ofSpades,
            Card.four.ofSpades
        ])
        
        foundation = try XCTUnwrap(Foundation(id: 0, topCard: Card.ace.ofDiamonds))
        XCTAssertEqual(foundation.items, [
            Card.ace.ofDiamonds
        ])
    }
}
