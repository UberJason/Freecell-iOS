//
//  Board.swift
//  FreecellKit
//
//  Created by Jason Ji on 11/14/19.
//  Copyright © 2019 Jason Ji. All rights reserved.
//

import Foundation
import DeckKit
import Combine

enum SelectionState {
    case idle, selected(card: Card)
}

public class Board: ObservableObject {
    public var freecells: [FreeCell]
    public var foundations: [Foundation]
    public var columns: [Column]
    
    var selectionState: SelectionState {
        return selectedCard.map { .selected(card: $0) } ?? .idle
    }
    
    @Published public var selectedCard: Card?
    
    public init() {
        let deck = Deck(shuffled: false)
        
        freecells = (0...3).map { i in FreeCell(id: i) }
        foundations = [
            Foundation(id: 0, suit: .diamonds),
            Foundation(id: 1, suit: .clubs),
            Foundation(id: 2, suit: .hearts),
            Foundation(id: 3, suit: .spades)
        ]
        columns = (0...7).map { i in Column(id: i) }
        
        for i in 0 ..< Deck.maxCardCount {
            guard let card = deck.draw() else { fatalError("Deck empty during new game setup") }
            columns[i % columns.count].setupPush(card)
        }
    }
    
    public func handleTap<T>(from item: T) {
        switch item {
        case let card as Card:
            cardTapped(card)
            
        case let location as CardLocation:
            locationTapped(location)
            
        default:
            print("what is this")
        }
    }
    
    private func cardTapped(_ card: Card) {
        print("Board detected tap from: \(card.displayTitle)")
        selectedCard = (selectedCard != card) ? card : nil
        print("selection state: \(selectionState)")
    }
    
    private func locationTapped(_ location: CardLocation) {
        print("Board detected tap from somewhere: \(location)")
    }
}
