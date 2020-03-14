//
//  StatisticsView.swift
//  FreecellKit
//
//  Created by Jason Ji on 3/13/20.
//  Copyright © 2020 Jason Ji. All rights reserved.
//

import SwiftUI

#if os(iOS)
struct StatisticsView: View {
    var body: some View {
        Form {
            Section(header: Text("Win/Loss")) {
                CellRow(leading: Text("Games Won"), trailing: Text("109"))
                CellRow(leading: Text("Games Lost"), trailing: Text("12"))
                CellRow(leading: Text("Total"), trailing: Text("121"))
                CellRow(leading: Text("Win Percentage"), trailing: Text("90%"))
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
    }
}
#endif
