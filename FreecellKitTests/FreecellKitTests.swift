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

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testValues() {
        let aceOfSpades = Card(suit: .spades, rank: .ace)
        XCTAssertEqual(aceOfSpades.rank.value, 1)
    }

    func testFoundationPush() {
        let foundation = Foundation(suit: .spades)
        let aceOfSpades = Card.ace.ofSpades
        let twoOfSpades = Card.two.ofSpades
        let sevenOfSpades = Card.seven.ofSpades
        let aceOfClubs = Card.ace.ofClubs
        
        do {
            try foundation.push(aceOfSpades)
        } catch {
            print(error.localizedDescription)
            XCTFail("Should be able to push Ace of Spades onto an empty Spade foundation")
        }
        
        do {
            try foundation.push(aceOfClubs)
            XCTFail("Should not be able to push Ace of Clubs onto a Spade foundation")
        } catch {}
        
        XCTAssertNotNil(foundation.topItem)
        XCTAssertEqual(foundation.topItem!, aceOfSpades)
        
        do {
            try foundation.push(twoOfSpades)
        }
        catch {
            print(error.localizedDescription)
            XCTFail("Should be able to push the 2 of Spades onto the Ace of Spades")
        }
        
        do {
            try foundation.push(sevenOfSpades)
            XCTFail("Should not be able to push the 7 of Spades onto the 2 of Spades")
        } catch {}
    }
}
