//
//  GameHostingController.swift
//  Freecell
//
//  Created by Jason Ji on 3/13/20.
//  Copyright © 2020 Jason Ji. All rights reserved.
//

import Combine
import UIKit
import SwiftUI
import FreecellKit

class GameHostingController: StatusBarHidingFirstResponderHostingController<ContentView> {
    var cancellables = Set<AnyCancellable>()
    
    override init(rootView: ContentView) {
        super.init(rootView: rootView)
        
        NotificationCenter.default
            .publisher(for: .showMenu)
            .sink { [unowned self] _ in
                self.showMenu()
            }
            .store(in: &cancellables)
        
        NotificationCenter.default
            .publisher(for: .dismissMenu)
            .sink { [unowned self] _ in
                self.dismiss(animated: true, completion: nil)
            }
            .store(in: &cancellables)
        
        let store = FreecellStore()
        print("Records: \(store.allRecords().count)")
    }
    
    override init?(coder aDecoder: NSCoder, rootView: ContentView) {
        super.init(coder: aDecoder, rootView: rootView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) not implemented")
    }
    
    override var keyCommands: [UIKeyCommand]? {
        [
            UIKeyCommand(title: "New Game", action: #selector(postNewGame), input: "n", modifierFlags: .command),
            UIKeyCommand(title: "Restart Game", action: #selector(postRestartGame), input: "r", modifierFlags: [.command, .shift])
        ]
    }
    
    func showMenu() {
        print("show Menu")
        let settingsView = SettingsView()
        
        let hostingController = StatusBarHidingFirstResponderHostingController(rootView: settingsView)
        hostingController.modalPresentationStyle = .formSheet
        
        present(hostingController, animated: true, completion: nil)
        
    }
    
    @objc func postNewGame() {
        print("Post New Game")
        NotificationCenter.default.post(name: .newGameRequested, object: nil)
    }
    
    @objc func postRestartGame() {
        print("Post Restart Game")
        NotificationCenter.default.post(name: .restartGameRequested, object: nil)
    }
}
