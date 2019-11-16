//
//  CardStack.swift
//  FreecellKit
//
//  Created by Jason Ji on 11/16/19.
//  Copyright © 2019 Jason Ji. All rights reserved.
//

import Foundation
import DeckKit

public class CardStack: Column {
    public var bottomItem: Card? { return stack.first }
    
    init(id: Int, cards: [Card]) {
        super.init(id: id)
        stack = cards
    }
}
