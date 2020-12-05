//
//  TappableView.swift
//  FreecellKit
//
//  Created by Jason Ji on 12/5/20.
//  Copyright © 2020 Jason Ji. All rights reserved.
//

import SwiftUI
import UIKit

@available(*, deprecated, message: "Workaround for Big Sur onTapGesture. Replace ASAP.")
struct TappableView: UIViewRepresentable {
    let onTap: () -> ()
    
    func makeUIView(context: Context) -> TapView {
        TapView {
            print("I was tapped from a UIKit workaround!")
            onTap()
        }
    }
    
    func updateUIView(_ uiView: TapView, context: Context) {
        
    }
}

class TapView: UIView {
    private let onTap: () -> ()
    
    init(onTap: @escaping () -> ()) {
        print("init TapView")
        self.onTap = onTap
        super.init(frame: .zero)
        
        addGestureRecognizer(
            UITapGestureRecognizer(target: self, action: #selector(tapped))
        )
    }
    
    @objc func tapped() {
        onTap()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) not implemented")
    }
}
