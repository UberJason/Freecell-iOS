//
//  Image+Freecell.swift
//  FreecellKit
//
//  Created by Jason Ji on 2/24/20.
//  Copyright © 2020 Jason Ji. All rights reserved.
//

import SwiftUI

#if os(macOS)
#warning("Re-export images for macOS in a square aspect ratio")
#endif

public extension Symbol.Identifier {
    static let clubs = Symbol.Identifier(rawValue: "suit.club.fill")
    static let diamonds = Symbol.Identifier(rawValue: "suit.diamond.fill")
    static let hearts = Symbol.Identifier(rawValue: "suit.heart.fill")
    static let spades = Symbol.Identifier(rawValue: "suit.spade.fill")
    
    static let undo = Symbol.Identifier(rawValue: "arrow.uturn.left.circle")
    static let settings = Symbol.Identifier(rawValue: "gear")
    static let expand = Symbol.Identifier(rawValue: "arrow.up.left.and.arrow.down.right")
    static let collapse = Symbol.Identifier(rawValue: "arrow.down.right.and.arrow.up.left")
}

public extension Image {
    init(identifier: Symbol.Identifier) {
        self.init(systemName: identifier.rawValue)
    }
}

public extension Image {
    static var clubs: Image {
        #if os(macOS)
        return Image("Club", bundle: Bundle.freecellKit)
        #else
        return Image(identifier: .clubs)
        #endif
    }
    
    static var diamonds: Image {
        #if os(macOS)
        return Image("Diamond", bundle: Bundle.freecellKit)
        #else
        return Image(identifier: .diamonds)
        #endif
    }
    
    static var hearts: Image {
        #if os(macOS)
        return Image("Heart", bundle: Bundle.freecellKit)
        #else
        return Image(identifier: .hearts)
        #endif
    }
    
    static var spades: Image {
        #if os(macOS)
        return Image("Spade", bundle: Bundle.freecellKit)
        #else
        return Image(identifier: .clubs)
        #endif
    }
}

#if !os(macOS)
public extension Image {
    static var undo: Image {
        Image(identifier: .undo)
    }
    
    static var settings: Image {
        Image(identifier: .settings)
    }
    
    static var expand: Image {
        Image(identifier: .expand)
    }
    
    static var collapse: Image {
        Image(identifier: .collapse)
    }
}
#endif
