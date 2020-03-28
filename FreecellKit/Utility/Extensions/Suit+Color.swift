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
        case .red: return .redSuitColor
        case .black: return .black
        }
    }
    
    var displayImage: some View {
        let image: Image
        switch self {
        case .clubs:
            image = Image.clubs
        case .diamonds:
            image = Image.diamonds
        case .hearts:
            image = Image.hearts
        case .spades:
            image = Image.spades
        }
        
        #if os(macOS)
        return image
            .resizable()
            .aspectRatio(contentMode: .fill)
            .foregroundColor(swiftUIColor)
        #else
        return image.foregroundColor(swiftUIColor)
        #endif
    }
}

#if os(iOS)
extension Suit {
    var uiColor: UIColor {
        switch color {
        case .red: return .red
        case .black: return .black
        }
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
    
    var uiImage: UIImage {
        let configuration = UIImage.SymbolConfiguration(pointSize: 25, weight: .regular, scale: .large)
        guard let image = UIImage(systemName: imageSystemName, withConfiguration: configuration) else { fatalError("No image for that systemName") }
        return image.withTintColor(uiColor, renderingMode: .alwaysOriginal)
    }
}
#endif
