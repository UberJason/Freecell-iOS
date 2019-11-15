//
//  FreecellError.swift
//  FreecellKit
//
//  Created by Jason Ji on 11/14/19.
//  Copyright © 2019 Jason Ji. All rights reserved.
//

import Foundation

enum FreecellError: Error, LocalizedError {
    case cellOccupied
    case invalidSuitForFoundation
    case invalidRankForFoundation
    
    var errorDescription: String? {
        let description: String
        
        switch self {
        case .cellOccupied:
            description = "Attempted to push a card onto an occupied free cell."
        case .invalidSuitForFoundation:
            description = "Attempted to push a card of the wrong suit onto a foundation (e.g. a ♠️ onto a ♣️ foundation)."
        case .invalidRankForFoundation:
            description = "Attempted to push a card of the wrong rank onto a foundation (e.g. 7♠️ onto 2♠️)"
        }
        
        return "FreecellError: \(description)"
    }
}
