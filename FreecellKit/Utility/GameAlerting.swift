//
//  GameAlerting.swift
//  FreecellKit
//
//  Created by Jason Ji on 3/25/20.
//  Copyright © 2020 Jason Ji. All rights reserved.
//

import SwiftUI

public protocol GameAlerting {
    func restartGameAlert() -> Alert
    func newGameAlert() -> Alert
}

extension GameAlerting {
    public func restartGameAlert() -> Alert {
        let restart = Alert.Button.destructive(Text("Restart Game")) {
            NotificationCenter.default.post(name: .restartGame, object: nil)
            NotificationCenter.default.post(name: .dismissMenu, object: nil)
        }
        
        return Alert(title: Text("Restart Game"), message: Text("Are you sure you want to restart this game?"), primaryButton: restart, secondaryButton: Alert.Button.cancel())
    }

    public func newGameAlert() -> Alert {
        let newGame = Alert.Button.destructive(Text("New Game")) {
            NotificationCenter.default.post(name: .postLoss, object: nil)
            NotificationCenter.default.post(name: .newGame, object: nil)
            NotificationCenter.default.post(name: .dismissMenu, object: nil)
        }
        
        return Alert(title: Text("New Game"), message: Text("Are you sure you want to start a new game? The current game will be recorded as a loss."), primaryButton: newGame, secondaryButton: Alert.Button.cancel())
    }
}
