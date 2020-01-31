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
        freecells = (0...3).map { _ in FreeCell() }
        foundations = [
            Foundation(suit: .diamonds),
            Foundation(suit: .clubs),
            Foundation(suit: .hearts),
            Foundation(suit: .spades)
        ]
        columns = (0...7).map { i in Column() }
        
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
    
    func cell(containing card: Card) -> Cell {
        let allCells: [[Cell]] = [freecells, foundations, columns]
        
        guard let cell = allCells
            .flatMap({ $0 })
            .filter({
                $0.contains(card)
            })
            .first else { fatalError("Fatal error! Nobody seems to have the card: \(card.displayTitle)") }
        
        return cell
    }
    
    func cell(for id: UUID) -> Cell {
        let allCells: [[Cell]] = [freecells, foundations, columns]
        let allCellsFlat = allCells.flatMap({ $0 })
        guard let cell = allCellsFlat
            .filter({ location in
                location.id == id
            })
            .first else { fatalError("Fatal error! This location doesn't exist: \(id)") }
        
        return cell
    }
    
    /// Finds and attempts to perform a valid move using the selected card and the destination location.
    ///
    /// - Parameters:
    ///   - card: Current user selected card. Will be moved or part of the move, if a stack movement.
    ///   - toLocation: Destination to receive the card and/or stack.
    func performValidMove(from card: Card, to toLocation: Cell) throws {
        
        // Edge case: If user taps selected card twice, move card to available freecell.
        if toLocation.contains(card), toLocation is Column {
            try moveCardToAvailableFreecell(card)
            return
        }

        // If user attempts a column-to-column move, search for and attempt a stack movement.
        // In any other case, attempt a single-card move.
        let fromLocation = self.cell(containing: card)
        
        switch(fromLocation, toLocation) {
        case (let fromColumn as Column, let toColumn as Column):
            try performValidStackMovement(from: fromColumn, to: toColumn)
        default:
            try move(card, to: toLocation)
        }
    }
    
    /// The single call site for mutating the board. move(_:to:) and moveDirectStack(_:from:to:) both call into this method. This method takes a snapshot of the board before and after the update, and publishes out a move event with the change.
    /// - Parameters:
    ///   - update: A synchronous (non-escaping) closure that performs the board update.
    ///   - deferringAutoUpdate: If false, the board will attempt to auto-update foundations after a successful move.
    ///    When in the middle of a stack movement, this value may be preferred to be true to avoid putting the board in an unexpected state.
    private func _performBoardUpdate(_ update: () throws -> (), deferringAutoUpdate: Bool = false) throws {
        let beforeBoard = self.copy
        try update()
        let afterBoard = self.copy
        
        _movePublisher.send(MoveEvent(beforeBoard: beforeBoard, afterBoard: afterBoard))
        
        if !deferringAutoUpdate {
            try autoUpdateFoundations()
        }
    }
    
    /// Moves card to the given location. Assumes the card is in a valid location and has not yet been removed - do not call pop() prior to calling move(_:to:).
    /// - Parameters:
    ///   - card: Card to move to the given location.
    ///   - location: Location to receive the card.
    ///   - deferringAutoUpdate: If false, the board will attempt to auto-update foundations after a successful move.
    ///    When in the middle of a stack movement, this value may be preferred to be true to avoid putting the board in an unexpected state.
    func move(_ card: Card, to location: Cell, deferringAutoUpdate: Bool = false) throws {
        try _performBoardUpdate({
            guard location.canReceive(card) else { throw FreecellError.invalidMove }
            
            if let card = self.cell(containing: card).pop() {
                try location.receive(card)
            }
        }, deferringAutoUpdate: deferringAutoUpdate)
    }
    
    /// Moves the card stack from its origin to the given column. Assumes the stack has not yet been detached from its origin - do not call detachStack(cappedBy:) prior to calling moveDirectStack(_:from:to:).
    /// - Parameters:
    ///   - stack: Stack to move to the new column.
    ///   - origin: Origin of the stack.
    ///   - column: Destination column for the stack move.
    ///   - deferringAutoUpdate: If false, the board will attempt to auto-update foundations after a successful move.
    ///    When in the middle of a stack movement, this value may be preferred to be true to avoid putting the board in an unexpected state.
    func moveDirectStack(_ stack: CardStack, from origin: Cell, to column: Column, deferringAutoUpdate: Bool = false) throws {
        try _performBoardUpdate({
            guard canMoveFullStack(stack, to: column), let capCard = stack.bottomItem else {
                throw FreecellError.invalidMove
            }

            try origin.detachStack(cappedBy: capCard)
            try column.appendStack(stack)
            
        }, deferringAutoUpdate: deferringAutoUpdate)
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
    
    func canMoveSubstack(_ substack: CardStack, to toColumn: Column) -> Bool {
        guard let capCard = substack.bottomItem,
            toColumn.canReceive(capCard) else { return false }
        
        return substack.items.count <= maximumMoveableSubstackSize
    }
    
    func canMoveSubstack(from fromColumn: Column, to toColumn: Column) -> Bool {
        if toColumn.isEmpty && !fromColumn.isEmpty { return true }
        
        guard let capCard = capCard(forMovingFrom: fromColumn, to: toColumn),
            let substack = fromColumn.validSubstack(cappedBy: capCard) else { return false }
        
        return canMoveSubstack(substack, to: toColumn)
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
        
        return toColumn.isEmpty && availableFreeColumnCount(excluding: toColumn) > 0 && !canMoveSubstack(substack, to: toColumn)
    }
    
    func canMoveFullStack(_ substack: CardStack, to toColumn: Column) -> Bool {
        guard let capCard = substack.bottomItem,
            toColumn.canReceive(capCard) else { return false }
        
        let availableFreeColumnCount = self.availableFreeColumnCount(excluding: toColumn)
        
        return substack.items.count <= (availableFreecellCount + 1)*(availableFreeColumnCount+1)
    }
    
    func canMoveFullStack(from fromColumn: Column, to toColumn: Column) -> Bool {
        if isFullStackMoveToEmptyColumn(from: fromColumn, to: toColumn) { return true }
        
        guard let capCard = capCard(forMovingFrom: fromColumn, to: toColumn),
            let substack = fromColumn.validSubstack(cappedBy: capCard) else { return false }
        
        return canMoveFullStack(substack, to: toColumn)
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
    
    #warning("TODO: write moveDirectStack(_:to:)")
    func performDirectStackMovement(of stack: CardStack, from origin: Cell, to cell: Cell) throws {
        // If cell is freecell, foundation: accept only if stack.count == 1 and canReceive(card)
        // If cell is column:
        //   - check if movement is valid (canMoveFullStack might need to be refactored)
        //   - if so, detach stack from its containing location and attach stack to new location
        //        - write detachStack(cappedBy:) and appendStack(_:) methods with proper validation
        // Afteward, try autoUpdateFoundations()
        
        switch cell {
        case is FreeCell, is Foundation:
            guard let card = stack.topItem,
                stack.items.count == 1 && cell.canReceive(card)
            else { throw FreecellError.invalidMove }
            
            try move(card, to: cell)
        case let column as Column:
            try moveDirectStack(stack, from: origin, to: column)
        default: throw FreecellError.invalidMove
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
    let beforeBoard: Board
    let afterBoard: Board
}
