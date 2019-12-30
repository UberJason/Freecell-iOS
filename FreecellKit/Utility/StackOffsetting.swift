//
//  StackOffsetting.swift
//  FreecellKit
//
//  Created by Jason Ji on 12/15/19.
//  Copyright © 2019 Jason Ji. All rights reserved.
//

import CoreGraphics
import DeckKit

protocol StackOffsetting {
    func offset(for card: Card, orderIndex: Int) -> CGSize
}

extension StackOffsetting {
    func offset(for card: Card, orderIndex: Int) -> CGSize {
        return CGSize(width: 0, height: 40*CGFloat(orderIndex))
    }
}