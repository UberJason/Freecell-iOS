//
//  SuitColor+Color.swift
//  FreecellKit
//
//  Created by Jason Ji on 11/24/19.
//  Copyright © 2019 Jason Ji. All rights reserved.
//

import SwiftUI
import DeckKit

extension Suit {
    var swiftUIColor: Color {
        switch color {
        case .red: return .red
        case .black: return .black
        }
    }
    
    var displayImage: some View {
        let image: Image
        switch self {
        case .clubs:
            image = Image(systemName: "suit.club.fill")
        case .diamonds:
            image = Image(systemName: "suit.diamond.fill")
        case .hearts:
            image = Image(systemName: "suit.heart.fill")
        case .spades:
            image = Image(systemName: "suit.spade.fill")
        }
        
        return image.foregroundColor(swiftUIColor)
    }
}
