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

public class Board {
    public var freecells: [FreeCell]
    public var foundations: [Foundation]
    public var columns: [Column]
    
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
    
    
    /// Finds and attempts to perform a valid move using the selected card and the destination location.
    ///
    /// - Parameters:
    ///   - card: Current user selected card. Will be moved or part of the move, if a stack movement.
    ///   - toLocation: Destination to receive the card and/or stack.
    func performValidMove(from card: Card, to toLocation: CardLocation) throws {
        
        // Edge case: If user taps selected card twice, move card to available freecell.
        if toLocation.contains(card), toLocation is Column {
            try moveCardToAvailableFreecell(card)
            try autoUpdateFoundations()
            return
        }

        // If user attempts a column-to-column move, search for and attempt a stack movement.
        // In any other case, attempt a single-card move.
        let fromLocation = self.location(containing: card)
        
        switch(fromLocation, toLocation) {
        case (let fromColumn as Column, let toColumn as Column):
            try performValidStackMovement(from: fromColumn, to: toColumn)
        default:
            try move(card, to: toLocation)
            try autoUpdateFoundations()
        }
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
    
    func substackCapCard(forMovingFrom fromColumn: Column, to toColumn: Column) -> Card? {
        fatalError("Implement substackCapCard(forMovingFrom:to:)")
    }
    
    func moveSubstack(from fromColumn: Column, cappedBy capCard: Card, to toColumn: Column) throws {
        fatalError("Implement moveSubstack(from:cappedBy:to:)")
    }

    func canMoveSubstack(from fromColumn: Column, to toColumn: Column) -> Bool {
        guard let substack = fromColumn.largestValidSubstack(),
            let bottomItem = substack.bottomItem else { return false }
        
        guard toColumn.canReceive(bottomItem) else { return false }
        
        let availableFreecellCount = freecells.filter({ !$0.isOccupied }).count
        return substack.stack.count <= availableFreecellCount + 1
    }
    
    #warning("If stack move is invalid, the board is left in a corrupt state. Add checks to ensure the move is valid.")
    func moveSubstack(from fromColumn: Column, to toColumn: Column) throws {
        guard let substack = fromColumn.largestValidSubstack(),
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
    
    #warning("TODO: Implement canMoveFullStack() - for now, just calls canMoveSubstack()")
    func canMoveFullStack(from fromColumn: Column, to toColumn: Column) -> Bool {
        return canMoveSubstack(from: fromColumn, to: toColumn)
    }
    
    #warning("TODO: Implement moveFullStack() - for now, just performs moveSubstack()")
    func moveFullStack(from fromColumn: Column, to toColumn: Column) throws {
        try moveSubstack(from: fromColumn, to: toColumn)
    }
    
    #warning("Need to rethink moveSubstack(from:to:) to include indexes. Can't use substack objects because they will be copied out of the original Columns. Need another method on Column or CardStack that grabs validSubstack(from index:) instead. WIP - substackCapCard(forMovingFrom:to:) and moveSubstack(from:cappedBy:to:)")
    #warning("TODO: Implement performValidStackMovement")
    func performValidStackMovement(from fromColumn: Column, to toColumn: Column) throws {
        if let card = fromColumn.topItem {
            try move(card, to: toColumn)
        }
//        fatalError("Implement performValidStackMovement - recursively search for a valid stack that can move")
    }
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
