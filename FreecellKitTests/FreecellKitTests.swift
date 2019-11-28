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
    
    func sampleStackColumn() -> Column {
            return Column(id: 0, cards: [
            Card.four.ofSpades,
            Card.seven.ofClubs,
            Card.king.ofClubs,
            Card.eight.ofHearts,
            Card.queen.ofSpades,
            Card.jack.ofHearts,
            Card.ten.ofClubs,
            Card.nine.ofHearts
        ])
    }
    
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
        let board = Board()
        
        switch board.selectionState {
        case .idle: break
        case .selected(_): XCTFail("board selectionState should be idle")
        }
        
        board.selectedCard = Card.ace.ofSpades
        
        switch board.selectionState {
        case .idle: XCTFail("board selectionState should not be idle")
        case .selected(let card):
            XCTAssertEqual(card, Card.ace.ofSpades, "Selected card should be \(Card.ace.ofSpades.displayTitle)")
        }
    }
    
    func testBoardLocationContainingMethod() throws {
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
    
    private func validateLocation(for board: Board, card: Card, expectedLocation: CardLocation) {
        let location = board.location(containing: card)
        guard type(of: location) == type(of: expectedLocation) else {
            XCTFail("board containing \(Card.ace.ofSpades.displayTitle) should be a \(type(of: expectedLocation))")
            return
        }
        
        XCTAssertEqual(location.id, expectedLocation.id)
    }
    
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
  
    func testColumnValidSubstack() throws {
        
        func validate(for column: Column, expectedCount: Int, expectedTop: Card?, expectedBottom: Card?) throws {
            let validSubstack = try XCTUnwrap(column.validSubstack())
            
            XCTAssertEqual(validSubstack.stack.count, expectedCount)
            XCTAssertEqual(validSubstack.topItem, expectedTop)
            XCTAssertEqual(validSubstack.bottomItem, expectedBottom)
        }
        
        var column = sampleStackColumn()
        
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
        let nilValidSubstack = column.validSubstack()
        XCTAssertNil(nilValidSubstack)
        
        column = Column(id: 0, cards: [
            Card.four.ofSpades
        ])
        
        try validate(for: column, expectedCount: 1, expectedTop: Card.four.ofSpades, expectedBottom: Card.four.ofSpades)
    }
    
    func testMoveSubstack() throws {
        var board = Board.emptyBoard
        
        board.columns[0] = sampleStackColumn()
        try board.moveSubstack(from: board.columns[0], to: board.columns[1])
        
        XCTAssertEqual(board.columns[0].stack.count, 4)
        XCTAssertEqual(board.columns[1].stack.count, 4)
        
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
        
        board = Board.emptyBoard
        board.columns[0] = sampleStackColumn()
        try board.freecells[0].push(Card.ace.ofHearts)
        try board.freecells[1].push(Card.two.ofHearts)
        
        do {
            try board.moveSubstack(from: board.columns[0], to: board.columns[1])
            XCTFail("Should not be able to move the substack given only 2 freecells")
        } catch {}
    }
    
    #warning("Unit test for Board.lowestOutstandingRedRank and lowestOutstandingBlackRank")
//    func testLowestOutstandingRedRank() {
//        let board = Board(deck: Deck(shuffled: false))
//    }
    
    #warning("Unit test for Board.move(_:to:)")
}

extension Board {
    static var emptyBoard: Board {
        let board = Board()
        board.freecells = (0...3).map { i in FreeCell(id: i) }
        board.columns = (0...7).map { i in Column(id: i) }
        board.foundations = [
            Foundation(id: 0, suit: .diamonds),
            Foundation(id: 1, suit: .clubs),
            Foundation(id: 2, suit: .hearts),
            Foundation(id: 3, suit: .spades)
        ]
        
        return board
    }
}
