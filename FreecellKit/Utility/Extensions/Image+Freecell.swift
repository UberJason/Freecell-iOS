//
//  Image+Freecell.swift
//  FreecellKit
//
//  Created by Jason Ji on 2/24/20.
//  Copyright © 2020 Jason Ji. All rights reserved.
//

import SwiftUI

public extension Image {
    static var undo: Image {
        return Image(systemName: "arrow.uturn.left.circle")
    }
    
    static var settings: Image {
        return Image(systemName: "gear")
    }
    
    static var clubs: Image {
        return Image(systemName: "suit.club.fill")
    }
    
    static var diamonds: Image {
        return Image(systemName: "suit.diamond.fill")
    }
    
    static var hearts: Image {
        return Image(systemName: "suit.heart.fill")
    }
    
    static var spades: Image {
        return Image(systemName: "suit.spade.fill")
    }
}
