//
//  Rank+FreecellValue.swift
//  Freecell
//
//  Created by Jason Ji on 11/13/19.
//  Copyright © 2019 Jason Ji. All rights reserved.
//

import CardKit

extension Rank: Valuing {
    public var value: Int {
        switch self {
        case .ace: return 14
        case .jack: return 11
        case .queen: return 12
        case .king: return 13
        default: return rawValue
        }
    }
}
