//
//  Stack.swift
//  FreecellKit
//
//  Created by Jason Ji on 11/14/19.
//  Copyright © 2019 Jason Ji. All rights reserved.
//

import Foundation
import DeckKit

/// Reminder for myself:
/// Stack public interface puts the most recent item at the END of the array
/// and oldest item at the FRONT of the array. Reason is so when rendering
/// the stack in UI, can simply iterate over the items and lay them down one by one.

/// The internal implementations put the most recent item at the FRONT of the array
/// and oldest item at the BACK of the array. Reason is so when pushing one stack
/// onto another, can simply insert the new stack at index 0 on the old one.

public protocol Stack {
    associatedtype T
    
    /// Push an item onto the stack. May throw error if push is disallowed.
    /// - Parameter item: Item to push.
    func push(_ item: T) throws
    
    /// Pop item off of the stack and return it. Returns nil if stack is empty.
    func pop() -> T?
    
    /// Peek item at index. Bottom of stack is index 0. Returns nil if index is invalid.
    /// - Parameter index: Index of item in the stack.
    func item(at index: Int) -> T?
    
    /// Top item on the stack, first to be popped off. Returns nil if stack is empty.
    var topItem: T? { get }
    
    /// List of items, where the most recently pushed item is at the end of the array.
    /// Returns empty array if stack is empty.
    var items: [T] { get }
    
    /// Maximum allowed stack size.
    var maxSize: Int { get }
}

