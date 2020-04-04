//
//  ToolbarManager.swift
//  Freecell
//
//  Created by Jason Ji on 4/4/20.
//  Copyright © 2020 Jason Ji. All rights reserved.
//

import UIKit

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

struct ToolbarConfiguration {
    let identifier: NSToolbarItem.Identifier
    let title: String
    let image: UIImage?
    let toolTip: String
    let action: Selector
}
#endif
