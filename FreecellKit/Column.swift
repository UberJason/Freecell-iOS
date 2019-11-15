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
        stack.append(item)
    }
    
    func pop() -> Card? {
        guard !stack.isEmpty else { return nil }
        return stack.removeLast()
    }
}
