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
                Section(header: Text("This Game")) {
                    Button(action: {}) {
                        HStack {
                            Text("Restart Game")
                            Spacer()
                            Image(systemName: "arrow.uturn.left")
                        }.foregroundColor(.freecellBackground)
                    }
                    Button(action: {}) {
                        HStack {
                            Text("New Game")
                            Spacer()
                            Image(systemName: "goforward.plus")
                        }.foregroundColor(.freecellBackground)
                    }
                }
                
                Section(header: Text("Settings")) {
                    NavigationLink(destination: Text("Cool cool cool")) {
                        HStack {
                            Text("Control Scheme")
                            Spacer()
                            Text("Classic").foregroundColor(.freecellBackground)
                        }
                    }
                    NavigationLink(destination: StatisticsView()) {
                        Text("Statistics")
                    }
                }
            }
            .listStyle(GroupedListStyle())
            .environment(\.horizontalSizeClass, .regular)
            .navigationBarTitle("Menu", displayMode: .inline)
            .navigationBarItems(trailing:
                Button(action: {
                    NotificationCenter.default.post(name: .dismissMenu, object: nil)
                }) {
                    Text("Done").fontWeight(.bold)
                }
            )
                .background(Color(UIColor.systemGroupedBackground))
        }.environment(\.horizontalSizeClass, .compact)
            .accentColor(.freecellBackground)
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
