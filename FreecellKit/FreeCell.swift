//
//  FreeCell.swift
//  FreecellKit
//
//  Created by Jason Ji on 11/14/19.
//  Copyright © 2019 Jason Ji. All rights reserved.
//

import Foundation
import DeckKit

class FreeCell: Stack {
    var item: Card?
    var maxSize: Int { return 1 }
    var topItem: Card? { return item }
    
    func push(_ item: Card) throws {
        guard case .none = self.item else {
            throw FreecellError.cellOccupied
        }
        
        self.item = item
    }
    
    func pop() -> Card? {
        guard let _ = item else { return nil }
        
        let poppedItem = item
        item = nil
        return poppedItem
    }
}

