//
//  Column.swift
//  FreecellKit
//
//  Created by Jason Ji on 11/14/19.
//  Copyright © 2019 Jason Ji. All rights reserved.
//

import Foundation
import DeckKit

public class Column: CardStack, Cell {
    public let id: Int
    
    public init(id: Int) {
        self.id = id
        super.init()
    }
    
    public init(id: Int, cards: [Card]) {
        self.id = id
        super.init(cards: cards)
    }
    
    public func canReceive(_ card: Card) -> Bool {
        guard let topItem = topItem else { return true }
        
        return self.card(card, canStackOn: topItem)
    }

    public func selectableCard() -> Card? {
        return topItem
    }
    
    public var isEmpty: Bool { return topItem == nil }
}

extension Column: NSCopying {
    public func copy(with zone: NSZone? = nil) -> Any {
        let copy = Column(id: id, cards: items)
        return copy
    }
}
