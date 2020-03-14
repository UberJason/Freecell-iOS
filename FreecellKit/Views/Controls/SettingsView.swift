//
//  SettingsView.swift
//  FreecellKit
//
//  Created by Jason Ji on 3/12/20.
//  Copyright © 2020 Jason Ji. All rights reserved.
//

import SwiftUI

public struct SettingsView: View {
    public init() {}
    
    public var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Settings")) {
                    Text("Restart Game")
                    Text("New Game")
                    NavigationLink(destination: Text("Cool cool cool")) {
                        HStack {
                            Text("Control Scheme")
                            Spacer()
                            Text("Classic").foregroundColor(.freecellBackground)
                        }
                    }
                    
                }
                
                Section(header: Text("Statistics")) {
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
                    Button(action: {
                        print("Reset Statistics")
                    }) {
                        Text("Reset Statistics").foregroundColor(.red)
                    }
                }
            }
            .listStyle(GroupedListStyle())
            .environment(\.horizontalSizeClass, .regular)
            .navigationBarTitle("Freecell", displayMode: .inline)
        }.environment(\.horizontalSizeClass, .compact)
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
