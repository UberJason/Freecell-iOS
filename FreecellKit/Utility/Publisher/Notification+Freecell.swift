//
//  Notification+NewGame.swift
//  FreecellKit
//
//  Created by Jason Ji on 1/30/20.
//  Copyright © 2020 Jason Ji. All rights reserved.
//

import Foundation

public extension Notification.Name {
    static let newGame = Notification.Name(rawValue: "newGame")
    static let performUndo = Notification.Name(rawValue: "performUndo")
    static let performRedo = Notification.Name(rawValue: "performRedo")
    
    static let performBombAnimation = Notification.Name("performBombAnimation")
    
    static let showMenu = Notification.Name(rawValue: "showMenu")
    static let dismissMenu = Notification.Name(rawValue: "dismissMenu")
}
