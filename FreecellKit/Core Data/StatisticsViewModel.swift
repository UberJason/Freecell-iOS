//
//  StatisticsViewModel.swift
//  FreecellKit
//
//  Created by Jason Ji on 4/5/20.
//  Copyright © 2020 Jason Ji. All rights reserved.
//

import Foundation

public struct StatisticsViewModel: Codable {
    public let winsCount: Int
    public let lossCount: Int
    public let totalGameCount: Int
    public let winPercentage: String
    public let currentStreak: String
    public let longestWinningStreak: String
    public let longestLosingStreak: String
    
    public init(winsCount: Int, lossCount: Int, totalGameCount: Int, winPercentage: String, currentStreak: String, longestWinningStreak: String, longestLosingStreak: String) {
        self.winsCount = winsCount
        self.lossCount = lossCount
        self.totalGameCount = totalGameCount
        self.winPercentage = winPercentage
        self.currentStreak = currentStreak
        self.longestWinningStreak = longestWinningStreak
        self.longestLosingStreak = longestLosingStreak
    }
}
