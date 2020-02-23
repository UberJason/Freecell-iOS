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
    var uiColor: UIColor {
        switch color {
        case .red: return .red
        case .black: return .black
        }
    }
    
    var swiftUIColor: Color {
        return Color(uiColor)
    }
    
    var imageSystemName: String {
        switch self {
        case .clubs:
            return "suit.club.fill"
        case .diamonds:
            return "suit.diamond.fill"
        case .hearts:
            return "suit.heart.fill"
        case .spades:
            return "suit.spade.fill"
        }
    }
    
    var displayImage: some View {
        return Image(systemName: imageSystemName).foregroundColor(swiftUIColor)
    }
    
    var uiImage: UIImage {
        let configuration = UIImage.SymbolConfiguration(pointSize: 25, weight: .regular, scale: .large)
        guard let image = UIImage(systemName: imageSystemName, withConfiguration: configuration) else { fatalError("No image for that systemName") }
        return image.withTintColor(uiColor, renderingMode: .alwaysOriginal)
    }
}
