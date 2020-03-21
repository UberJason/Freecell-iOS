//
//  StatisticsTests.swift
//  FreecellKitTests
//
//  Created by Jason Ji on 3/20/20.
//  Copyright © 2020 Jason Ji. All rights reserved.
//

import XCTest
@testable import FreecellKit

class StatisticsTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testComputeStreaks() {
        func assert(_ streak: Streak, is count: Int, _ type: GameResult) {
            XCTAssertEqual(streak.count, count)
            XCTAssertEqual(streak.type, type)
        }
        
        var gameRecords = [JSONGameRecord(result: .win), JSONGameRecord(result: .win)]
        var (longestWinning, longestLosing, currentStreak) = StatisticsModel.computeStreaks(for: gameRecords)
        assert(currentStreak, is: 2, .win)
        assert(longestLosing, is: 0, .loss)
        assert(longestWinning, is: 2, .win)
        
        gameRecords.append(JSONGameRecord(result: .win))
        (longestWinning, longestLosing, currentStreak) = StatisticsModel.computeStreaks(for: gameRecords)
        
        assert(currentStreak, is: 3, .win)
        assert(longestLosing, is: 0, .loss)
        assert(longestWinning, is: 3, .win)
        
        gameRecords.append(JSONGameRecord(result: .loss))
        (longestWinning, longestLosing, currentStreak) = StatisticsModel.computeStreaks(for: gameRecords)
        
        assert(currentStreak, is: 1, .loss)
        assert(longestLosing, is: 1, .loss)
        assert(longestWinning, is: 3, .win)
        
        gameRecords.append(contentsOf: [JSONGameRecord(result: .loss), JSONGameRecord(result: .loss)])
        (longestWinning, longestLosing, currentStreak) = StatisticsModel.computeStreaks(for: gameRecords)
        
        assert(currentStreak, is: 3, .loss)
        assert(longestLosing, is: 3, .loss)
        assert(longestWinning, is: 3, .win)
        
        gameRecords.append(JSONGameRecord(result: .win))
        (longestWinning, longestLosing, currentStreak) = StatisticsModel.computeStreaks(for: gameRecords)
        
        assert(currentStreak, is: 1, .win)
        assert(longestLosing, is: 3, .loss)
        assert(longestWinning, is: 3, .win)
        
        gameRecords.append(JSONGameRecord(result: .win))
        (longestWinning, longestLosing, currentStreak) = StatisticsModel.computeStreaks(for: gameRecords)
        
        assert(currentStreak, is: 2, .win)
        assert(longestLosing, is: 3, .loss)
        assert(longestWinning, is: 3, .win)
    }
}

extension Streak: Equatable {
    public static func == (lhs: Streak, rhs: Streak) -> Bool {
        return lhs.count == rhs.count && lhs.type == rhs.type
    }
}
