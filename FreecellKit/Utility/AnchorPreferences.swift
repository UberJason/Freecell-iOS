//
//  CellInfo.swift
//  FreecellKit
//
//  Created by Jason Ji on 1/26/20.
//  Copyright © 2020 Jason Ji. All rights reserved.
//

import SwiftUI


/// CellInfo is used to provide the location of Freecells, Foundations, and Columns.
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


/// ColumnStackWidth is used to provide the total horizontal width of the 8 columns, for alignment purposes.
public struct ColumnStackWidth: Equatable {
    public static func == (lhs: ColumnStackWidth, rhs: ColumnStackWidth) -> Bool {
        return lhs.uuid == rhs.uuid
    }
    
    let uuid = UUID()
    var bounds: Anchor<CGRect>? = nil
}

public struct ColumnStackWidthKey: PreferenceKey {
    public static var defaultValue = ColumnStackWidth()
    
    public static func reduce(value: inout ColumnStackWidth, nextValue: () -> ColumnStackWidth) {
        value = nextValue()
    }
}


/// TopStackBounds is used to provide the position of the top stack containing Freecells and Foundations, to position ControlsView in the center of it.
public struct TopStackBounds {
    var bounds: Anchor<CGRect>? = nil
}

public struct TopStackBoundsKey: PreferenceKey {
    public static var defaultValue = TopStackBounds()
    public static func reduce(value: inout TopStackBounds, nextValue: () -> TopStackBounds) {
        if let bounds = nextValue().bounds {
            value.bounds = bounds
        }
    }
}
