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

class GameHostingController: FreecellHostingController<ContentView> {
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
        guard presentedViewController == nil else { return }
//        NotificationCenter.default.post(name: .newGameRequested, object: nil)
        let alert = UIAlertController(title: "Test", message: "Are you sure you want to test - new game?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (_) in
            print("OK tapped")
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    @objc func postRestartGame() {
        print("postRestartGame")
        guard presentedViewController == nil else { return }
    //        NotificationCenter.default.post(name: .newGameRequested, object: nil)
        let alert = UIAlertController(title: "Test", message: "Are you sure you want to test - restart game?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (_) in
            print("OK tapped")
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}
