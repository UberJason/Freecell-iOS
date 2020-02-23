//
//  AppDelegate.swift
//  Freecell-Mac
//
//  Created by Jason Ji on 11/27/19.
//  Copyright © 2019 Jason Ji. All rights reserved.
//

import Cocoa
import SwiftUI
import Combine

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    var window: NSWindow!

    func applicationDidFinishLaunching(_ aNotification: Notification) {

        // Create the window and set the content view. 
        window = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 900, height: 800),
            styleMask: [.titled, .closable, .miniaturizable, .resizable, .fullSizeContentView],
            backing: .buffered, defer: false)
        window.center()
        window.setFrameAutosaveName("Main Window")
        
        // Create the SwiftUI view that provides the window contents.
        let contentView = ContentView(game: Game(undoManager: window.undoManager))
        
        window.contentView = NSHostingView(rootView: contentView)
        window.makeKeyAndOrderFront(nil)
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

    @IBAction func newGame(_ sender: Any) {
        NotificationCenter.default.post(name: .newGame, object: nil)
    }
    
    @IBAction func undoMove(_ sender: Any) {
        NotificationCenter.default.post(name: .performUndo, object: nil)
    }
    
    @IBAction func redoMove(_ sender: Any) {
        NotificationCenter.default.post(name: .performRedo, object: nil)
    }
}
