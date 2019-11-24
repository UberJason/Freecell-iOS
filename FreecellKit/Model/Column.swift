//
//  Column.swift
//  FreecellKit
//
//  Created by Jason Ji on 11/14/19.
//  Copyright © 2019 Jason Ji. All rights reserved.
//

import Foundation
import DeckKit

public class Column: CardStack, CardLocation {
    public let id: Int
    
    public init(id: Int) {
        self.id = id
        super.init()
    }
    
    public func canReceive(_ card: Card) -> Bool {
        guard let topItem = topItem else { return true }
        
        return self.card(card, canStackOn: topItem)
    }
    
//    public func validSubstack() -> CardStack? {
//        guard let topItem = topItem else { return nil }
//        guard stack.count > 1 else { return CardStack(cards: [topItem]) }
//        
//        let reversedStack = stack.reversed()
//        var topCard = reversedStack.first
//        
//    }

    
    //    public func pushStack(_ cardStack: CardStack) throws {
    //        fatalError("Implement pushStack(_:)")
    ////        stack.append(contentsOf: cardStack.stack)
    //    }
    
}
