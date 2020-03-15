//
//  UserDefaultPropertyWrapper.swift
//  FreecellKit
//
//  Created by Jason Ji on 3/15/20.
//  Copyright © 2020 Jason Ji. All rights reserved.
//

import Foundation

@propertyWrapper
public struct UserDefault<T: RawRepresentable> {
    let key: String
    let defaultValue: T
    let suiteName: String?

    var store: UserDefaults {
        return UserDefaults(suiteName: suiteName) ?? UserDefaults.standard
    }
    
    public init(key: String, defaultValue: T, suiteName: String? = nil) {
        self.key = key
        self.defaultValue = defaultValue
        self.suiteName = suiteName
    }
    
    public var wrappedValue: T {
        get {
            if let rawValue = store.object(forKey: key) as? T.RawValue,
                let value = T(rawValue: rawValue) {
                return value
            }
            store.set(defaultValue.rawValue, forKey: key)
            return defaultValue
        }
        set {
            store.set(newValue.rawValue, forKey: key)
        }
    }
}
