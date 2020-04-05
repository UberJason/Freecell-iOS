//
//  AppKitGlueManager.swift
//  AppKitGlue
//
//  Created by Jason Ji on 4/4/20.
//  Copyright © 2020 Jason Ji. All rights reserved.
//

import AppKit
import SwiftUI

public class AppKitGlueManager: NSObject, AppKitBridging {
    var statisticsWindow: NSWindow!
    
    public required override init() {
        super.init()
    }
    
    public func showStatisticsWindow(forStatistics data: Data) {
        let viewModel = try? JSONDecoder().decode(StatisticsViewModel.self, from: data)
        print(type(of: viewModel))
        print(viewModel)
        
        if statisticsWindow == nil {
            statisticsWindow = NSWindow(
                contentRect: NSRect(x: 0, y: 0, width: 400, height: 400),
                styleMask: [.titled, .closable, .miniaturizable, .resizable, .fullSizeContentView],
                backing: .buffered, defer: false)
            statisticsWindow.title = "Statistics"
            statisticsWindow.center()
            statisticsWindow.setFrameAutosaveName("Statistics Window")
            statisticsWindow.delegate = self
//            statisticsWindow.contentViewController = controller
        }
        
        print(statisticsWindow)
        let windowController = NSWindowController(window: statisticsWindow)
        windowController.showWindow(self)
    }
}

extension AppKitGlueManager: NSWindowDelegate {
    public func windowWillClose(_ notification: Notification) {
        statisticsWindow = nil
    }
}
