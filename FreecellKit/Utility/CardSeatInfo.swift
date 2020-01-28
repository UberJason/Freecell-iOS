//
//  CardSeatInfo.swift
//  FreecellKit
//
//  Created by Jason Ji on 1/26/20.
//  Copyright © 2020 Jason Ji. All rights reserved.
//

import SwiftUI

public struct CardSeatInfo {
    let location: CardSeat
    let type: CardSeatType
    let bounds: Anchor<CGRect>
}

public struct CardSeatInfoKey: PreferenceKey {
    public static var defaultValue: [CardSeatInfo] = []
    
    public static func reduce(value: inout [CardSeatInfo], nextValue: () -> [CardSeatInfo]) {
        value.append(contentsOf: nextValue())
    }
}
