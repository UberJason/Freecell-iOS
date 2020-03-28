//
//  UserDefaults+VisualTheming.swift
//  FreecellKit
//
//  Created by Jason Ji on 3/27/20.
//  Copyright © 2020 Jason Ji. All rights reserved.
//

import Foundation

extension UserDefaults {
    public static let preferredVisualThemeKey = "preferredVisualTheme"
    
    public var preferredVisualTheme: VisualTheme {
        get {
            if let themeTitle = string(forKey: type(of: self).preferredVisualThemeKey),
                let theme = VisualTheme(rawValue: themeTitle) {
                return theme
            }
            else {
                let theme = VisualTheme.system
                set(theme.rawValue, forKey: type(of: self).preferredVisualThemeKey)
                synchronize()
                
                return theme
            }
        }
        set {
            set(newValue.rawValue, forKey: type(of: self).preferredVisualThemeKey)
            synchronize()
        }
    }
}
