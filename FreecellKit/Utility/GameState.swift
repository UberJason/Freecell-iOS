//
//  GameState.swift
//  FreecellKit
//
//  Created by Jason Ji on 3/15/20.
//  Copyright © 2020 Jason Ji. All rights reserved.
//

import Foundation

public enum GameState {
    case new, inProgress, won
    var title: String {
        switch self {
        case .new: return "New"
        case .inProgress: return "In Progress"
        case .won: return "Won"
        }
    }
}
