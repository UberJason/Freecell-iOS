//
//  Board+Convenience.swift
//  FreecellKit
//
//  Created by Jason Ji on 12/13/19.
//  Copyright © 2019 Jason Ji. All rights reserved.
//

import Foundation

extension Board {
    static func preconfigured(withFreecells freecells: [FreeCell], foundations: [Foundation], columns: [Column]) -> Board {
        let board = Board()
        board.freecells = freecells
        board.foundations = foundations
        board.columns = columns
        return board
    }
}
