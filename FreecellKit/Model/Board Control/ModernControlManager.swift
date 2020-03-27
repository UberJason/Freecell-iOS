//
//  ModernControlManager.swift
//  FreecellKit
//
//  Created by Jason Ji on 3/15/20.
//  Copyright © 2020 Jason Ji. All rights reserved.
//

import DeckKit
import Foundation
import SwiftUI

public class ModernControlManager: ControlManager {
    weak var boardProvider: BoardProvider?
    public var dragGestureAvailable: Bool { return true }
    public var draggingStack: CardStack?
    private var cellPositions = [CellPosition]()
    
    init(boardProvider: BoardProvider) {
        self.boardProvider = boardProvider
    }
    
    public func itemTapped<T>(_ item: T) {
        guard let boardProvider = boardProvider,
            let card = item as? Card else { return }
  
        do {
            boardProvider.registerMove()
            try boardProvider.board.performValidDirectMove(from: card)
        } catch {
            boardProvider.rollbackFailedMove(with: error)
        }
    }
    
    public func scale(for card: Card) -> CGFloat {
        return 1.0
    }
    
    public func cardOverlayColor(for card: Card) -> Color {
        return .clear
    }
    
    public func dragStarted(from card: Card) {
        guard let boardProvider = boardProvider else { return }
        draggingStack = boardProvider.board.substack(cappedBy: card)
    }
    
    public func dragEnded(with translation: CGSize) {
        defer { self.draggingStack = nil }
        
        guard let boardProvider = boardProvider,
            let draggingStack = draggingStack,
            let baseCard = draggingStack.bottomItem else { return }
        
        // Find the absolute position of the base card of the dragging stack given the translation.
        let containingCell = boardProvider.board.cell(containing: baseCard)
        let baseCardPosition = position(for: baseCard, translatedBy: translation)
        
        // The target cell is the cell whose position is closest to the base card position.
        let targetCell = closestCell(to: baseCardPosition)
        
        guard targetCell.id != containingCell.id else { return }

        do {
            boardProvider.registerMove()
            try boardProvider.board.performDirectStackMovement(of: draggingStack, from: containingCell, to: targetCell)
        } catch {
            boardProvider.rollbackFailedMove(with: error)
        }
    }
    
    private func position(for card: Card, translatedBy translation: CGSize = .zero) -> CGPoint {
        guard let boardProvider = boardProvider else { return .zero }
        
        let containingCell = boardProvider.board.cell(containing: card)
        guard let containingCellPosition = cellPositions.filter({ $0.cellId == containingCell.id }).first?.position else { return .zero }
        
        var cardPosition = containingCellPosition
        if let column = containingCell as? Column {
            let stackOffset = boardProvider.stackOffset(for: card, orderIndex: column.orderIndex(for: card), spacing: boardProvider.cardSpacing(for: column))
            cardPosition = cardPosition.position(byAdding: stackOffset)
        }
        
        return cardPosition.position(byAdding: translation)
    }
    
    private func closestCell(to position: CGPoint) -> Cell {
        guard let boardProvider = boardProvider else { fatalError("No boardProvider") }
        let relativeDistances = cellPositions
            .map { CellDistance(cellId: $0.cellId, distance: $0.position.distance(from: position)) }
            .sorted { $0.distance < $1.distance }
        
        guard let closestCellId = relativeDistances.first?.cellId else { fatalError("No cell found") }
        return boardProvider.board.cell(for: closestCellId)
    }
    
    public func cardOffset(for card: Card, relativeTo bounds: CGRect, dragState: BoardView.DragState? = nil) -> CGSize {
        var dragOffset = CGSize.zero
        
        if case .active(let translation) = dragState, let draggingStack = draggingStack, draggingStack.items.contains(card) {
            dragOffset = translation
        }
        
        return CGSize(width: dragOffset.width, height: dragOffset.height)
    }
    
    public func zIndex(for card: Card) -> Double {
        guard let draggingStack = draggingStack else { return 0 }
        return draggingStack.contains(card) ? 1 : 0
    }
    
    public func storeCellPositions(_ anchors: [CellInfo], using geometry: GeometryProxy) {
        #warning("Fix storeCellPositions causing drag bugs.")
        #warning("Replace cellId: UUID with a nicer string like freecell-0 - makes it much easier to debug")
        print("storeCellPositions")
        // TODO:
        // When the app is first launched on iPad Pro 11, the first freecell has x-position = 70. When changing control schemes to classic and back to modern, it's now x-position = 170.
        // The x-position=70 seems quite wrong, there's probably 100pts of padding on the left side.
        // This is the cause of the drag bugs and should be investigated.
//        if cellPositions.isEmpty {
            cellPositions = anchors.map { CellPosition(cellId: $0.cellId, position: geometry[$0.bounds].center) }
//        }
    }
}
