//
//  AppKitGlueManager.swift
//  AppKitGlue
//
//  Created by Jason Ji on 4/4/20.
//  Copyright © 2020 Jason Ji. All rights reserved.
//

import AppKit

public class AppKitGlueManager: NSObject, AppKitBridging {
    var window: NSWindow!
    
    public required override init() {
        super.init()
    }
    
    public func showStatisticsWindow() {
        window = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 400, height: 400),
            styleMask: [.titled, .closable, .miniaturizable, .resizable, .fullSizeContentView],
            backing: .buffered, defer: false)
        window.title = "Statistics"
        window.center()
        window.setFrameAutosaveName("Statistics Window")
        
        let windowController = NSWindowController(window: window)
        windowController.showWindow(self)
    }
}
