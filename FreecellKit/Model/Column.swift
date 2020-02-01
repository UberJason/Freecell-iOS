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
    public let id: UUID
    
    public init(id: UUID = UUID()) {
        self.id = id
        super.init()
    }
    
    public init(id: UUID = UUID(), cards: [Card]) {
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
    
    public func detachStack(cappedBy capCard: Card) throws {
        guard let index = stack.firstIndex(of: capCard),
            let _ = validSubstack(cappedBy: capCard) else { throw FreecellError.invalidMove }
        
        stack.removeSubrange(index...)
    }
    
    /// Appends a fully-valid card stack to this column, if the move is valid.
    /// - Parameter newStack: Card stack to append to this column.
    public func appendStack(_ newStack: CardStack) throws {
        guard newStack.isFullyValid,
            let capCard = newStack.bottomItem,
            canReceive(capCard)
            else { throw FreecellError.invalidMove }
        
        stack.append(contentsOf: newStack.items)
    }
}

extension Column: NSCopying {
    public func copy(with zone: NSZone? = nil) -> Any {
        let copy = Column(id: id, cards: items)
        return copy
    }
}
