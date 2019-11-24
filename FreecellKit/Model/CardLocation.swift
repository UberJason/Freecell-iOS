//
//  CardLocation.swift
//  FreecellKit
//
//  Created by Jason Ji on 11/18/19.
//  Copyright © 2019 Jason Ji. All rights reserved.
//

import Foundation
import DeckKit

public protocol CardLocation {
    var id: Int { get }
    func contains(_ card: Card) -> Bool
    func pop() -> Card?
    func canReceive(_ card: Card) -> Bool
    func receive(_ card: Card) throws
}

public extension CardLocation where Self: Stack, T == Card {
    func receive(_ card: Card) throws {
        try push(card)
    }
}
