//
//  Image+Freecell.swift
//  FreecellKit
//
//  Created by Jason Ji on 2/24/20.
//  Copyright © 2020 Jason Ji. All rights reserved.
//

import SwiftUI

#warning("Re-export images for macOS in a square aspect ratio")
public extension Image {
    static var clubs: Image {
        #if os(macOS)
        return Image("Club", bundle: Bundle.freecellKit)
        #else
        return Image(systemName: "suit.club.fill")
        #endif
    }
    
    static var diamonds: Image {
        #if os(macOS)
        return Image("Diamond", bundle: Bundle.freecellKit)
        #else
        return Image(systemName: "suit.diamond.fill")
        #endif
    }
    
    static var hearts: Image {
        #if os(macOS)
        return Image("Heart", bundle: Bundle.freecellKit)
        #else
        return Image(systemName: "suit.heart.fill")
        #endif
    }
    
    static var spades: Image {
        #if os(macOS)
        return Image("Spade", bundle: Bundle.freecellKit)
        #else
        return Image(systemName: "suit.spade.fill")
        #endif
    }
}

#if !os(macOS)
public extension Image {
    static var undo: Image {
        Image(systemName: "arrow.uturn.left.circle")
    }
    
    static var settings: Image {
        Image(systemName: "gear")
    }
    
    static var expand: Image {
        Image(systemName: "arrow.up.left.and.arrow.down.right")
    }
    
    static var collapse: Image {
        Image(systemName: "arrow.down.right.and.arrow.up.left")
    }
}
#endif
