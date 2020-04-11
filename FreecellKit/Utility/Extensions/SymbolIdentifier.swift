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

public extension Symbol.Identifier {
    static let clubs = Symbol.Identifier(rawValue: "suit.club.fill")
    static let diamonds = Symbol.Identifier(rawValue: "suit.diamond.fill")
    static let hearts = Symbol.Identifier(rawValue: "suit.heart.fill")
    static let spades = Symbol.Identifier(rawValue: "suit.spade.fill")
    
    static let expand = Symbol.Identifier(rawValue: "arrow.up.left.and.arrow.down.right")
    static let collapse = Symbol.Identifier(rawValue: "arrow.down.right.and.arrow.up.left")
    
    static let undo = Symbol.Identifier(rawValue: "arrow.uturn.left.circle")
    static let settings = Symbol.Identifier(rawValue: "gear")
    static let trash = Symbol.Identifier(rawValue: "trash.fill")
    
    static let restart = Symbol.Identifier(rawValue: "arrow.uturn.left")
    static let newGame = Symbol.Identifier(rawValue: "goforward.plus")
    static let controls = Symbol.Identifier(rawValue: "slider.horizontal.3")
}
