//
//  CardLocation.swift
//  FreecellKit
//
//  Created by Jason Ji on 11/18/19.
//  Copyright © 2019 Jason Ji. All rights reserved.
//

import Foundation
import DeckKit

public protocol CardLocation: NSCopying {
    var id: Int { get }
    func contains(_ card: Card) -> Bool
    func pop() -> Card?
    func canReceive(_ card: Card) -> Bool
    func receive(_ card: Card) throws
    
    /// Returns card at this CardLocation that can be selected, if exists.
    /// Foundations always return nil, FreeCells return the item if exists, and
    /// Columns return the top card if exists.
    func selectableCard() -> Card?
}

public extension CardLocation where Self: Stack, T == Card {
    func receive(_ card: Card) throws {
        try push(card)
    }
}

public enum CardLocationType {
    case freecell, foundation, column
}
