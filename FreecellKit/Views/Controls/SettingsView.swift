//
//  SettingsView.swift
//  FreecellKit
//
//  Created by Jason Ji on 3/12/20.
//  Copyright © 2020 Jason Ji. All rights reserved.
//

import SwiftUI

#if os(iOS)
public struct SettingsView: View {
    @State var newGameWarning = false
    @State var restartGameWarning = false
    
    @State var controlStyle: ControlStyle = .modern
    
    public init() {
        #warning("TODO: read controlStyle from UserDefaults")
        controlStyle = .modern
    }
    
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
                    CellRow(leading: Text("Control Scheme"), trailing:
                        Picker(selection: $controlStyle, label: Text("Control Scheme")) {
                            ForEach(ControlStyle.allCases, id: \.self) { Text($0.rawValue) }
                        }
                        .pickerStyle(SegmentedPickerStyle())
                        .frame(maxWidth: 200)
                    )
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
            NotificationCenter.default.post(name: .recordLoss, object: nil)
            NotificationCenter.default.post(name: .newGame, object: nil)
            NotificationCenter.default.post(name: .dismissMenu, object: nil)
        }
        
        return Alert(title: Text("New Game"), message: Text("Are you sure you want to start a new game? The current game will be recorded as a loss."), primaryButton: newGame, secondaryButton: ActionSheet.Button.cancel())
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
#endif
