//
//  Rank+FreecellValue.swift
//  Freecell
//
//  Created by Jason Ji on 11/13/19.
//  Copyright © 2019 Jason Ji. All rights reserved.
//

import DeckKit

extension Rank: @retroactive Valuing {
    public var value: Int {
        switch self {
        case .ace: return 1
        default: return rawValue
        }
    }
    
    public init?(value: Int) {
        switch value {
        case 1: self = .ace
        case 14: return nil
        default: self.init(rawValue: value)
        }
    }
}

extension Rank: @retroactive Comparable {
    public static func < (lhs: Rank, rhs: Rank) -> Bool {
        return lhs.value < rhs.value
    }
}

extension Rank {
    public var nextHighest: Rank? {
        return Rank(value: self.value + 1)
    }
    
    public var nextLowest: Rank? {
        return Rank(value: self.value - 1)
    }
}
