//
//  ClassicControlManager.swift
//  FreecellKit
//
//  Created by Jason Ji on 3/15/20.
//  Copyright © 2020 Jason Ji. All rights reserved.
//

import DeckKit
import Foundation
import SwiftUI

public class ClassicControlManager: ControlManager {
    enum SelectionState {
        case idle, selected(card: Card)
    }
    
    weak var boardProvider: BoardProvider?
    public var dragGestureAvailable: Bool { return false }
    var selectionState: SelectionState { selectedCard.map { .selected(card: $0) } ?? .idle }

    public var selectedCard: Card? {
        willSet {
            boardProvider?.performUpdate()
        }
    }
        
    init(boardProvider: BoardProvider) {
        self.boardProvider = boardProvider
    }
    
    public func itemTapped<T>(_ item: T) {
        guard let board = boardProvider?.board else { return }
        switch item {
        case let card as Card:
            handleTap(in: board.cell(containing: card))
        case let location as Cell:
            handleTap(in: board.cell(for: location.id))
        case _ as BoardView:
            selectedCard = nil
        default:
            break
        }
    }
    
    private func handleTap(in location: Cell) {
        guard let boardProvider = boardProvider else { return }
        switch selectionState {
        case .idle:
            selectedCard = location.selectableCard()
        case .selected(let card):
            do {
                boardProvider.registerMove()
                try boardProvider.board.performValidMove(from: card, to: location)
                selectedCard = nil
            } catch {
                boardProvider.rollbackFailedMove(with: error)
                selectedCard = nil
            }
        }
    }
    
    public func scale(for card: Card) -> CGFloat {
        return card == selectedCard ? 1.05 : 1.0
    }
    
    public func cardOverlayColor(for card: Card) -> Color {
        return selectedCard == card ? .yellow : .clear
    }
    
    public func zIndex(for card: Card) -> Double {
        return 0
    }
}
