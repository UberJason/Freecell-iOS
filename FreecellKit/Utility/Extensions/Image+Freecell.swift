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
        return Image(identifier: .spades)
        #endif
    }
    
    static var boardLayoutTutorial: Image {
        return Image("BoardLayout", bundle: Bundle.freecellKit)
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
    
    static var trash: Image {
        Image(identifier: .trash)
    }
    
    static var expand: Image {
        Image(identifier: .expand)
    }
    
    static var collapse: Image {
        Image(identifier: .collapse)
    }
    
    static var restart: Image {
        Image(identifier: .restart)
    }
    
    static var newGame: Image {
        Image(identifier: .newGame)
    }
    
    static var controls: Image {
        Image(identifier: .controls)
    }
}
#endif
