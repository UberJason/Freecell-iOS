//
//  AppDelegate.swift
//  Freecell-Mac
//
//  Created by Jason Ji on 11/27/19.
//  Copyright © 2019 Jason Ji. All rights reserved.
//

import Cocoa
import SwiftUI
import FreecellKit

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    var window: NSWindow!
    var undoManager: UndoManager?
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {

        // Create the window and set the content view. 
        window = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 900, height: 800),
            styleMask: [.titled, .closable, .miniaturizable, .resizable, .fullSizeContentView],
            backing: .buffered, defer: false)
        window.center()
        window.setFrameAutosaveName("Main Window")
        undoManager = window.undoManager
        
        // Create the SwiftUI view that provides the window contents.
        let game = Game(undoManager: undoManager)
        let contentView = ContentView(game: game)
        
        window.contentView = NSHostingView(rootView: contentView)
        window.makeKeyAndOrderFront(nil)
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

    @IBAction func restartGame(_ sender: Any) {
        NotificationCenter.default.post(name: .restartGameRequested, object: nil)
    }
    
    @IBAction func newGame(_ sender: Any) {
        NotificationCenter.default.post(name: .newGameRequested, object: nil)
    }
    
    @IBAction func undoMove(_ sender: Any) {
        undoManager?.undo()
    }
}
