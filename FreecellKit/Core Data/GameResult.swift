//
//  GameResult.swift
//  FreecellKit
//
//  Created by Jason Ji on 3/20/20.
//  Copyright © 2020 Jason Ji. All rights reserved.
//

import Foundation

public enum GameResult: String {
    case win, loss
    
    var opposite: GameResult {
        return self == .win ? .loss : .win
    }
    
    var plural: String {
        switch self {
        case .win: return "s"
        case .loss: return "es"
        }
    }
}
