//
//  Foundation.swift
//  FreecellKit
//
//  Created by Jason Ji on 11/14/19.
//  Copyright © 2019 Jason Ji. All rights reserved.
//

import Foundation
import DeckKit

class Foundation: Stack {
    let suit: Suit
    var stack = [Card]()
    
    var maxSize: Int { return 13 }
    var topItem: Card? { return stack.last ?? nil }

    init(suit: Suit) {
        self.suit = suit
    }
    
    func push(_ item: Card) throws {
        guard item.suit == suit else {
            throw FreecellError.invalidSuitForFoundation
        }
        
        if let topItem = topItem, item.rank.value != topItem.rank.value + 1 {
            print("Fail: topCard is rank \(topItem.rank.value) and new item is rank \(item.rank.value)")
            throw FreecellError.invalidRankForFoundation
        }

        stack.append(item)
    }
    
    func pop() -> Card? {
        assertionFailure("Can't remove a card from Foundation")
        return nil
    }
}
