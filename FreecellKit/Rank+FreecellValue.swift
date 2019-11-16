//
//  Rank+FreecellValue.swift
//  Freecell
//
//  Created by Jason Ji on 11/13/19.
//  Copyright © 2019 Jason Ji. All rights reserved.
//

import DeckKit

extension Rank: Valuing {
    public var value: Int {
        switch self {
        case .ace: return 1
        default: return rawValue
        }
    }
}

extension Card: Identifiable {
    public var id: String { return displayTitle }
}
