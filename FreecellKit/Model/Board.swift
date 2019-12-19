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

public struct Board {
    public var freecells: [FreeCell]
    public var foundations: [Foundation]
    public var columns: [Column]
    
    public lazy var movePublisher: AnyPublisher<MoveEvent, Never> = _movePublisher.eraseToAnyPublisher()
    private var _movePublisher = PassthroughSubject<MoveEvent, Never>()
    
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
    
    public init(freecells: [FreeCell], foundations: [Foundation], columns: [Column]) {
        self.freecells = freecells
        self.foundations = foundations
        self.columns = columns
    }
    
    public var copy: Board {
        return Board(freecells: freecells.map { $0.copy() as! FreeCell }, foundations: foundations.map { $0.copy() as! Foundation }, columns: columns.map { $0.copy() as! Column })
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
    
    func location(id: Int, locationType: CardLocation.Type) -> CardLocation {
        let allLocations: [[CardLocation]] = [freecells, foundations, columns]
        let allLocationsFlat = allLocations.flatMap({ $0 })
        guard let containingLocation = allLocationsFlat
            .filter({ location in
                location.id == id && type(of: location) == locationType
            })
            .first else { fatalError("Fatal error! This location doesn't exist: \(id), \(locationType)")}
        
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
        }
    }
    
    /// Moves card to the given location. Assumes the card is in a valid location and has not yet been removed - do not call pop() prior to calling move(_:to:).
    /// - Parameters:
    ///   - card: Card to move to the given location.
    ///   - location: Location to receive the card.
    ///   - deferringAutoUpdate: If false, the board will attempt to auto-update foundations after a successful move.
    ///    When in the middle of a stack movement, this value may be preferred to be true to avoid putting the board in an unexpected state.
    func move(_ card: Card, to location: CardLocation, deferringAutoUpdate: Bool = false) throws {
        let beforeBoard = self.copy
        
        guard location.canReceive(card) else { throw FreecellError.invalidMove }
        
        if let card = self.location(containing: card).pop() {
            try location.receive(card)
        }
        
        let afterBoard = self.copy
        
        _movePublisher.send(MoveEvent(card: card, beforeBoard: beforeBoard, afterBoard: afterBoard))
        
        if !deferringAutoUpdate {
            try autoUpdateFoundations()
        }
    }
    
    /// Convenience method to attempt to move card to the first available freecell. Throws invalidMove if all freecells are occupied.
    /// - Parameter card: Card to move to freecell.
    func moveCardToAvailableFreecell(_ card: Card) throws {
        guard let availableFreeCell = nextAvailableFreecell else {
            throw FreecellError.invalidMove
        }
        
        try move(card, to: availableFreeCell)
    }
    
    /// Convenience method to attempt to move card to the corresponding foundation (E.g. move a club to the Club foundation).
    /// - Parameter card: Card to attempt to move to the corresponding foundation.
    func moveCardToAppropriateFoundation(_ card: Card) throws {
        let foundation = foundations.filter({ $0.suit == card.suit }).first!
        try move(card, to: foundation)
    }
    
    /// Method to inspect the board and automatically move cards up to foundations recursively if possible and allowed.
    /// For example, if an Ace is uncovered after a move, and autoUpdateFoundations() is called, the Ace will be moved to its
    /// corresponding foundation.
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
    
    /// Returns the card, if any, at the bottom (cap) of the valid substack that may be moved from from fromColumn to toColumn.
    /// For example, if the intent is to move a stack from column [♠️K, ❤️9,♦️6, ♣️5, ❤️4] to column [♠️J, ♣️9, ♦️8, ♠️7],
    /// the valid substack that can be moved is [♦️6, ♣️5, ❤️4], and the cap card is ♦️6.
    /// 
    /// Note that this method does NOT consider whether the move is legal or not due to sufficient freecells or empty columns.
    /// It only considers valid stacking combinations and finds the card that would be at the bottom of the moving stack.
    /// - Parameters:
    ///   - fromColumn: Origin column for the substack move
    ///   - toColumn: Destination column for the substack move
    func capCard(forMovingFrom fromColumn: Column, to toColumn: Column) -> Card? {
        guard let largestValidSubstack = fromColumn.largestValidSubstack() else { return nil }
        var currentIndex = 0
        var currentCard = largestValidSubstack.item(at: currentIndex)
        
        while currentIndex < largestValidSubstack.items.count {
            if let card = currentCard, toColumn.canReceive(card) {
                return card
            }

            currentIndex += 1
            currentCard = largestValidSubstack.item(at: currentIndex)
        }
        
        return nil
    }

    func canMoveSubstack(from fromColumn: Column, to toColumn: Column) -> Bool {
        if toColumn.isEmpty && !fromColumn.isEmpty { return true }
        
        guard let capCard = capCard(forMovingFrom: fromColumn, to: toColumn),
            let substack = fromColumn.validSubstack(cappedBy: capCard) else { return false }
        
        guard toColumn.canReceive(capCard) else { return false }
        
        return substack.items.count <= maximumMoveableSubstackSize
    }
    
    func moveSubstack(from fromColumn: Column, to toColumn: Column) throws {
        guard let capCard = capCard(forMovingFrom: fromColumn, to: toColumn),
            let substack = fromColumn.validSubstack(cappedBy: capCard),
            let card = fromColumn.topItem else { return }
        
        guard canMoveSubstack(from: fromColumn, to: toColumn) else {
                throw FreecellError.invalidMove
        }

        if substack.items.count == 1 || availableFreecellCount == 0 {
            try move(card, to: toColumn, deferringAutoUpdate: true)
        }
        else {
            guard let currentAvailableFreeCell = nextAvailableFreecell else {
                throw FreecellError.invalidMove
            }
            
            try move(card, to: currentAvailableFreeCell, deferringAutoUpdate: true)
            try moveSubstack(from: fromColumn, to: toColumn)
            
            guard let card = currentAvailableFreeCell.item else { fatalError("Something went wrong during moveSubstack(from:to:)") }
            
            try move(card, to: toColumn, deferringAutoUpdate: true)
        }
    }

    // Edge case: Need to know if we are attempting a full stack movement to an empty column, i.e.
    // - Moving a stack to an empty column
    // - At least 1 other free column is available
    // - The stack we're trying to move is larger than could move using substack movement alone
    func isFullStackMoveToEmptyColumn(from fromColumn: Column, to toColumn: Column) -> Bool {
        guard let capCard = capCard(forMovingFrom: fromColumn, to: toColumn),
        let substack = fromColumn.validSubstack(cappedBy: capCard) else { return false }
        
        return toColumn.isEmpty && availableFreeColumnCount(excluding: toColumn) > 0 && substack.items.count > maximumMoveableSubstackSize
    }
    
    func canMoveFullStack(from fromColumn: Column, to toColumn: Column) -> Bool {
        if isFullStackMoveToEmptyColumn(from: fromColumn, to: toColumn) { return true }
        
        guard let capCard = capCard(forMovingFrom: fromColumn, to: toColumn),
            let substack = fromColumn.validSubstack(cappedBy: capCard) else { return false }
        
        guard toColumn.canReceive(capCard) else { return false }
        
        let availableFreeColumnCount = self.availableFreeColumnCount(excluding: toColumn)
        
        return substack.items.count <= (availableFreecellCount + 1)*(availableFreeColumnCount+1)
    }
    
    func moveFullStack(from fromColumn: Column, to toColumn: Column) throws {
        // Remember when counting other empty columns to not count toColumn if it's empty
        guard canMoveFullStack(from: fromColumn, to: toColumn) || canMoveSubstack(from: fromColumn, to: toColumn) else {
            throw FreecellError.invalidMove
        }
            
        if canMoveSubstack(from: fromColumn, to: toColumn) && !isFullStackMoveToEmptyColumn(from: fromColumn, to: toColumn) {
            try moveSubstack(from: fromColumn, to: toColumn)
        }
        else {
            guard let freeColumn = freeColumns(excluding: toColumn).first else { fatalError("Something went wrong during moveFullStack(from:to:)")}
            try moveSubstack(from: fromColumn, to: freeColumn)
            try moveFullStack(from: fromColumn, to: toColumn)
            try moveSubstack(from: freeColumn, to: toColumn)
        }
    }
    
    func performValidStackMovement(from fromColumn: Column, to toColumn: Column) throws {
        if canMoveFullStack(from: fromColumn, to: toColumn) {
            try moveFullStack(from: fromColumn, to: toColumn)
            try autoUpdateFoundations()
        }
        else if canMoveSubstack(from: fromColumn, to: toColumn) {
            try moveSubstack(from: fromColumn, to: toColumn)
            try autoUpdateFoundations()
        }
        else {
            try autoUpdateFoundations()
            throw FreecellError.invalidMove
        }
    }
}

extension Board {
    public var availableFreecellCount: Int {
        return freecells.filter({ !$0.isOccupied }).count
    }
    
    public var nextAvailableFreecell: FreeCell? {
        return freecells.filter({ !$0.isOccupied }).first
    }
    
    public var maximumMoveableSubstackSize: Int {
        return availableFreecellCount + 1
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
    
    func freeColumns(excluding excludedColumn: Column?) -> [Column] {
        return columns.filter { $0.isEmpty && $0.id != excludedColumn?.id }
    }
    
    public func availableFreeColumnCount(excluding excludedColumn: Column?) -> Int {
        return freeColumns(excluding: excludedColumn).count
    }
}

public struct MoveEvent: Equatable {
    public static func == (lhs: MoveEvent, rhs: MoveEvent) -> Bool {
        return lhs.id == rhs.id
    }
    
    // Create a unique identifier for a move, to compare it to other moves.
    let id = UUID()
    let card: Card
    let beforeBoard: Board
    let afterBoard: Board
}
