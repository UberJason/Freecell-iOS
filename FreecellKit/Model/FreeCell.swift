//
//  FreeCell.swift
//  FreecellKit
//
//  Created by Jason Ji on 11/14/19.
//  Copyright © 2019 Jason Ji. All rights reserved.
//

import Foundation
import DeckKit

public class FreeCell: Stack, CardLocation, Identifiable, ObservableObject {
    public let id: Int
    @Published public var item: Card?
    public var maxSize: Int { return 1 }
    public var topItem: Card? { return item }
    public var items: [Card] {
        guard let item = item else { return [] }
        return [item]
    }
    
    init(id: Int) {
        self.id = id
    }
    
    public func push(_ item: Card) throws {
        guard case .none = self.item else {
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
}

