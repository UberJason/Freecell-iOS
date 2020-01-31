//
//  MoveEvent.swift
//  FreecellKit
//
//  Created by Jason Ji on 1/31/20.
//  Copyright © 2020 Jason Ji. All rights reserved.
//

import Foundation

public struct MoveEvent: Equatable {
    public static func == (lhs: MoveEvent, rhs: MoveEvent) -> Bool {
        return lhs.id == rhs.id
    }
    
    // Create a unique identifier for a move, to compare it to other moves.
    let id = UUID()
    let beforeBoard: Board
    let afterBoard: Board
}
