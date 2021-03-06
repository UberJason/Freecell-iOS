//
//  FreecellHostingController.swift
//  Freecell
//
//  Created by Jason Ji on 3/27/20.
//  Copyright © 2020 Jason Ji. All rights reserved.
//

import SwiftUI
import Combine
import FreecellKit

class FreecellHostingController<Content: View>: StatusBarHidingFirstResponderHostingController<Content> {
    var cancellables = Set<AnyCancellable>()
    
    override init(rootView: Content) {
        super.init(rootView: rootView)
        
        applyPreferredTheme()
        
        NotificationCenter.default
            .publisher(for: .preferredVisualThemeDidChange)
            .sink { [weak self] _ in
                self?.applyPreferredTheme()
            }
            .store(in: &cancellables)
    }
    
    override init?(coder aDecoder: NSCoder, rootView: Content) {
        super.init(coder: aDecoder, rootView: rootView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) not implemented")
    }
}

extension FreecellHostingController: VisualTheming {}
