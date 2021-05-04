//
//  SettingsView.swift
//  FreecellKit
//
//  Created by Jason Ji on 3/12/20.
//  Copyright © 2020 Jason Ji. All rights reserved.
//

import SwiftUI

#if os(iOS)

public class SettingsStore: ObservableObject {
    public init() {}
    
    @UserDefault(key: "controlStyle", defaultValue: .default)
    public var controlStyle: ControlStyle {
        didSet {
            objectWillChange.send()
            try? NotificationCenter.default.post(.updateControlStyle, value: controlStyle)
        }
    }

    @UserDefault(key: UserDefaults.preferredVisualThemeKey, defaultValue: .system)
    public var preferredVisualTheme: VisualTheme {
        didSet {
            NotificationCenter.default.post(name: .preferredVisualThemeDidChange, object: nil)
        }
    }
    
    static var appVersion: String {
        let version = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? ""
        let build = Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as? String ?? ""
        
        return "\(version) (\(build))"
    }
}

public struct SettingsView: View, GameAlerting {
    @State var newGameWarning = false
    @State var restartGameWarning = false
    
    #warning("SwiftUI 2.0: if allowing for formSheet presentation, rework to remove GameHostingController, present directly from BoardView, and bind controlStyle to BoardViewDriver.controlStyle directly.")
    @ObservedObject var store = SettingsStore()
    
    public init() {}
    
    public var body: some View {
        DismissableModalView(title: "Menu") {
            VStack {
                Form {
                    Section(header: Text("This Game")) {
                        Button(action: {
                            self.restartGameWarning.toggle()
                        }) {
                            CellRow(leading: Text("Restart Game"), trailing: Image.restart)
                                .foregroundColor(.freecellTheme)
                        }.alert(isPresented: $restartGameWarning) { restartGameAlert() }
                        Button(action: {
                            self.newGameWarning.toggle()
                        }) {
                            CellRow(leading: Text("New Game"), trailing: Image.newGame)
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
                        }.accessibility(identifier: "Control Scheme")
                        NavigationLink(destination: StatisticsView()) {
                            Text("Statistics")
                        }
                    }
                    
                    Section {
                        NavigationLink(destination: HowToPlayView(instructions: GameInstructions().instructions)) {
                            Text("How To Play")
                        }
                    }
                }
                Text("Version \(SettingsStore.appVersion)")
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .padding()
            }
        }
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
