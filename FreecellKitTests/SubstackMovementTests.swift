//
//  SubstackMovementTests.swift
//  FreecellKitTests
//
//  Created by Jason Ji on 12/13/19.
//  Copyright © 2019 Jason Ji. All rights reserved.
//

import XCTest
@testable import FreecellKit
import DeckKit

class SubstackMovementTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testCanMoveSubstack() throws {
        let board = Board.empty
        board.columns[0] = Column.sampleStackColumn
        board.columns[1] = Column(id: 1, cards: [])
        
        XCTAssertTrue(board.canMoveSubstack(from: board.columns[0], to: board.columns[1]), "Should be able to move a 4-card substack into an empty column with 4 free cells")
        
        try! board.freecells[0].push(Card.ace.ofClubs)
        XCTAssertTrue(board.canMoveSubstack(from: board.columns[0], to: board.columns[1]), "Should be able to move a 4-card substack into an empty column with 3 free cells")
        
        try! board.freecells[1].push(Card.two.ofClubs)
        XCTAssertTrue(board.canMoveSubstack(from: board.columns[0], to: board.columns[1]), "Should be able to move a 3 out of the 4 cards in a 4-card substack into an empty column with 2 free cells")
        
        board.freecells = (0...3).map { i in FreeCell(id: i) }
        
        board.columns[2] = Column(id: 2, cards: [Card.ace.ofSpades])

        XCTAssertFalse(board.canMoveSubstack(from: board.columns[0], to: board.columns[2]), "Should not be able to move a substack with bottom card \(board.columns[0].largestValidSubstack()!.bottomItem!.displayTitle) to sit on the \(Card.ace.ofSpades.displayTitle)")
        
        XCTAssertFalse(board.canMoveSubstack(from: board.columns[3], to: board.columns[0]), "Should not be able to move an empty column onto another column")
        
        board.columns[3] = Column(id: 3, cards: [Card.ten.ofSpades])
        XCTAssertTrue(board.canMoveSubstack(from: board.columns[0], to: board.columns[3]), "Should be able to move at least the single card from one stack to another")
    }
    
    func testMoveSubstack() throws {
        // Test moving a full substack to an empty column
        var board = Board.empty

        board.columns[0] = Column.sampleStackColumn
        try board.moveSubstack(from: board.columns[0], to: board.columns[1])

        XCTAssertEqual(board.columns[0].stack, [
            Card.four.ofSpades,
            Card.seven.ofClubs,
            Card.king.ofClubs,
            Card.eight.ofHearts
        ])

        XCTAssertEqual(board.columns[1].stack, [
            Card.queen.ofSpades,
            Card.jack.ofHearts,
            Card.ten.ofClubs,
            Card.nine.ofHearts
        ])

        // Test moving a substack which is smaller than the largest valid substack
        board = Board.empty
        board.columns[0] = Column.sampleStackColumn
        board.columns[1] = Column(id: 1, cards: [Card.jack.ofDiamonds])
        
        try board.moveSubstack(from: board.columns[0], to: board.columns[1])
        
        XCTAssertEqual(board.columns[0].stack, [
            Card.four.ofSpades,
            Card.seven.ofClubs,
            Card.king.ofClubs,
            Card.eight.ofHearts,
            Card.queen.ofSpades,
            Card.jack.ofHearts
        ])
        
        XCTAssertEqual(board.columns[1].stack, [
            Card.jack.ofDiamonds,
            Card.ten.ofClubs,
            Card.nine.ofHearts
        ])
        
        
        // Test moving a substack to an empty column where available freecells require only a smaller move.
        board = Board.empty
        board.columns[0] = Column.sampleStackColumn
        try board.freecells[0].push(Card.ten.ofDiamonds)
        try board.freecells[1].push(Card.nine.ofDiamonds)

        try board.moveSubstack(from: board.columns[0], to: board.columns[1])
        
        XCTAssertEqual(board.columns[0].stack, [
            Card.four.ofSpades,
            Card.seven.ofClubs,
            Card.king.ofClubs,
            Card.eight.ofHearts,
            Card.queen.ofSpades
        ])
        
        XCTAssertEqual(board.columns[1].stack, [
            Card.jack.ofHearts,
            Card.ten.ofClubs,
            Card.nine.ofHearts
        ])
        
        
        // Test moving a substack while avoiding an auto-update in the middle of the movement to avoid an
        // unexpected board state and subsequent crash.
        board = Board.empty
        board.columns[0] = Column(id: 0, cards: [
            Card.three.ofHearts,
            Card.three.ofDiamonds,
            Card.queen.ofSpades,
            Card.four.ofSpades,
            Card.ace.ofDiamonds,
            Card.three.ofSpades,
            Card.two.ofDiamonds
        ])
        board.columns[1] = Column(id: 1, cards: [
            Card.eight.ofSpades,
            Card.eight.ofClubs,
            Card.king.ofSpades,
            Card.queen.ofClubs,
            Card.nine.ofHearts,
            Card.four.ofHearts
        ])
        
        try board.foundations[2].push(Card.ace.ofHearts)
        
        try board.moveSubstack(from: board.columns[0], to: board.columns[1])
    }

}
