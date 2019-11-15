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
    var topItem: Card? { return stack.last }

    init(suit: Suit) {
        self.suit = suit
    }
    
    func push(_ item: Card) throws {
        guard item.suit == suit else {
            throw FreecellError.invalidSuitForFoundation
        }
        guard item.rank.value == item.rank.value + 1 else {
            throw FreecellError.invalidRankForFoundation
        }
        
    }
    
    func pop() -> Card? {
        assertionFailure("Can't remove a card from Foundation")
        return nil
    }
}
