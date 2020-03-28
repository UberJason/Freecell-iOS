//
//  VisualTheming.swift
//  FeedingKit
//
//  Created by Jason Ji on 7/10/19.
//  Copyright © 2019 Jason Ji. All rights reserved.
//

import UIKit

extension Notification.Name {
    public static let preferredVisualThemeDidChange = Notification.Name(rawValue: "preferredVisualThemeDidChange")
}

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

public protocol VisualTheming where Self: UIViewController {
    func applyPreferredTheme(from defaults: UserDefaults)
    func registerForThemeChanges()
}

extension VisualTheming {
    public func applyPreferredTheme(from defaults: UserDefaults = .standard) {
        let theme = defaults.preferredVisualTheme
        switch theme {
        case .system:
            overrideUserInterfaceStyle = .unspecified
        case .light:
            overrideUserInterfaceStyle = .light
        case .dark:
            overrideUserInterfaceStyle = .dark
        } 
    }
    
    public func registerForThemeChanges() {
        NotificationCenter.default.addObserver(forName: .preferredVisualThemeDidChange, object: nil, queue: nil) { [weak self] (_) in
            self?.applyPreferredTheme()
        }
    }
}

public enum VisualTheme: String, CaseIterable {
    case system, light, dark
    
    public var title: String {
        switch self {
        case .system: return "System"
        case .light: return "Light"
        case .dark: return "Dark"
        }
    }
}

