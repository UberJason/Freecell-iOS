//
//  SettingsView.swift
//  FreecellKit
//
//  Created by Jason Ji on 3/12/20.
//  Copyright © 2020 Jason Ji. All rights reserved.
//

import SwiftUI

#if os(iOS)

class ControlStyleStore: ObservableObject {
    @UserDefault(key: "controlStyle", defaultValue: .modern)
    var controlStyle: ControlStyle {
        didSet {
            objectWillChange.send()
            print("control style is now: \(controlStyle.rawValue)")
            NotificationCenter.default.post(name: .updateControlStyle, object: nil, userInfo: ["controlStyle": controlStyle.rawValue])
        }
    }
}

public struct SettingsView: View {
    @State var newGameWarning = false
    @State var restartGameWarning = false
    
    #warning("If/when SwiftUI 2.0 allows for formSheet presentation, rework to remove GameHostingController, present directly from BoardView, and bind controlStyle to BoardViewDriver.controlStyle directly.")
    @ObservedObject var store = ControlStyleStore()
    
    public init() {}
    
    public var body: some View {
        NavigationView {
            Form {
                Section(header: Text("This Game")) {
                    Button(action: {
                        self.restartGameWarning.toggle()
                    }) {
                        CellRow(leading: Text("Restart Game"), trailing: Image(systemName: "arrow.uturn.left"))
                            .foregroundColor(.freecellBackground)
                    }.alert(isPresented: $restartGameWarning) { restartGameAlert() }
                    Button(action: {
                        self.newGameWarning.toggle()
                    }) {
                        CellRow(leading: Text("New Game"), trailing: Image(systemName: "goforward.plus"))
                            .foregroundColor(.freecellBackground)
                    }.alert(isPresented: $newGameWarning) { newGameAlert() }
                }
                
                Section(header: Text("Settings")) {
                    NavigationLink(destination: SelectControlStyleView(controlStyle: $store.controlStyle)) {
                        CellRow(leading: Text("Control Scheme"), trailing: Text(store.controlStyle.rawValue).foregroundColor(.freecellBackground))
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
        .accentColor(.freecellBackground)
    }
    
    func restartGameAlert() -> Alert {
        let restart = ActionSheet.Button.destructive(Text("Restart Game")) {
            NotificationCenter.default.post(name: .restartGame, object: nil)
            NotificationCenter.default.post(name: .dismissMenu, object: nil)
        }
        
        return Alert(title: Text("Restart Game"), message: Text("Are you sure you want to restart this game?"), primaryButton: restart, secondaryButton: ActionSheet.Button.cancel())
    }
    
    func newGameAlert() -> Alert {
        let newGame = ActionSheet.Button.destructive(Text("New Game")) {
            NotificationCenter.default.post(name: .postLoss, object: nil)
            NotificationCenter.default.post(name: .newGame, object: nil)
            NotificationCenter.default.post(name: .dismissMenu, object: nil)
        }
        
        return Alert(title: Text("New Game"), message: Text("Are you sure you want to start a new game? The current game will be recorded as a loss."), primaryButton: newGame, secondaryButton: ActionSheet.Button.cancel())
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
