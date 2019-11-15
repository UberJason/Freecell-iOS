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
    
    func push(_ item: T) throws
    func pop() -> T?
    var topItem: T? { get }
    var maxSize: Int { get }
}
