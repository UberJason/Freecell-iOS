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
