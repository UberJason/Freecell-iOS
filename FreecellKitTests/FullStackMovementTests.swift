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

class FullStackMovementTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testFullStackMovement1() throws {
        let board = Board.fullStackBoard1
        try board.moveFullStack(from: board.columns[4], to: board.columns[5])
        
        XCTAssertEqual(board.columns[4].items, [
            Card.six.ofSpades,
            Card.king.ofHearts,
            Card.five.ofDiamonds,
            Card.eight.ofClubs
        ])
        
        XCTAssertEqual(board.columns[5].items, [
            Card.ten.ofSpades,
            Card.nine.ofDiamonds,
            Card.eight.ofSpades,
            Card.seven.ofDiamonds,
            Card.six.ofClubs,
            Card.five.ofHearts
        ])
    }
    
    func testFullStackMovementBug4() throws {
        let board = Board.fullStackBugBoard4
        try board.moveFullStack(from: board.columns[1], to: board.columns[0])

        XCTAssertEqual(board.columns[1].items, [
            Card.king.ofDiamonds,
            Card.four.ofDiamonds,
            Card.three.ofDiamonds,
            Card.three.ofClubs,
            Card.nine.ofSpades,
            Card.eight.ofClubs
        ])
        
        XCTAssertEqual(board.columns[0].items, [
            Card.seven.ofDiamonds,
            Card.six.ofSpades,
            Card.five.ofDiamonds,
            Card.four.ofClubs
        ])
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

    #warning("Test canMoveFullStack(from:to:) and moveFullStack(from:to:) using screenshot examples")
}
