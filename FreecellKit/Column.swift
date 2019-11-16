//
//  Column.swift
//  FreecellKit
//
//  Created by Jason Ji on 11/14/19.
//  Copyright © 2019 Jason Ji. All rights reserved.
//

import Foundation
import DeckKit

class Column: Stack {
    var stack = [Card]()
    var maxSize: Int { return 52 }
    var topItem: Card? { return stack.last }
    
    func push(_ item: Card) throws {
        if let topCard = topItem,
            !topCard.isOppositeColor(of: item) {
            throw FreecellError.invalidSuitForColumn(baseCard: topCard, newCard: item)
        }
        
        if let topCard = topItem,
            item.rank.value != topCard.rank.value - 1 {
            throw FreecellError.invalidRankForColumn(baseCard: topCard, newCard: item)
        }
        
        stack.append(item)
    }
    
    func pop() -> Card? {
        guard !stack.isEmpty else { return nil }
        return stack.removeLast()
    }
}
