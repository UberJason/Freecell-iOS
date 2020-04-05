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
    weak var game: Game?
    #if targetEnvironment(macCatalyst)
    let transitionDelegate = DimmingPresentationTransitioningDelegate(params: DimmingPresentationParams(duration: 0.3, maxDimmedAlpha: 0.5, presentedCornerRadius: 17.0, contentWidth: 400, contentHeight: 600, bottomInset: 0, viewsToHide: [], bottomInsetRespectsSafeArea: false))
    #endif
    
    convenience init(game: Game?, rootView: ContentView) {
        self.init(rootView: rootView)
        self.game = game
    }
    
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
            UIKeyCommand(title: "Restart Game", action: #selector(postRestartGame), input: "r", modifierFlags: [.command, .shift]),
            UIKeyCommand(title: "Undo", action: #selector(undoPressed), input: "z", modifierFlags: .command)
        ]
    }
    
    func showMenu() {
        let settingsView = SettingsView()
        
        let hostingController = FreecellHostingController(rootView: settingsView)
        hostingController.modalPresentationStyle = .formSheet
        
        present(hostingController, animated: true, completion: nil)
    }
    
    #warning("SwiftUI 2.0: Remove Mac Catalyst-specific code paths and resume allowing GameView to handle alerts")
    @objc func postNewGame() {
        #if targetEnvironment(macCatalyst)
        if game?.gameState == .won {
            NotificationCenter.default.post(name: .newGame, object: nil)
        }
        else {
            let alert = self.alert(for: .newGame)
            present(alert, animated: true, completion: nil)
        }
        #else
        NotificationCenter.default.post(name: .newGameRequested, object: nil)
        #endif
    }
    
    @objc func postRestartGame() {
        #if targetEnvironment(macCatalyst)
        guard game?.gameState != .won else { return }
        let alert = self.alert(for: .restartGame)
        present(alert, animated: true, completion: nil)
        #else
        NotificationCenter.default.post(name: .restartGameRequested, object: nil)
        #endif
    }
    
    @objc func undoPressed() {
        game?.undo()
    }
}

// MARK: - Hacks for Catalyst -

#if targetEnvironment(macCatalyst)
extension GameHostingController {
    func presentStatisticsView() {
        if let _ = presentedViewController { return }
        
        let statisticsView = StatisticsView()
        let modalView = DismissableModalView(title: "Statistics", content: statisticsView)
        let hostingController = FreecellHostingController(rootView: modalView)
        hostingController.view.clipsToBounds = true
        hostingController.modalPresentationStyle = .formSheet
//        hostingController.transitioningDelegate = transitionDelegate
        present(hostingController, animated: true, completion: nil)
        
    }
}

#warning("SwiftUI 2.0: remove alert(for:) if bugs around alert and timer are fixed")
extension GameAlerting {
    public func alert(for type: Game.AlertType) -> UIAlertController {
        let title: String
        let message: String
        let perform: () -> ()
        
        switch type {
        case .newGame:
            title = "New Game"
            message = "Are you sure you want to start a new game? The current game will be recorded as a loss."
            perform = {
                NotificationCenter.default.post(name: .postLoss, object: nil)
                NotificationCenter.default.post(name: .newGame, object: nil)
            }
        case .restartGame:
            title = "Restart Game"
            message = "Are you sure you want to restart this game?"
            perform = {
                NotificationCenter.default.post(name: .restartGame, object: nil)
            }
        }
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: title, style: .destructive, handler: { _ in
            perform()
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        return alert
    }
}
#endif
