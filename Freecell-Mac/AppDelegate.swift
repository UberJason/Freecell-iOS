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

    var gameEventPublisher = PassthroughSubject<GameEvent, Never>()

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Create the SwiftUI view that provides the window contents.
        let contentView = GameView(newGamePublisher: gameEventPublisher.eraseToAnyPublisher())

        // Create the window and set the content view. 
        window = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 480, height: 300),
            styleMask: [.titled, .closable, .miniaturizable, .resizable, .fullSizeContentView],
            backing: .buffered, defer: false)
        window.center()
        window.setFrameAutosaveName("Main Window")
        window.contentView = NSHostingView(rootView: contentView)
        window.makeKeyAndOrderFront(nil)
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

    @IBAction func newGame(_ sender: Any) {
        gameEventPublisher.send(.newGame)
    }
    
    @IBAction func undoMove(_ sender: Any) {
        gameEventPublisher.send(.undo)
    }
    
    @IBAction func redoMove(_ sender: Any) {
        gameEventPublisher.send(.redo)
    }
}

enum GameEvent {
    case newGame, undo, redo
}
