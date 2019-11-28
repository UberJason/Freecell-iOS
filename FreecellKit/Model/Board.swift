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
    
    public init(deck: Deck = Deck(shuffled: false)) {
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
        case _ as BoardView:
            selectedCard = nil
        default:
            break
        }
        
        print("Smallest outstanding rank: \(lowestOutstandingRank!)")
    }
    
    public func handleDoubleTap<T>(from item: T) {
        switch item {
        case let card as Card:
            do {
                try moveCardToAvailableFreecell(card)
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
                    try moveCardToAvailableFreecell(card)
                }
                else {
                    let location = self.location(containing: card)
                    try move(selected, to: location)
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
                try move(card, to: location)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func location(containing card: Card) -> CardLocation {
        let allLocations: [[CardLocation]] = [freecells, foundations, columns]
        
        guard let containingLocation = allLocations
            .flatMap({ $0 })
            .filter({ location in
                location.contains(card)
            })
            .first else { fatalError("Fatal error! Nobody seems to have the card: \(card.displayTitle)") }
        
        return containingLocation
    }
    
    /// Moves card to the given location. Assumes the card is in a valid location and has not yet been removed - do not call pop() prior to calling move(_:to:).
    /// - Parameters:
    ///   - card: Card to move to the given location.
    ///   - location: Location to receive the card.
    func move(_ card: Card, to location: CardLocation) throws {
        let containingLocation = self.location(containing: card)
        guard location.canReceive(card) else { throw FreecellError.invalidMove }
        
        if let card = containingLocation.pop() {
            try location.receive(card)
        }
        
        selectedCard = nil
        try autoUpdateFoundations()
    }
    
    func moveCardToAvailableFreecell(_ card: Card) throws {
        guard let availableFreeCell = nextAvailableFreecell else {
            throw FreecellError.invalidMove
        }
        
        try move(card, to: availableFreeCell)
    }
    
    func moveCardToAppropriateFoundation(_ card: Card) throws {
        let foundation = foundations.filter({ $0.suit == card.suit }).first!
        try move(card, to: foundation)
    }
    
    func autoUpdateFoundations() throws {
        let exposedCards = freecells.map({ $0.topItem }).compactMap { $0 } +
                                columns.map({ $0.topItem }).compactMap { $0 }
        
        for exposedCard in exposedCards {
            if canAutostack(exposedCard) {
                try moveCardToAppropriateFoundation(exposedCard)
                return try autoUpdateFoundations()
            }
        }
    }

    func canMoveSubstack(from fromColumn: Column, to toColumn: Column) -> Bool {
        guard let substack = fromColumn.validSubstack(),
            let bottomItem = substack.bottomItem else { return false }
        
        guard toColumn.canReceive(bottomItem) else { return false }
        
        let availableFreecellCount = freecells.filter({ !$0.isOccupied }).count
        return substack.stack.count <= availableFreecellCount + 1
    }
    
    #warning("If stack move is invalid, the board is left in a corrupt state. Add checks to ensure the move is valid.")
    func moveSubstack(from fromColumn: Column, to toColumn: Column) throws {
        guard let substack = fromColumn.validSubstack(),
            let card = fromColumn.topItem else { return }
        
        guard canMoveSubstack(from: fromColumn, to: toColumn) else { throw FreecellError.invalidMove }
        
        guard toColumn.canReceive(card) else { throw FreecellError.invalidMove }
        
        if substack.stack.count == 1 {
            try move(card, to: toColumn)
        }
        else {
            guard let currentAvailableFreeCell = nextAvailableFreecell else { throw FreecellError.invalidMove }
            
            try move(card, to: currentAvailableFreeCell)
            try moveSubstack(from: fromColumn, to: toColumn)
            
            guard let card = currentAvailableFreeCell.item else { fatalError("Something went wrong during moveSubstack(from:to:)") }
            
            try move(card, to: toColumn)
        }
    }
    
    #warning("TODO: Implement moveFullStack()")
}

extension Board {
  
    public var nextAvailableFreecell: FreeCell? {
        return freecells.filter({ !$0.isOccupied }).first
    }
    
    /// Return lowest outstanding card for a given suit. Returns nil only if the entire suit has moved up to the foundation.
    /// - Parameter suit: Suit to check lowest outstanding card value.
    func lowestOutstandingCard(for suit: Suit) -> Card? {
        let foundation = foundations.filter({ $0.suit == suit }).first!
        
        guard let topCard = foundation.topItem else { return Card(suit: suit, rank: .ace) }
        guard let nextHighest = topCard.rank.nextHighest else { return nil }
        
        return Card(suit: suit, rank: nextHighest)
    }
    
    var lowestOutstandingRank: Rank? {
        let topCards = foundations.map({ $0.topItem }).compactMap { $0 }
        
        // If any foundations did not have a top card, the lowest outstanding card is an ace.
        if topCards.count < 4 {
            return .ace
        }
        
        // If outstandingRanks contains nil, we can ignore - these would only be suits that are fully filled out and have nothing left on the board.
        let outstandingRanks = topCards.map({ $0.rank.nextHighest }).compactMap { $0 }
        
        return outstandingRanks.sorted().first
    }
    
    func canAutostack(_ card: Card) -> Bool {
        guard let lowestOutstandingRank = lowestOutstandingRank else { return true }
        
        let foundation = foundations.filter({ $0.suit == card.suit }).first!
        
        return foundation.canReceive(card) && card.rank.value - 1 <= lowestOutstandingRank.value
    }
}
