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
    
    /// Finds and attempts to perform a valid direct move from the provided card.
    /// - Parameter card: Card tapped by the user.
    func performValidDirectMove(from card: Card) throws {
        guard let tappedStack = substack(cappedBy: card),
            let validDestination = findValidDestination(for: tappedStack)
        else { throw FreecellError.noValidMoveAvailable }
        
        let containingCell = cell(containing: card)
        try performDirectStackMovement(of: tappedStack, from: containingCell, to: validDestination)
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
    
    /// Searches for a valid destination to move the CardStack.
    /// - Parameter stack: Card stack looking for a home.
    func findValidDestination(for stack: CardStack) -> Cell? {
        //***********************************************//
        // Future improvements to algorithm:
        // - If origin is freecell, prefer an empty column to a freecell.
        //***********************************************//
        
        let validDestinationColumns = columns.filter { canMoveFullStack(stack, to: $0) }
        
        // Edge case: if both freecells and empty columns are available, and the stack only has 1 card,
        // perfer a non-empty column first, then freecells.
        if validDestinationColumns.count > 0, let availableFreecell = nextAvailableFreecell, stack.items.count == 1 {
            return validDestinationColumns.filter({ $0.items.count > 0 }).first ?? availableFreecell
        }
        
        // Edge case: if multiple open columns are available, prefer a non-empty column.
        if validDestinationColumns.count > 1,
            let nonEmptyDestinationColumn = validDestinationColumns.filter({$0.items.count > 0 }).first {
            return nonEmptyDestinationColumn
        }
        // First preference: if there's a valid column available, prefer it.
        else if let column = validDestinationColumns.first {
            return column
        }
        
        // Second preference: freecell available and stack is 1 card.
        guard stack.items.count == 1, let card = stack.bottomItem else { return nil }
        if let freecell = nextAvailableFreecell {
            return freecell
        }
        
        // Last option: only if all freecells are taken, consider a foundation move.
        let foundation = self.foundation(for: card.suit)
        if foundation.canReceive(card) {
            return foundation
        }
        
        return nil
    }
    
    /// Find and attempt the direct stack movement of the stack to the destination.
    /// If the destination is FreeCell or Foundation, the move only succeeds if the stack is 1 card.
    /// Otherwise, attempt a direct stack movement to the destination column if valid.
    /// - Parameters:
    ///   - stack: Stack to move.
    ///   - origin: Origin cell that the stack currently resides in.
    ///   - destination: Destination cell to attempt the movement of the card stack.
    func performDirectStackMovement(of stack: CardStack, from origin: Cell, to destination: Cell) throws {
        switch destination {
        case is FreeCell, is Foundation:
            guard let card = stack.topItem,
                stack.items.count == 1 && destination.canReceive(card)
            else { throw FreecellError.invalidMove }
            
            try move(card, to: destination)
        case let column as Column:
            try moveDirectStack(stack, from: origin, to: column)
        default: throw FreecellError.invalidMove
        }
    }
    
    func substack(cappedBy capCard: Card) -> CardStack? {
        let origin = cell(containing: capCard)
        
        switch origin {
        case let column as Column:
            if let substack = column.validSubstack(cappedBy: capCard) {
                return substack
            }
        case is FreeCell:
            let substack = CardStack(cards: [capCard])
            return substack
        default:
            break
        }
        
        return nil
    }
}

extension Board {
    var availableFreecellCount: Int {
        return freecells.filter({ !$0.isOccupied }).count
    }
    
    var nextAvailableFreecell: FreeCell? {
        return freecells.filter({ !$0.isOccupied }).first
    }
    
    var maximumMoveableSubstackSize: Int {
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
    
    func availableFreeColumnCount(excluding excludedColumn: Column?) -> Int {
        return freeColumns(excluding: excludedColumn).count
    }
    
    func foundation(for suit: Suit) -> Foundation {
        guard let foundation = foundations.filter({ $0.suit == suit }).first else { fatalError("Couldn't find a Foundation for the suit, which is impossible") }
        
        return foundation
    }
}
