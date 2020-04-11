//
//  AppDelegate.swift
//  Freecell
//
//  Created by Jason Ji on 11/13/19.
//  Copyright © 2019 Jason Ji. All rights reserved.
//

import UIKit
import FreecellKit

#warning("Freecell 1.1: Error message for invalid moves")
#warning("Freecell 1.1: How To Play interactive tutorial?")
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
}

// MARK: - Menu Bar Command Selectors -
extension AppDelegate {
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
