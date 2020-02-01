//
//  Cell.swift
//  FreecellKit
//
//  Created by Jason Ji on 11/18/19.
//  Copyright © 2019 Jason Ji. All rights reserved.
//

import Foundation
import DeckKit

public protocol Cell: NSCopying {
    var id: UUID { get }
    func contains(_ card: Card) -> Bool
    func pop() -> Card?
    func canReceive(_ card: Card) -> Bool
    func receive(_ card: Card) throws
    
    
    /// Removes stack capped by capCard from the current cell.
    /// For FreeCell, this will be the single item in the cell.
    /// For Foundation, this function always throws.
    /// - Parameter capCard: cap of the stack to remove.
    func detachStack(cappedBy capCard: Card) throws
    
    /// Returns card at this Cell that can be selected, if exists.
    /// Foundations always return nil, FreeCells return the item if exists, and
    /// Columns return the top card if exists.
    func selectableCard() -> Card?
}

public extension Cell where Self: Stack, T == Card {
    func receive(_ card: Card) throws {
        try push(card)
    }
}
