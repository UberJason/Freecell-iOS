//
//  EmojiBombView.swift
//  FreecellKit
//
//  Created by Jason Ji on 2/22/20.
//  Copyright © 2020 Jason Ji. All rights reserved.
//

import Combine
import SwiftUI

public class EmojiBombUIView: UIView {
    private lazy var animator = EmojiBombAnimator(container: self)
    private var cancellables = Set<AnyCancellable>()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        subscribeToAnimationNotification()
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        subscribeToAnimationNotification()
    }
    
    func subscribeToAnimationNotification() {
        NotificationCenter.default
            .publisher(for: .performBombAnimation)
            .sink { [weak self] _ in
                self?.animator.startAnimation()
            }
        .store(in: &cancellables)
    }
}

public struct EmojiBombView: UIViewRepresentable {
    public init() {}
    
    public func makeUIView(context: Context) -> EmojiBombUIView {
        let view = EmojiBombUIView(frame: .zero)
        view.backgroundColor = .clear
        return view
    }
    
    public func updateUIView(_ uiView: EmojiBombUIView, context: Context) {
        
    }
}

extension Notification.Name {
    static let performBombAnimation = Notification.Name("performBombAnimation")
}
