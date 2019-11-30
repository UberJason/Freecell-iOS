//
//  BoardDriver.swift
//  FreecellKit
//
//  Created by Jason Ji on 11/30/19.
//  Copyright © 2019 Jason Ji. All rights reserved.
//

import Foundation
import DeckKit

enum SelectionState {
    case idle, selected(card: Card)
}

public class BoardDriver: ObservableObject {
    public var board = Board(deck: Deck(shuffled: true))
    
    public var freecells: [FreeCell] { return board.freecells }
    public var foundations: [Foundation] { return board.foundations }
    public var columns: [Column] { return board.columns }
    
    var selectionState: SelectionState {
        return selectedCard.map { .selected(card: $0) } ?? .idle
    }
    
    @Published public var selectedCard: Card?
    
    public init() {
        
    }
    
    public func handleTap<T>(from item: T) {
        switch item {
        case let card as Card:
            cardTapped(card)
        case let location as CardLocation:
            locationTapped(location)
        case _ as BoardView:
            selectedCard = nil
        default:
            break
        }
        
    }
    
    public func handleDoubleTap<T>(from item: T) {
        switch item {
        case let card as Card:
            do {
                try board.moveCardToAvailableFreecell(card)
            } catch {
                print(error.localizedDescription)
            }
        default: break
        }
    }
    
    #warning("If selectedCard isn't the top card, show valid stack or do nothing?")
    private func cardTapped(_ card: Card) {
        do {
            switch selectionState {
            case .idle:
                selectedCard = card
            case .selected(let selected):
                if card == selected {
                    try board.moveCardToAvailableFreecell(card)
                    selectedCard = nil
                }
                else {
                    let location = board.location(containing: card)
                    try board.move(selected, to: location)
                    selectedCard = nil
                }
            }
        } catch {
            #warning("TODO: On failure, display an alert or play a sound or something")
            print(error.localizedDescription)
        }
    }
    
    private func locationTapped(_ location: CardLocation) {
        switch selectionState {
        case .idle:
            break
        case .selected(let card):
            do {
                try board.move(card, to: location)
                selectedCard = nil
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}
