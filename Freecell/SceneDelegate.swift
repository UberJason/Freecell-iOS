//
//  SceneDelegate.swift
//  Freecell
//
//  Created by Jason Ji on 11/13/19.
//  Copyright © 2019 Jason Ji. All rights reserved.
//

import UIKit
import SwiftUI
import FreecellKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    #if targetEnvironment(macCatalyst)
    let toolbarManager = ToolbarManager()
    #endif
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).

        // Use a UIHostingController as window root view controller.
        guard let windowScene = scene as? UIWindowScene else { return }
        windowScene.sizeRestrictions?.minimumSize = CGSize(width: 1024, height: 640)
        
        let preconfiguredBoard = CommandLine.arguments.contains("-usePreconfiguredBoard") ? BoardParser().parse(fromFile: "AUI+Screenshots") : nil
        
        let window = UIWindow(windowScene: windowScene)
        let game = Game(undoManager: window.undoManager, preconfiguredBoard: preconfiguredBoard)
        let contentView = ContentView(game: game)

        let hostingController = GameHostingController(game: game, rootView: contentView)
        window.rootViewController = hostingController
        self.window = window
        window.makeKeyAndVisible()
        
        #if targetEnvironment(macCatalyst)
        if let titlebar = windowScene.titlebar {
            toolbarManager.hostingController = hostingController
            let toolbar = NSToolbar(identifier: "Test Toolbar")
            toolbar.delegate = toolbarManager
            toolbar.allowsUserCustomization = false
            
            titlebar.toolbar = toolbar
        }
        #endif
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not neccessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }
}
