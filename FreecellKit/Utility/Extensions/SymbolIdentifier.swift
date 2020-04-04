//
//  SymbolIdentifier.swift
//  FreecellKit
//
//  Created by Jason Ji on 4/4/20.
//  Copyright © 2020 Jason Ji. All rights reserved.
//

import Foundation

public struct Symbol {
    public struct Identifier: RawRepresentable {
        public var rawValue: String
        
        public init(rawValue: String) {
            self.rawValue = rawValue
        }
    }
}
