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
        
        let window = UIWindow(windowScene: windowScene)
        // Create the SwiftUI view that provides the window contents.
        let game = Game(undoManager: window.undoManager)
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
        
        #warning("Catalyst TODO: Toolbar with Undo, Restart Game, New Game, Statistics buttons.")
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

#if targetEnvironment(macCatalyst)
class ToolbarManager: NSObject, NSToolbarDelegate {
    weak var hostingController: GameHostingController?
    
    let configurations = [
        ToolbarConfiguration(identifier: .undo, title: "Undo", image: UIImage(systemName: "arrow.uturn.left.circle"), toolTip: "Undo the last move.", action: #selector(undoPressed)),
        ToolbarConfiguration(identifier: .restart, title: "Restart Game", image: UIImage(systemName: "arrow.uturn.left"), toolTip: "Restart the game.", action: #selector(restartGamePressed)),
        ToolbarConfiguration(identifier: .newGame, title: "New Game", image: UIImage(systemName: "goforward.plus"), toolTip: "Abandon the current game and start a new game.", action: #selector(newGamePressed)),
        ToolbarConfiguration(identifier: .statistics, title: "Statistics", image: UIImage(systemName: "doc.plaintext"), toolTip: "View statistics for your games.", action: #selector(statisticsPressed))
    ]
    
    func toolbar(_ toolbar: NSToolbar, itemForItemIdentifier itemIdentifier: NSToolbarItem.Identifier, willBeInsertedIntoToolbar flag: Bool) -> NSToolbarItem? {
        guard let configuration = configurations.first(where: { $0.identifier == itemIdentifier }) else { return nil }
        
        let item = NSToolbarItem(itemIdentifier: configuration.identifier)
        item.label = configuration.title
        item.toolTip = configuration.toolTip
        item.image = configuration.image
        item.target = self
        item.action = configuration.action
        return item
    }
    
    func toolbarDefaultItemIdentifiers(_ toolbar: NSToolbar) -> [NSToolbarItem.Identifier] {
        return [.undo, .flexibleSpace, .restart, .newGame, .flexibleSpace, .statistics]
    }
    
    func toolbarAllowedItemIdentifiers(_ toolbar: NSToolbar) -> [NSToolbarItem.Identifier] {
        return []
    }
    
    func toolbarSelectableItemIdentifiers(_ toolbar: NSToolbar) -> [NSToolbarItem.Identifier] {
        return []
    }
    
    @objc func undoPressed() {
        hostingController?.undoPressed()
    }
    
    @objc func restartGamePressed() {
        hostingController?.postRestartGame()
    }
    
    @objc func newGamePressed() {
        hostingController?.postNewGame()
    }
    
    @objc func statisticsPressed() {
        print("statisticsPressed")
    }
}


extension NSToolbarItem.Identifier {
    static let undo = NSToolbarItem.Identifier(rawValue: "undo")
    static let restart = NSToolbarItem.Identifier(rawValue: "restart")
    static let newGame = NSToolbarItem.Identifier(rawValue: "newGame")
    static let statistics = NSToolbarItem.Identifier(rawValue: "statistics")
}

struct ToolbarConfiguration {
    let identifier: NSToolbarItem.Identifier
    let title: String
    let image: UIImage?
    let toolTip: String
    let action: Selector
}
#endif
