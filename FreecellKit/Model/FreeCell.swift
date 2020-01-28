//
//  FreeCell.swift
//  FreecellKit
//
//  Created by Jason Ji on 11/14/19.
//  Copyright © 2019 Jason Ji. All rights reserved.
//

import Foundation
import DeckKit

public class FreeCell: Stack, CardSeat, Identifiable {
    public let id: Int
    public var item: Card?
    
    public var maxSize: Int { return 1 }
    
    public var topItem: Card? { return item }
    
    public var items: [Card] {
        guard let item = item else { return [] }
        return [item]
    }
    
    public var isOccupied: Bool { return item != nil }
    
    init(id: Int, card: Card? = nil) {
        self.id = id
        self.item = card
    }
    
    public func push(_ item: Card) throws {
        guard !isOccupied else {
            throw FreecellError.cellOccupied
        }
        
        self.item = item
    }
    
    public func pop() -> Card? {
        guard let _ = item else { return nil }
        
        let poppedItem = item
        item = nil
        return poppedItem
    }
    
    public func item(at index: Int) -> Card? {
        guard index == 0 else { return nil }
        return item
    }
    
    public func contains(_ card: Card) -> Bool {
        return item == card
    }
    
    public func canReceive(_ card: Card) -> Bool {
        return !isOccupied
    }
    
    public func selectableCard() -> Card? {
        return item
    }
}

extension FreeCell: NSCopying {
    public func copy(with zone: NSZone? = nil) -> Any {
        return FreeCell(id: id, card: item)
    }
}
