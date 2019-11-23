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
    
//    public func validSubstack() -> CardStack {
//        return CardStack(cards: <#[Card]#>)
//    }
    
    
    //    public func pushStack(_ cardStack: CardStack) throws {
    //        fatalError("Implement pushStack(_:)")
    ////        stack.append(contentsOf: cardStack.stack)
    //    }
    
}
