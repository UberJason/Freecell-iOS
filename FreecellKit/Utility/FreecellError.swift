//
//  FreecellError.swift
//  FreecellKit
//
//  Created by Jason Ji on 11/14/19.
//  Copyright © 2019 Jason Ji. All rights reserved.
//

import Foundation
import DeckKit

enum FreecellError: Error, LocalizedError {
    case cellOccupied
    case invalidSuitForFoundation(baseSuit: Suit, newCard: Card)
    case invalidRankForFoundation(baseCard: Card?, newCard: Card)
    case invalidSuitForColumn(baseCard: Card, newCard: Card)
    case invalidRankForColumn(baseCard: Card, newCard: Card)
    case invalidMove
    case noValidMoveAvailable
    
    var errorDescription: String? {
        return "FreecellError: \(humanReadableDescription)"
    }
    
    var humanReadableDescription: String {
        switch self {
        case .cellOccupied:
            return "Attempted to push a card onto an occupied free cell."
        case .invalidSuitForFoundation(let baseSuit, let newCard):
            return "Attempted to push a card of the wrong suit onto a foundation (\(newCard.displayTitle) onto a \(baseSuit.displayTitle) foundation)."
        case .invalidRankForFoundation(let baseCard, let newCard):
            return "Attempted to push a card of the wrong rank onto a foundation (\(newCard.displayTitle) onto \(baseCard?.displayTitle ?? "empty foundation"))"
        case .invalidSuitForColumn(let baseCard, let newCard):
            return "Attempted to push a card of the wrong suit onto a column (\(newCard.displayTitle) onto \(baseCard.displayTitle))"
        case .invalidRankForColumn(let baseCard, let newCard):
            return "Attempted to push a card of the wrong rank onto a column (\(newCard.displayTitle) onto \(baseCard.displayTitle))"
        case .invalidMove:
            return "Invalid move."
        case .noValidMoveAvailable:
            return "No available moves."
        }
    }
}
