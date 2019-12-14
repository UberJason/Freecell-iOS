//
//  LocationTests.swift
//  FreecellKitTests
//
//  Created by Jason Ji on 12/13/19.
//  Copyright © 2019 Jason Ji. All rights reserved.
//

import XCTest
@testable import FreecellKit
import DeckKit

class LocationTests: XCTestCase {
    
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

    // MARK: - Foundation Tests -
    func testFoundationPush() {
        let foundation = Foundation(id: 0, suit: .spades)
        
        do {
            try foundation.push(aceOfSpades)
        } catch {
            print(error.localizedDescription)
            XCTFail("Should be able to push \(aceOfSpades.displayTitle) onto an empty Spade foundation")
        }
        
        do {
            try foundation.push(aceOfClubs)
            XCTFail("Should not be able to push \(aceOfClubs.displayTitle) onto a Spade foundation")
        } catch {}
        
        XCTAssertNotNil(foundation.topItem)
        XCTAssertEqual(foundation.topItem!, aceOfSpades)
        
        do {
            try foundation.push(twoOfSpades)
        }
        catch {
            print(error.localizedDescription)
            XCTFail("Should be able to push \(twoOfSpades.displayTitle) onto \(aceOfSpades.displayTitle)")
        }
        
        do {
            try foundation.push(sevenOfSpades)
            XCTFail("Should be able to push \(sevenOfSpades.displayTitle) onto \(twoOfSpades.displayTitle)")
        } catch {}
        
        let foundation2 = Foundation(id: 1, suit: .spades)
        
        do {
            try foundation2.push(twoOfSpades)
            XCTFail("Should not be able to push \(twoOfSpades.displayTitle) onto an empty Spade foundation")
        } catch {}
    }
    
    func testMultipleFoundationPush() {
        let f = Foundation(id: 0, suit: .hearts)
        do {
            try f.push(Card.ace.ofHearts)
            try f.push(Card.two.ofHearts)
            try f.push(Card.three.ofHearts)
            try f.push(Card.four.ofHearts)
        } catch {
            print(error.localizedDescription)
            XCTFail("Should be able to push A through 4 of Hearts")
        }
    }
    
    func testFoundationConvenienceInit() throws {
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
    
    // MARK: - FreeCell Tests -
    func testFreecellOccupied() throws {
        
        func validate(for board: Board, expectedId: Int) {
            let availableFreeCell = board.nextAvailableFreecell
            XCTAssertEqual(availableFreeCell?.id, expectedId)
        }
        
        let board = Board()
        validate(for: board, expectedId: 0)
        
        try? board.freecells[0].push(Card.ace.ofSpades)
        validate(for: board, expectedId: 1)
        
        try? board.freecells[2].push(Card.queen.ofSpades)
        validate(for: board, expectedId: 1)
        
        try? board.freecells[1].push(Card.two.ofSpades)
        try? board.freecells[3].push(Card.four.ofClubs)
        
        XCTAssertNil(board.nextAvailableFreecell)
    }
    
    // MARK: - Column / CardStack Tests -
    func testColumnPush() {
        let column = Column(id: 0)
        
        do {
            try column.push(sevenOfSpades)
        } catch {
            print(error.localizedDescription)
            XCTFail("Should be able to push \(sevenOfSpades.displayTitle) onto an empty column")
        }
        
        XCTAssertNotNil(column.topItem)
        
        do {
            try column.push(sixOfSpades)
            XCTFail("Should not be able to push \(sixOfSpades.displayTitle) onto column with top card \(column.topItem!.displayTitle)")
        } catch {}
        
        do {
            try column.push(sixOfDiamonds)
        } catch {
            print(error.localizedDescription)
            XCTFail("Should be able to push \(sixOfDiamonds.displayTitle) onto a column with top card \(column.topItem!.displayTitle)")
        }
        
        do {
            try column.push(fourOfClubs)
            XCTFail("Should be able to push \(fourOfClubs.displayTitle) onto a column with top card \(column.topItem!.displayTitle)")
        } catch {}
    }
    
    func testCardStackCanStackOn() {
        let stack = CardStack()
        XCTAssertTrue(stack.card(Card.two.ofSpades, canStackOn: Card.three.ofHearts))
        XCTAssertFalse(stack.card(Card.two.ofSpades, canStackOn: Card.three.ofSpades))
        XCTAssertFalse(stack.card(Card.two.ofSpades, canStackOn: Card.four.ofHearts))
    }

    func testValidSubstackCappedBy() {
       let stack = CardStack(cards: [
           Card.king.ofSpades,
           Card.nine.ofHearts,
           Card.six.ofDiamonds,
           Card.five.ofClubs,
           Card.four.ofHearts
       ])
       
       var validSubstack = stack.validSubstack(cappedBy: Card.six.ofDiamonds)
       XCTAssertEqual(validSubstack?.stack, [
           Card.six.ofDiamonds,
           Card.five.ofClubs,
           Card.four.ofHearts
       ])
       
       validSubstack = stack.validSubstack(cappedBy: Card.five.ofClubs)
       XCTAssertEqual(validSubstack?.stack, [
           Card.five.ofClubs,
           Card.four.ofHearts
       ])
    }

    func testCapCard() throws {
       func validate(for board: Board, from fromColumn: Column, to toColumn: Column, expectedCapCard: Card?) {
           let capCard = board.capCard(forMovingFrom: fromColumn, to: toColumn)
           XCTAssertEqual(capCard, expectedCapCard)
       }

       // Test cap card expected to be a larger stack
       let board = Board.empty
       board.columns[0] = Column(id: 0, cards: [
           Card.four.ofSpades,
           Card.seven.ofClubs,
           Card.king.ofClubs,
           Card.eight.ofHearts,
           Card.jack.ofHearts,
           Card.ten.ofClubs
       ])
       
       board.columns[1] = Column(id: 1, cards: [
           Card.six.ofHearts,
           Card.king.ofHearts,
           Card.five.ofDiamonds,
           Card.eight.ofClubs,
           Card.ten.ofSpades,
           Card.nine.ofDiamonds,
           Card.eight.ofSpades,
           Card.seven.ofDiamonds,
           Card.six.ofClubs,
           Card.five.ofHearts
       ])
       
       validate(for: board, from: board.columns[1], to: board.columns[0], expectedCapCard: Card.nine.ofDiamonds)
       
       // Test cap card expected to be just a single card
       board.columns[0] = Column(id: 0, cards: [
           Card.six.ofSpades
       ])

       validate(for: board, from: board.columns[1], to: board.columns[0], expectedCapCard: Card.five.ofHearts)
    }
    
    func testColumnLargestValidSubstack() throws {
        func validate(for column: Column, expectedCount: Int, expectedTop: Card?, expectedBottom: Card?) throws {
            let largestValidSubstack = try XCTUnwrap(column.largestValidSubstack())
            
            XCTAssertEqual(largestValidSubstack.stack.count, expectedCount)
            XCTAssertEqual(largestValidSubstack.topItem, expectedTop)
            XCTAssertEqual(largestValidSubstack.bottomItem, expectedBottom)
        }
        
        var column = Column.sampleStackColumn
        
        try validate(for: column, expectedCount: 4, expectedTop: Card.nine.ofHearts, expectedBottom: Card.queen.ofSpades)
        
        column = Column(id: 0, cards: [
            Card.four.ofSpades,
            Card.seven.ofClubs,
            Card.king.ofClubs,
            Card.eight.ofHearts,
            Card.nine.ofHearts
        ])
        
        try validate(for: column, expectedCount: 1, expectedTop: Card.nine.ofHearts, expectedBottom: Card.nine.ofHearts)
        
        column = Column(id: 0, cards: [])
        let nilValidSubstack = column.largestValidSubstack()
        XCTAssertNil(nilValidSubstack)
        
        column = Column(id: 0, cards: [
            Card.four.ofSpades
        ])
        
        try validate(for: column, expectedCount: 1, expectedTop: Card.four.ofSpades, expectedBottom: Card.four.ofSpades)
        
        column = Column(id: 0, cards: [
            Card.jack.ofDiamonds,
            Card.ten.ofSpades
        ])
        
        try validate(for: column, expectedCount: 2, expectedTop: Card.ten.ofSpades, expectedBottom: Card.jack.ofDiamonds)
    }
    
    func testColumnValidSubstackCappedBy() throws {
        let column = Column.sampleStackColumn
        
        let cappedSubstack = try XCTUnwrap(column.validSubstack(cappedBy: Card.jack.ofHearts))
        
        XCTAssertEqual(cappedSubstack.items.count, 3)
        XCTAssertEqual(cappedSubstack.topItem, Card.nine.ofHearts)
        XCTAssertEqual(cappedSubstack.bottomItem, Card.jack.ofHearts)
    }
}
