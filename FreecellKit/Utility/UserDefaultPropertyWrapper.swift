//
//  UserDefaultPropertyWrapper.swift
//  FreecellKit
//
//  Created by Jason Ji on 3/15/20.
//  Copyright © 2020 Jason Ji. All rights reserved.
//

import Foundation

@propertyWrapper
public struct UserDefault<T: UserDefaultConvertible> {
    let key: String
    let defaultValue: T
    let store: UserDefaults

    public init(key: String, suiteName: String?, defaultValue: T) {
        self.init(key: key, store: UserDefaults(suiteName: suiteName) ?? UserDefaults.standard, defaultValue: defaultValue)
    }
    
    public init(key: String, store: UserDefaults = .standard, defaultValue: T) {
        self.key = key
        self.defaultValue = defaultValue
        self.store = store
    }
    
    public var wrappedValue: T {
        get {
            if let storedValue = store.object(forKey: key) as? T.StoredType,
                let value = T.getValue(from: storedValue) {
                return value
            }
            store.set(defaultValue.makeSettable(), forKey: key)
            return defaultValue
        }
        set {
            store.set(newValue.makeSettable(), forKey: key)
        }
    }
}

public protocol UserDefaultConvertible {
    associatedtype StoredType
    
    func makeSettable() -> StoredType
    static func getValue(from settable: StoredType) -> Self?
}

extension UserDefaultConvertible {
    public func makeSettable() -> Self {
        return self
    }
    
    public static func getValue(from settable: Self) -> Self? {
        return settable
    }
}

public extension UserDefaultConvertible where Self: RawRepresentable {
    func makeSettable() -> Self.RawValue {
        return rawValue
    }
    static func getValue(from settable: Self.RawValue) -> Self? {
        return Self.init(rawValue: settable)
    }
    
}
