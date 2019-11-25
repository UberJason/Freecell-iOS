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
}
