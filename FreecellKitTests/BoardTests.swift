//
//  BoardTests.swift
//  FreecellKitTests
//
//  Created by Jason Ji on 12/13/19.
//  Copyright © 2019 Jason Ji. All rights reserved.
//

import XCTest
@testable import FreecellKit
import DeckKit

class BoardTests: XCTestCase {
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testBoardSetup() {
        let board = Board()
        
        XCTAssertEqual(board.columns.count, 8)
        XCTAssertEqual(board.columns[0].stack.count, 7)
        XCTAssertEqual(board.columns[1].stack.count, 7)
        XCTAssertEqual(board.columns[2].stack.count, 7)
        XCTAssertEqual(board.columns[3].stack.count, 7)
        XCTAssertEqual(board.columns[4].stack.count, 6)
        XCTAssertEqual(board.columns[4].stack.count, 6)
        XCTAssertEqual(board.columns[4].stack.count, 6)
        XCTAssertEqual(board.columns[4].stack.count, 6)
        
        XCTAssertEqual(board.freecells.count, 4)
        board.freecells.forEach { XCTAssertNil($0.item) }
        
        XCTAssertEqual(board.foundations.count, 4)
        board.foundations.forEach { XCTAssertNil($0.topItem) }
        XCTAssertEqual(board.foundations[0].suit, Suit.diamonds)
        XCTAssertEqual(board.foundations[1].suit, Suit.clubs)
        XCTAssertEqual(board.foundations[2].suit, Suit.hearts)
        XCTAssertEqual(board.foundations[3].suit, Suit.spades)
    }
    
    func testBoardSelectionState() {
        let boardDriver = ClassicViewDriver()
        
        switch boardDriver.selectionState {
        case .idle: break
        case .selected(_): XCTFail("board selectionState should be idle")
        }
        
        boardDriver.selectedCard = Card.ace.ofSpades
        
        switch boardDriver.selectionState {
        case .idle: XCTFail("board selectionState should not be idle")
        case .selected(let card):
            XCTAssertEqual(card, Card.ace.ofSpades, "Selected card should be \(Card.ace.ofSpades.displayTitle)")
        }
    }
    
    func testBoardLocationContainingMethod() throws {
        
        func validateLocation(for board: Board, card: Card, expectedLocation: Cell) {
            let location = board.cell(containing: card)
            guard type(of: location) == type(of: expectedLocation) else {
                XCTFail("board containing \(Card.ace.ofSpades.displayTitle) should be a \(type(of: expectedLocation))")
                return
            }
            
            XCTAssertEqual(location.id, expectedLocation.id)
        }
        
        let board = Board(deck: Deck(shuffled: false))
        
        validateLocation(for: board, card: Card.ace.ofSpades, expectedLocation: board.columns[0])
        validateLocation(for: board, card: Card.queen.ofClubs, expectedLocation: board.columns[1])
        validateLocation(for: board, card: Card.five.ofClubs, expectedLocation: board.columns[0])
        
        let card = try XCTUnwrap(board.columns[0].pop())
        try! board.freecells[0].push(card)
        
        validateLocation(for: board, card: card, expectedLocation: board.freecells[0])
        
        let card2 = try XCTUnwrap(board.columns[7].pop())
        try! board.freecells[1].push(card2)
        let card3 = try XCTUnwrap(board.columns[7].pop())
        try! board.foundations[1].push(card3)
        
        validateLocation(for: board, card: card2, expectedLocation: board.freecells[1])
        validateLocation(for: board, card: card3, expectedLocation: board.foundations[1])
    }
    
    func testRankNextHighestOrLowest() throws {
        let rank = Rank.ace
        let nextHighest = rank.nextHighest
        XCTAssertEqual(nextHighest, Rank.two)
        
        let nextLowest = rank.nextLowest
        XCTAssertNil(nextLowest)
        
        let rank2 = Rank.king
        let nextLowest2 = rank2.nextLowest
        let nextHighest2 = rank2.nextHighest
        
        XCTAssertEqual(nextLowest2, Rank.queen)
        XCTAssertNil(nextHighest2)
    }
    
    func testMoveCard() throws {
        var board = Board.empty
        board.columns[0] = Column.sampleStackColumn
        
        try board.move(board.columns[0].topItem!, to: board.columns[1])
        XCTAssertEqual(board.columns[0].stack, [
            Card.four.ofSpades,
            Card.seven.ofClubs,
            Card.king.ofClubs,
            Card.eight.ofHearts,
            Card.queen.ofSpades,
            Card.jack.ofHearts,
            Card.ten.ofClubs
        ])
        XCTAssertEqual(board.columns[1].stack, [Card.nine.ofHearts])
        
        board.columns[0] = Column.sampleStackColumn
        board.columns[1] = Column(cards: [Card.four.ofHearts])
        
        do {
            try board.move(board.columns[0].topItem!, to: board.columns[1])
            XCTFail("Should not be able to move the ❤️9 on top of the ❤️4")
        } catch {}
    }
    
    func testFreeColumns() throws {
        let board = Board.empty
        let deck = Deck(shuffled: true)
        try board.columns.forEach {
            let card = try XCTUnwrap(deck.draw())
            try $0.push(card)
        }
        
        var freeColumns = board.freeColumns(excluding: nil)
        XCTAssertEqual(freeColumns.count, 0)
        
        _ = board.columns[0].pop()
        freeColumns = board.freeColumns(excluding: nil)
        XCTAssertEqual(freeColumns.count, 1)
        freeColumns = board.freeColumns(excluding: board.columns[0])
        XCTAssertEqual(freeColumns.count, 0)
        
        _ = board.columns[1].pop()
        _ = board.columns[2].pop()
        freeColumns = board.freeColumns(excluding: nil)
        XCTAssertEqual(freeColumns.count, 3)
        freeColumns = board.freeColumns(excluding: board.columns[0])
        XCTAssertEqual(freeColumns.count, 2)
    }
    
    
}
