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
    
    public init(id: Int, cards: [Card]) {
        self.id = id
        super.init(cards: cards)
    }
    
    public func canReceive(_ card: Card) -> Bool {
        guard let topItem = topItem else { return true }
        
        return self.card(card, canStackOn: topItem)
    }
    
    public func validSubstack() -> CardStack? {
        guard let topItem = topItem else { return nil }
        guard stack.count > 1 else { return CardStack(cards: [topItem]) }
        
        var currentIndex = stack.endIndex - 1, nextIndex = currentIndex - 1
        var currentCard = stack[currentIndex], nextCard = stack[nextIndex]
    
        while self.card(currentCard, canStackOn: nextCard) && nextIndex >= 0 {
            currentIndex -= 1; nextIndex -= 1
            currentCard = stack[currentIndex]; nextCard = stack[nextIndex]
        }
        
        // At end, currentIndex is top of the valid substack
        let substack = Array(stack[currentIndex..<stack.endIndex])
        
        return CardStack(cards: Array(substack))
    }

    
    //    public func pushStack(_ cardStack: CardStack) throws {
    //        fatalError("Implement pushStack(_:)")
    ////        stack.append(contentsOf: cardStack.stack)
    //    }
    
}
