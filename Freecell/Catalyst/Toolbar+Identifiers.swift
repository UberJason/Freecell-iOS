//
//  Toolbar+Identifiers.swift
//  Freecell
//
//  Created by Jason Ji on 4/4/20.
//  Copyright © 2020 Jason Ji. All rights reserved.
//

import UIKit

#if targetEnvironment(macCatalyst)
extension NSToolbarItem.Identifier {
    static let undo = NSToolbarItem.Identifier(rawValue: "undo")
    static let restart = NSToolbarItem.Identifier(rawValue: "restart")
    static let newGame = NSToolbarItem.Identifier(rawValue: "newGame")
    static let statistics = NSToolbarItem.Identifier(rawValue: "statistics")
}
#endif
