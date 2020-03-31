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

class GameHostingController: FreecellHostingController<ContentView>, GameAlerting {
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
        let settingsView = SettingsView()
        
        let hostingController = FreecellHostingController(rootView: settingsView)
        hostingController.modalPresentationStyle = .formSheet
        
        present(hostingController, animated: true, completion: nil)
    }
    
    #warning("Present new game and restart game alerts the old fashioned way...")
    @objc func postNewGame() {
        print("postNewGame")
        #if targetEnvironment(macCatalyst)
        let alert = self.alert(for: .newGame)
        present(alert, animated: true, completion: nil)
        #else
        NotificationCenter.default.post(name: .newGameRequested, object: nil)
        #endif
    }
    
    @objc func postRestartGame() {
        print("postRestartGame")
        #if targetEnvironment(macCatalyst)
        let alert = self.alert(for: .restartGame)
        present(alert, animated: true, completion: nil)
        #else
        NotificationCenter.default.post(name: .restartGameRequested, object: nil)
        #endif
    }

}
