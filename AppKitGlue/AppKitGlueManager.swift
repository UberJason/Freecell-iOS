//
//  AppKitGlueManager.swift
//  AppKitGlue
//
//  Created by Jason Ji on 4/4/20.
//  Copyright © 2020 Jason Ji. All rights reserved.
//

import AppKit

public class AppKitGlueManager: NSObject {
    var window: NSWindow!
    
    public required override init() {
        super.init()
        
        window = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 900, height: 800),
            styleMask: [.titled, .closable, .miniaturizable, .resizable, .fullSizeContentView],
            backing: .buffered, defer: false)
        window.center()
        window.setFrameAutosaveName("Main Window")
        
        let windowController = NSWindowController(window: window)
        windowController.showWindow(self)
    }
}
