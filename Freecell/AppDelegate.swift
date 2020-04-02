//
//  AppDelegate.swift
//  Freecell
//
//  Created by Jason Ji on 11/13/19.
//  Copyright © 2019 Jason Ji. All rights reserved.
//

import UIKit
import FreecellKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    @Delayed var menuController: MenuController
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

    override func buildMenu(with builder: UIMenuBuilder) {
        super.buildMenu(with: builder)
        
        menuController = MenuController(with: builder)
        menuController.buildMenu()
    }

    @objc func setTheme(_ sender: Any) {
        guard let command = sender as? UICommand,
            let plist = command.propertyList as? [String : String],
            let themeString = plist["theme"],
            let theme = VisualTheme(rawValue: themeString) else { return }
        
        menuController.settingsStore.preferredVisualTheme = theme
    }
    
    @objc func setControlStyle(_ sender: Any) {
        guard let command = sender as? UICommand,
               let plist = command.propertyList as? [String : String],
               let controlStyleString = plist["controlStyle"],
               let controlStyle = ControlStyle(rawValue: controlStyleString) else { return }
           
           menuController.settingsStore.controlStyle = controlStyle
    }
    
    override func validate(_ command: UICommand) {
        guard let plist = command.propertyList as? [String : String] else { return }
        
        if let themeString = plist["theme"],
            let theme = VisualTheme(rawValue: themeString) {
            command.state = (menuController.settingsStore.preferredVisualTheme == theme) ? .on : .off
        }
        
        else if let controlStyleString = plist["controlStyle"],
            let controlStyle = ControlStyle(rawValue: controlStyleString) {
            command.state = (menuController.settingsStore.controlStyle == controlStyle) ? .on : .off
        }
    }
}

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
        
        let gameMenu = UIMenu(title: "Game", image: nil, identifier: .game, options: [], children: [ newGame, restartGame ])
        builder.insertSibling(gameMenu, afterMenu: .application)
        let undoMenu = UIMenu(title: "Undo", image: nil, identifier: .undo, options: [.displayInline], children: [undo])
        builder.insertChild(undoMenu, atEndOfMenu: .game)
        
        let controlStyleCommands = ControlStyle.allCases.map { controlStyle in
            UICommand(title: controlStyle.rawValue, action: #selector(AppDelegate.setControlStyle(_:)), propertyList: ["controlStyle": controlStyle.rawValue], state: settingsStore.controlStyle == controlStyle ? .on : .off)
        }
        let controlStyleMenu = UIMenu(title: "Control Style", image: nil, identifier: .controlStyle, options: [], children: controlStyleCommands)
        builder.insertChild(controlStyleMenu, atEndOfMenu: .game)
        
        let themeCommands = VisualTheme.allCases.map { theme in
            UICommand(title: theme.title, action: #selector(AppDelegate.setTheme(_:)), propertyList: ["theme": theme.rawValue], state: settingsStore.preferredVisualTheme == theme ? .on : .off)
        }
        
        let visualTheme = UIMenu(title: "Visual Theme", image: nil, identifier: .theme, options: [], children: themeCommands)
        builder.insertChild(visualTheme, atStartOfMenu: .view)
        
        #warning("Catalyst TODO: Add Statistics window and add it to the Game menu")
        #warning("Catalyst TODO: Special Catalyst version of the app icon - Circle with border")
    }
}
