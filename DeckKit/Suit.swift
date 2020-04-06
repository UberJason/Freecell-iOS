//
//  Suit.swift
//  DeckKit
//
//  Created by Jason Ji on 11/13/19.
//  Copyright © 2019 Jason Ji. All rights reserved.
//

import Foundation

public enum Suit: CaseIterable {
    case diamonds, clubs, hearts, spades
    
    public init?(text: String) {
        switch text {
        case "♣️": self = .clubs
        case "♦️": self = .diamonds
        case "❤️": self = .hearts
        case "♠️": self = .spades
        default: return nil
        }
    }
    
    public var color: SuitColor {
        switch self {
        case .clubs, .spades: return .black
        case .diamonds, .hearts: return .red
        }
    }
    
    public var displayTitle: String {
        switch self {
        case .clubs:
            return "♣️"
        case .diamonds:
            return "♦️"
        case .hearts:
            return "❤️"
        case .spades:
            return "♠️"
        }
    }
}

public enum SuitColor {
    case red, black
}
