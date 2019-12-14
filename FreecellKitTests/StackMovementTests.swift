//
//  FullStackTests.swift
//  FreecellKitTests
//
//  Created by Jason Ji on 12/13/19.
//  Copyright © 2019 Jason Ji. All rights reserved.
//

import XCTest
@testable import FreecellKit
import DeckKit

class StackMovementTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testFullStackMovementBug5() throws {
        let board = Board.fullStackBugBoard5
        try board.moveFullStack(from: board.columns[6], to: board.columns[5])
        
        XCTAssertEqual(board.columns[5].items, [
            Card.jack.ofSpades
        ])
        
        XCTAssertEqual(board.columns[6].items, [
            Card.queen.ofSpades,
            Card.jack.ofDiamonds,
            Card.ten.ofDiamonds
        ])
        
        XCTAssertEqual(board.columns[7].items, [])
    }
    
    func testFullStackMovementBug6() throws {
        let board = Board.fullStackBugBoard6
        try board.moveFullStack(from: board.columns[6], to: board.columns[5])
        
        XCTAssertEqual(board.columns[5].items, [
            Card.jack.ofSpades,
            Card.ten.ofDiamonds
        ])
        
        XCTAssertEqual(board.columns[6].items, [
            Card.queen.ofSpades,
            Card.jack.ofDiamonds
        ])
        
        XCTAssertEqual(board.columns[7].items, [])
        
    }

}
