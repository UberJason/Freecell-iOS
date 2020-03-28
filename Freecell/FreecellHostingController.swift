//
//  FreecellHostingController.swift
//  Freecell
//
//  Created by Jason Ji on 3/27/20.
//  Copyright © 2020 Jason Ji. All rights reserved.
//

import Combine
import FreecellKit

class FreecellHostingController: StatusBarHidingFirstResponderHostingController<ContentView> {
    var cancellables = Set<AnyCancellable>()
    
    override init(rootView: ContentView) {
        super.init(rootView: rootView)
        
        applyPreferredTheme()
        
        NotificationCenter.default
            .publisher(for: .preferredVisualThemeDidChange)
            .sink { [weak self] _ in
                self?.applyPreferredTheme()
            }
            .store(in: &cancellables)
    }
    
    override init?(coder aDecoder: NSCoder, rootView: ContentView) {
        super.init(coder: aDecoder, rootView: rootView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) not implemented")
    }
}

extension FreecellHostingController: VisualTheming {}
