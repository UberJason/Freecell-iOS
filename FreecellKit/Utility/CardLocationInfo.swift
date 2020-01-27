//
//  CardLocationInfo.swift
//  FreecellKit
//
//  Created by Jason Ji on 1/26/20.
//  Copyright © 2020 Jason Ji. All rights reserved.
//

import SwiftUI

struct CardLocationInfo {
    let location: CardLocation
    let type: CardLocationType
    let bounds: Anchor<CGRect>
}

struct CardLocationInfoKey: PreferenceKey {
    static var defaultValue: [CardLocationInfo] = []
    
    static func reduce(value: inout [CardLocationInfo], nextValue: () -> [CardLocationInfo]) {
        value.append(contentsOf: nextValue())
    }
}
