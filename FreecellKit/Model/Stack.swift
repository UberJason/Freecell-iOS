//
//  Stack.swift
//  FreecellKit
//
//  Created by Jason Ji on 11/14/19.
//  Copyright © 2019 Jason Ji. All rights reserved.
//

import Foundation
import DeckKit

protocol Stack {
    associatedtype T
    
    /// Push an item onto the stack. May throw error if push is disallowed.
    /// - Parameter item: Item to push.
    func push(_ item: T) throws
    
    /// Pop item off of the stack and return it. Returns nil if stack is empty.
    func pop() -> T?
    
    /// Peek item at index. Top of stack is index 0. Returns nil if index is invalid.
    /// - Parameter index: Index of item in the stack.
    func item(at index: Int) -> T?
    
    /// Top item on the stack, first to be popped off. Returns nil if stack is empty.
    var topItem: T? { get }
    
    /// Maximum allowed stack size.
    var maxSize: Int { get }
}

