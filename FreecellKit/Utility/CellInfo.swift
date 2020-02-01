//
//  CellInfo.swift
//  FreecellKit
//
//  Created by Jason Ji on 1/26/20.
//  Copyright © 2020 Jason Ji. All rights reserved.
//

import SwiftUI

public struct CellInfo {
    let cellId: UUID
    let bounds: Anchor<CGRect>
}

public struct CellInfoKey: PreferenceKey {
    public static var defaultValue: [CellInfo] = []
    
    public static func reduce(value: inout [CellInfo], nextValue: () -> [CellInfo]) {
        value.append(contentsOf: nextValue())
    }
}

public struct CellPosition {
    let cellId: UUID
    let position: CGPoint
}

public struct CellDistance {
    let cellId: UUID
    let distance: CGFloat
}

