//
//  StatisticsHostingController.swift
//  Freecell
//
//  Created by Jason Ji on 4/5/20.
//  Copyright © 2020 Jason Ji. All rights reserved.
//

import Combine
import UIKit
import SwiftUI
import FreecellKit

#if targetEnvironment(macCatalyst)
class StatisticsHostingController: FreecellHostingController<DismissableModalView<StatisticsView>> {
    override var keyCommands: [UIKeyCommand]? {
        [
            UIKeyCommand(title: "Escape", action: #selector(escPressed), input: UIKeyCommand.inputEscape)
        ]
    }
    
    @objc func escPressed() {
        NotificationCenter.default.post(name: .dismissMenu, object: nil)
    }
}
#endif
