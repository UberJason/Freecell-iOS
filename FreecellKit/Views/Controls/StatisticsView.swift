//
//  StatisticsView.swift
//  FreecellKit
//
//  Created by Jason Ji on 3/13/20.
//  Copyright © 2020 Jason Ji. All rights reserved.
//

import SwiftUI

struct Streak {
    let type: GameResult
    var count = 0
    var title: String {
        let plural = (count == 1) ? "" : type.plural
        return "\(count) \(type.rawValue.capitalized)\(plural)"
    }
}

#if os(iOS)
class StatisticsModel: ObservableObject {
    private let store = FreecellStore()
    
    private var allRecords: [GameRecord] {
        didSet {
            updateStreaks()
        }
    }
    private lazy var formatter: NumberFormatter = {
        let f = NumberFormatter()
        f.numberStyle = .percent
        return f
    }()
    
    var winsCount: Int {
        allRecords
            .filter { $0.result == .win }
            .count
    }
    
    var lossCount: Int {
        allRecords
            .filter { $0.result == .loss }
            .count
    }
    
    var totalGameCount: Int {
        allRecords.count
    }
    
    var winPercentage: String {
        guard totalGameCount > 0 else { return "--" }
        return formatter.string(from: NSNumber(value: Double(winsCount) / Double(totalGameCount)))!
    }
    
    var longestWinningStreak = Streak(type: .win)
    var longestLosingStreak = Streak(type: .loss)
    var currentStreak = Streak(type: .win)
    
    init() {
        allRecords = store.allRecords()
        updateStreaks()
    }
    
    func resetStatistics() {
        store.resetAllRecords()
        allRecords = store.allRecords()
        objectWillChange.send()
    }
    
    func updateStreaks() {
        let (winning, losing, current) = type(of: self).computeStreaks(for: allRecords)
        longestWinningStreak = winning
        longestLosingStreak = losing
        currentStreak = current
    }
    
    static func computeStreaks(for records: [GameRecord]) -> (winning: Streak, losing: Streak, current: Streak) {
        var longestLosingStreak = Streak(type: .loss)
        var longestWinningStreak = Streak(type: .win)
        var currentStreak = longestWinningStreak
        
        for record in records {
            if record.result == currentStreak.type {
                currentStreak.count += 1
            }
            else {
                currentStreak = Streak(type: record.result, count: 1)
            }
            
            switch currentStreak.type {
            case .win:
                longestWinningStreak = (currentStreak.count > longestWinningStreak.count) ? currentStreak : longestWinningStreak
            case .loss:
                longestLosingStreak = (currentStreak.count > longestLosingStreak.count) ? currentStreak : longestLosingStreak
            }
        }
        
        return (winning: longestWinningStreak, losing: longestLosingStreak, current: currentStreak)
    }
}

struct StatisticsView: View {
    @ObservedObject var model = StatisticsModel()
    @State var resetStatisticsAlertShowing = false
    
    var body: some View {
        Form {
            Section(header: Text("Win/Loss")) {
                CellRow(leading: Text("Games Won"), trailing: Text("\(model.winsCount)"))
                CellRow(leading: Text("Games Lost"), trailing: Text("\(model.lossCount)"))
                CellRow(leading: Text("Total"), trailing: Text("\(model.totalGameCount)"))
                CellRow(leading: Text("Win Percentage"), trailing: Text(model.winPercentage))
            }
            
            Section(header: Text("Streaks")) {
                CellRow(leading: Text("Current Streak"), trailing: Text(model.currentStreak.title))
                CellRow(leading: Text("Longest Winning Streak"), trailing: Text(model.longestWinningStreak.title))
                CellRow(leading: Text("Longest Losing Streak"), trailing: Text(model.longestLosingStreak.title))
            }
            
            Button(action: {
                self.resetStatisticsAlertShowing.toggle()
            }) {
                CellRow(leading: Text("Reset Statistics"), trailing: Image(systemName: "trash.fill"))
                    .foregroundColor(.red)
            }.alert(isPresented: $resetStatisticsAlertShowing) {
                resetStatisticsAlert()
            }
        }
        .navigationBarTitle("Statistics")
        .listStyle(GroupedListStyle())
        .environment(\.horizontalSizeClass, .regular)
    }
    
    func resetStatisticsAlert() -> Alert {
        let restart = ActionSheet.Button.destructive(Text("Reset")) {
            self.model.resetStatistics()
        }
        
        return Alert(title: Text("Reset Statistics"), message: Text("Are you sure you want to reset statistics? All data about wins, losses, and streaks will be reset."), primaryButton: restart, secondaryButton: ActionSheet.Button.cancel())
    }
}

struct StatisticsView_Previews: PreviewProvider {
    static var previews: some View {
        StatisticsView()
            .environment(\.horizontalSizeClass, .compact)
            .previewLayout(.fixed(width: 520, height: 640))
    }
}
#endif
