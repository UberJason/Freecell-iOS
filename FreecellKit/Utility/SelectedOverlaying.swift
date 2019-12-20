//
//  SelectedOverlaying.swift
//  FreecellKit
//
//  Created by Jason Ji on 11/23/19.
//  Copyright © 2019 Jason Ji. All rights reserved.
//

import SwiftUI
import DeckKit

protocol SelectedOverlaying {
    var selectedCard: Card? { get }
}

extension SelectedOverlaying {
    func overlayView(for card: Card) -> some View {
        let color: Color = selectedCard == card ? .yellow : .clear
        return CardRectangle(foregroundColor: color, opacity: 0.5)
    }
}
