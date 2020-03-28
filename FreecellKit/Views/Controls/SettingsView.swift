//
//  SettingsView.swift
//  FreecellKit
//
//  Created by Jason Ji on 3/12/20.
//  Copyright © 2020 Jason Ji. All rights reserved.
//

import SwiftUI

#if os(iOS)

class SettingsStore: ObservableObject {
    @UserDefault(key: "controlStyle", defaultValue: .default)
    var controlStyle: ControlStyle {
        didSet {
            objectWillChange.send()
            try? NotificationCenter.default.post(.updateControlStyle, value: controlStyle)
        }
    }

    @UserDefault(key: UserDefaults.preferredVisualThemeKey, defaultValue: .system)
    var preferredVisualTheme: VisualTheme {
        didSet {
            NotificationCenter.default.post(name: .preferredVisualThemeDidChange, object: nil)
        }
    }
}

public struct SettingsView: View, GameAlerting {
    @State var newGameWarning = false
    @State var restartGameWarning = false
    
    #warning("If/when SwiftUI 2.0 allows for formSheet presentation, rework to remove GameHostingController, present directly from BoardView, and bind controlStyle to BoardViewDriver.controlStyle directly.")
    @ObservedObject var store = SettingsStore()
    
    public init() {}
    
    public var body: some View {
        NavigationView {
            Form {
                Section(header: Text("This Game")) {
                    Button(action: {
                        self.restartGameWarning.toggle()
                    }) {
                        CellRow(leading: Text("Restart Game"), trailing: Image(systemName: "arrow.uturn.left"))
                            .foregroundColor(.freecellTheme)
                    }.alert(isPresented: $restartGameWarning) { restartGameAlert() }
                    Button(action: {
                        self.newGameWarning.toggle()
                    }) {
                        CellRow(leading: Text("New Game"), trailing: Image(systemName: "goforward.plus"))
                            .foregroundColor(.freecellTheme)
                    }.alert(isPresented: $newGameWarning) { newGameAlert() }
                }
                
                Section(header: Text("Settings")) {
                    CellRow(leading: Text("Visual Theme"), trailing:
                        Picker("Visual Theme", selection: $store.preferredVisualTheme) {
                            ForEach(VisualTheme.allCases, id: \.self) { Text($0.title) }
                        }
                        .accentColor(.freecellTheme)
                        .pickerStyle(SegmentedPickerStyle())
                        .frame(maxWidth: 200)
                    )
                    NavigationLink(destination: SelectControlStyleView(controlStyle: $store.controlStyle)) {
                        CellRow(leading: Text("Control Scheme"), trailing: Text(store.controlStyle.rawValue).foregroundColor(.freecellTheme))
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
        }
        .accentColor(.freecellTheme)
    }

}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
            .environment(\.horizontalSizeClass, .compact)
            .previewLayout(.fixed(width: 520, height: 640))
    }
}
#endif
