//
//  Notification+NewGame.swift
//  FreecellKit
//
//  Created by Jason Ji on 1/30/20.
//  Copyright © 2020 Jason Ji. All rights reserved.
//

import Foundation

public extension Notification.Name {
    static let newGameRequested = NSNotification.Name(rawValue: "newGameRequested")
    static let restartGameRequested = Notification.Name(rawValue: "restartGameRequested")
    
    static let newGame = Notification.Name(rawValue: "newGame")
    static let restartGame = Notification.Name(rawValue: "restartGame")
    
    static let performBombAnimation = Notification.Name("performBombAnimation")
    
    static let showMenu = Notification.Name(rawValue: "showMenu")
    static let dismissMenu = Notification.Name(rawValue: "dismissMenu")
    
    static let recordResult = Notification.Name("recordResult")
    static let postLoss = Notification.Name(rawValue: "postLoss")
    
    static let updateControlStyle = Notification.Name(rawValue: "updateControlStyle")
    static let preferredVisualThemeDidChange = Notification.Name(rawValue: "preferredVisualThemeDidChange")
    
    static let dismissOnboarding = Notification.Name(rawValue: "dismissOnboarding")
}
