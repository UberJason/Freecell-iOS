//
//  Rank.swift
//  DeckKit
//
//  Created by Jason Ji on 11/13/19.
//  Copyright © 2019 Jason Ji. All rights reserved.
//

import Foundation

public enum Rank: Int, CaseIterable {
    case two = 2
    case three
    case four
    case five
    case six
    case seven
    case eight
    case nine
    case ten
    case jack
    case queen
    case king
    case ace
    
    public var displayTitle: String {
        switch self {
        case .ace: return "A"
        case .king: return "K"
        case .queen: return "Q"
        case .jack: return "J"
        default: return String(rawValue)
        }
    }
    
    public init?(text: String) {
        if let value = Int(text), value >= 2, value <= 10 {
            self.init(rawValue: value)
        }
        else {
            switch text {
            case "A": self = .ace
            case "K": self = .king
            case "Q": self = .queen
            case "J": self = .jack
            default: return nil
            }
        }
    }
}

public protocol Valuing {
    var value: Int { get }
}
