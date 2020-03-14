//
//  StatisticsView.swift
//  FreecellKit
//
//  Created by Jason Ji on 3/13/20.
//  Copyright © 2020 Jason Ji. All rights reserved.
//

import SwiftUI

struct StatisticsView: View {
    var body: some View {
        Form {
            Section(header: Text("Win/Loss")) {
                HStack {
                    Text("Games Won")
                    Spacer()
                    Text("109")
                }
                HStack {
                    Text("Games Lost")
                    Spacer()
                    Text("12")
                }
                HStack {
                    Text("Total")
                    Spacer()
                    Text("121")
                }
                HStack {
                    Text("Win Percentage")
                    Spacer()
                    Text("90%")
                }
            }
            
            Section(header: Text("Streaks")) {
                HStack {
                    Text("Current Streak")
                    Spacer()
                    Text("3 Wins")
                }
                HStack {
                    Text("Longest Winning Streak")
                    Spacer()
                    Text("19")
                }
                HStack {
                    Text("Longest Losing Streak")
                    Spacer()
                    Text("8")
                }
            }
            
            Button(action: {
                print("Reset Statistics")
            }) {
                Text("Reset Statistics").foregroundColor(.red)
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
