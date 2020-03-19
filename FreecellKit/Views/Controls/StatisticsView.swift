//
//  StatisticsView.swift
//  FreecellKit
//
//  Created by Jason Ji on 3/13/20.
//  Copyright © 2020 Jason Ji. All rights reserved.
//

import SwiftUI

#if os(iOS)
class StatisticsModel: ObservableObject {
    let store = FreecellStore()
    lazy var allRecords = store.allRecords()
    lazy var formatter: NumberFormatter = {
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
        return formatter.string(from: NSNumber(value: Double(winsCount) / Double(totalGameCount)))!
    }
    
    init() {}
}

struct StatisticsView: View {
    @ObservedObject var model = StatisticsModel()
    
    var body: some View {
        Form {
            Section(header: Text("Win/Loss")) {
                CellRow(leading: Text("Games Won"), trailing: Text("\(model.winsCount)"))
                CellRow(leading: Text("Games Lost"), trailing: Text("\(model.lossCount)"))
                CellRow(leading: Text("Total"), trailing: Text("\(model.totalGameCount)"))
                CellRow(leading: Text("Win Percentage"), trailing: Text(model.winPercentage))
            }
            
            Section(header: Text("Streaks")) {
                CellRow(leading: Text("Current Streak"), trailing: Text("3 Wins"))
                CellRow(leading: Text("Longest Winning Streak"), trailing: Text("19"))
                CellRow(leading: Text("Longest Losing Streak"), trailing: Text("8"))
            }
            
            Button(action: {
                print("Reset Statistics")
            }) {
                CellRow(leading: Text("Reset Statistics"), trailing: Image(systemName: "trash.fill"))
                    .foregroundColor(.red)
            }
        }
        .navigationBarTitle("Statistics")
        .listStyle(GroupedListStyle())
        .environment(\.horizontalSizeClass, .regular)
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
