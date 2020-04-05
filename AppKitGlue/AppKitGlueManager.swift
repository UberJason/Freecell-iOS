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
        guard let viewModel = try? JSONDecoder().decode(StatisticsViewModel.self, from: data) else { return }
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
            statisticsWindow.contentViewController = NSHostingController<StatisticsView>(rootView: StatisticsView(viewModel: viewModel))
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

struct StatisticsView: View {
    let viewModel: StatisticsViewModel
    
    public var body: some View {
        Form {
            Section(header: Text("Win/Loss")) {
                CellRow(leading: Text("Games Won"), trailing: Text("\(viewModel.winsCount)"))
                CellRow(leading: Text("Games Lost"), trailing: Text("\(viewModel.lossCount)"))
                CellRow(leading: Text("Total"), trailing: Text("\(viewModel.totalGameCount)"))
                CellRow(leading: Text("Win Percentage"), trailing: Text(viewModel.winPercentage))
            }
            
            Section(header: Text("Streaks")) {
                CellRow(leading: Text("Current Streak"), trailing: Text(viewModel.currentStreak))
                CellRow(leading: Text("Longest Winning Streak"), trailing: Text(viewModel.longestWinningStreak))
                CellRow(leading: Text("Longest Losing Streak"), trailing: Text(viewModel.longestLosingStreak))
            }
        }
    }
}

struct CellRow<Leading: View, Trailing: View>: View {
    let leading: Leading
    let trailing: Trailing
    
    init(leading: Leading, trailing: Trailing) {
        self.leading = leading
        self.trailing = trailing
    }
    
    var body: some View {
        HStack {
            leading
            Spacer()
            trailing
        }
    }
}

struct CellRow_Previews: PreviewProvider {
    static var previews: some View {
        CellRow(leading: Text("Leading"), trailing: Text("Trailing"))
            .previewDevice("iPad mini")
            .previewLayout(.fixed(width: 500, height: 44))
    }
}
