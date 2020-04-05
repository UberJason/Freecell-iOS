//
//  MenuController.swift
//  Freecell
//
//  Created by Jason Ji on 4/4/20.
//  Copyright © 2020 Jason Ji. All rights reserved.
//

import UIKit
import FreecellKit

class MenuController {
    let settingsStore = SettingsStore()
    let builder: UIMenuBuilder
    
    init(with builder: UIMenuBuilder) {
        self.builder = builder
    }

    func buildMenu() {
        builder.remove(menu: .file)
        builder.remove(menu: .edit)
        builder.remove(menu: .format)
        
        let newGame = UIKeyCommand(title: "New Game", action: #selector(GameHostingController.postNewGame), input: "n", modifierFlags: .command)
        let restartGame = UIKeyCommand(title: "Restart Game", action: #selector(GameHostingController.postRestartGame), input: "r", modifierFlags: [.command, .shift])
        let undo = UIKeyCommand(title: "Undo", action: #selector(GameHostingController.undoPressed), input: "z", modifierFlags: .command)
        
        let gameMenu = UIMenu(title: "Game", image: nil, identifier: .game, options: [], children: [ restartGame, newGame ])
        builder.insertSibling(gameMenu, afterMenu: .application)
        let undoMenu = UIMenu(title: "Undo", image: nil, identifier: .undo, options: [.displayInline], children: [undo])
        builder.insertChild(undoMenu, atStartOfMenu: .game)
        
        let separator = UIMenu(title: "", image: nil, identifier: .separator, options: [.displayInline], children: [])
        builder.insertChild(separator, atEndOfMenu: .game)
        
        let controlStyleCommands = ControlStyle.allCases.map { controlStyle in
            UICommand(title: controlStyle.rawValue, action: #selector(AppDelegate.setControlStyle(_:)), propertyList: ["controlStyle": controlStyle.rawValue], state: settingsStore.controlStyle == controlStyle ? .on : .off)
        }
        let controlStyleMenu = UIMenu(title: "Control Style", image: nil, identifier: .controlStyle, options: [], children: controlStyleCommands)
        builder.insertChild(controlStyleMenu, atEndOfMenu: .game)
        
        let viewStats = UIKeyCommand(title: "View Statistics...", action: #selector(GameHostingController.presentStatisticsView), input: "s", modifierFlags: [.command, .shift])
        let viewStatsMenu = UIMenu(title: "View Statistics", image: nil, identifier: .viewStats, options: [.displayInline], children: [viewStats])
        builder.insertChild(viewStatsMenu, atEndOfMenu: .game)
        
        let themeCommands = VisualTheme.allCases.map { theme in
            UICommand(title: theme.title, action: #selector(AppDelegate.setTheme(_:)), propertyList: ["theme": theme.rawValue], state: settingsStore.preferredVisualTheme == theme ? .on : .off)
        }
        
        let visualTheme = UIMenu(title: "Visual Theme", image: nil, identifier: .theme, options: [], children: themeCommands)
        builder.insertChild(visualTheme, atStartOfMenu: .view)
    }
}
