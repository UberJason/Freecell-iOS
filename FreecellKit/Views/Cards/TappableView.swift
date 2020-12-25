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
        print("makeUIView - TapView")
        return TapView {
            print("I was tapped from a UIKit workaround!")
            onTap()
        }
    }
    
    func updateUIView(_ uiView: TapView, context: Context) {
        print("updateUIView")
        uiView.gestureRecognizers?.forEach { uiView.removeGestureRecognizer($0) }
        uiView.addGestureRecognizer(
            UITapGestureRecognizer(target: uiView, action: #selector(TapView.tapped))
        )
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
        print("tapped() from UITapGestureRecognizer")
        onTap()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) not implemented")
    }
}

public extension View {
    func itemTapped<T>(_ item: T, boardDriver: BoardViewDriver) -> some View {
//        overlay(
//            TappableView(onTap: {
//                boardDriver.itemTapped(item)
//            })
//        )
        
        overlay(
            Button(action: {
                boardDriver.itemTapped(item)
            }, label: {
                Rectangle().foregroundColor(.clear)
                    .contentShape(Rectangle())
            }).buttonStyle(PlainButtonStyle())
        )
        
        /* After workaround is fixed */
        /*
         onTapGesture {
             boardDriver.itemTapped(item)
         }
         */
    }
}
