//
//  CardSeat.swift
//  FreecellKit
//
//  Created by Jason Ji on 11/18/19.
//  Copyright © 2019 Jason Ji. All rights reserved.
//

import Foundation
import DeckKit

public protocol CardSeat: NSCopying {
    var id: Int { get }
    func contains(_ card: Card) -> Bool
    func pop() -> Card?
    func canReceive(_ card: Card) -> Bool
    func receive(_ card: Card) throws
    
    /// Returns card at this CardSeat that can be selected, if exists.
    /// Foundations always return nil, FreeCells return the item if exists, and
    /// Columns return the top card if exists.
    func selectableCard() -> Card?
}

public extension CardSeat where Self: Stack, T == Card {
    func receive(_ card: Card) throws {
        try push(card)
    }
}

public enum CardSeatType {
    case freecell, foundation, column
}
