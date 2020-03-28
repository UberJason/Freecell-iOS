//
//  DelayedPropertyWrapper.swift
//  FreecellKit
//
//  Created by Jason Ji on 3/26/20.
//  Copyright © 2020 Jason Ji. All rights reserved.
//

import Foundation

@propertyWrapper
public struct Delayed<Value> {
    private var _value: Value? = nil
    
    public init() {}
    
    public var wrappedValue: Value {
        get {
            guard let value = _value else {
                fatalError("Property accessed before being initialized.")
            }
            return value
        }
        set {
            _value = newValue
        }
    }
}
