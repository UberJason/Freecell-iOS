//
//  ControlManager.swift
//  FreecellKit
//
//  Created by Jason Ji on 3/15/20.
//  Copyright © 2020 Jason Ji. All rights reserved.
//

import DeckKit
import SwiftUI

protocol ControlManager {
    func itemTapped<T>(_ item: T)
    func scale(for card: Card) -> CGFloat
    func cardOverlayColor(for card: Card) -> Color
    func dragStarted(from card: Card)
    func dragEnded(with translation: CGSize)
    func cardOffset(for card: Card, relativeTo bounds: CGRect, dragState: BoardView.DragState?) -> CGSize
    func zIndex(for card: Card) -> Double
    func storeCellPositions(_ anchors: [CellInfo], using geometry: GeometryProxy)
    var dragGestureAvailable: Bool { get }
    var boardProvider: BoardProvider? { get set }
}

extension ControlManager {
    func cardOffset(for card: Card, relativeTo bounds: CGRect, dragState: BoardView.DragState? = nil) -> CGSize {
        return .zero
    }
    
    func dragStarted(from card: Card) {}
    
    func dragEnded(with translation: CGSize) {}
    
    func storeCellPositions(_ anchors: [CellInfo], using geometry: GeometryProxy) {}
}
