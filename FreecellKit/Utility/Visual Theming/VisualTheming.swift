//
//  VisualTheming.swift
//  FeedingKit
//
//  Created by Jason Ji on 7/10/19.
//  Copyright © 2019 Jason Ji. All rights reserved.
//

import UIKit

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

