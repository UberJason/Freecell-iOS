//
//  Color+Background.swift
//  FreecellKit
//
//  Created by Jason Ji on 2/23/20.
//  Copyright © 2020 Jason Ji. All rights reserved.
//

import SwiftUI

public extension Color {
    static let freecellBackground = Color(UIColor(named: "freecellBackground", in: Bundle.freecellKit, compatibleWith: nil)!)
    static let freecellTheme = Color(UIColor(named: "freecellTheme", in: Bundle.freecellKit, compatibleWith: nil)!)
    static let cardBackground = Color(UIColor(named: "cardBackground", in: Bundle.freecellKit, compatibleWith: nil)!)
    static let redSuitColor = Color(UIColor(named: "redSuitColor", in: Bundle.freecellKit, compatibleWith: nil)!)
    static let blackSuitColor = Color(UIColor(named: "blackSuitColor", in: Bundle.freecellKit, compatibleWith: nil)!)
}
