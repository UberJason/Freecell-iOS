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
}
