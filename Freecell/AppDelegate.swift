//
//  AppDelegate.swift
//  Freecell
//
//  Created by Jason Ji on 11/13/19.
//  Copyright © 2019 Jason Ji. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
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
        
        builder.remove(menu: .file)
        builder.remove(menu: .edit)
        builder.remove(menu: .format)
        
        let newGame = UIKeyCommand(title: "New Game", action: #selector(GameHostingController.postNewGame), input: "n", modifierFlags: .command)
        let restartGame = UIKeyCommand(title: "Restart Game", action: #selector(GameHostingController.postRestartGame), input: "r", modifierFlags: [.command, .shift])

        let gameMenu = UIMenu(title: "Game", image: nil, identifier: UIMenu.Identifier("Game"), options: [], children: [ newGame, restartGame ])
        builder.insertSibling(gameMenu, afterMenu: .application)
        
        #warning("Catalyst TODO: Add undo in Game menu, add divider, add visual theming")
        #warning("Catalyst TODO: Add Statistics window and add it to the Game menu")
    }
}

