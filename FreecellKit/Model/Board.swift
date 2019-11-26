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

    #warning("TODO: double taps/clicks")
    public func handleTap<T>(from item: T) {
        switch item {
        case let card as Card:
            cardTapped(card)
            
        case let location as CardLocation:
            locationTapped(location)
            
        case _ as BoardView:
            selectedCard = nil
            
        default:
            print("what is this")
        }
        
        print("Smallest outstanding red: \(lowestOutstandingRedRank!)")
        print("Smallest outstanding black: \(lowestOutstandingBlackRank!)")
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
    #warning("TODO: After successful card move, survey the board and auto-move cards to Foundation as necessary")
    private func cardTapped(_ card: Card) {
        switch selectionState {
        case .idle:
            selectedCard = card
        case .selected(let selected):
            if card == selected {
                do {
                    try moveCardToAvailableFreecell(card)
                } catch {
                    print(error.localizedDescription)
                }
            }
            else {
                let location = self.location(containing: card)
                do {
                    try move(selected, to: location)
                } catch {
                    #warning("TODO: On failure, display an alert or play a sound or something")
                    print(error.localizedDescription)
                }
            }
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
    
    func move(_ card: Card, to location: CardLocation) throws {
        let containingLocation = self.location(containing: card)
        guard location.canReceive(card) else { throw FreecellError.invalidMove }
        
        if let card = containingLocation.pop() {
            try location.receive(card)
        }
        
        selectedCard = nil
        autoUpdateFoundations()
    }
    
    func moveCardToAvailableFreecell(_ card: Card) throws {
        guard let availableFreeCell = freecells.filter({ freecell in freecell.canReceive(card) }).first else {
            throw FreecellError.invalidMove
        }
        
        try move(card, to: availableFreeCell)
    }
    
    func moveCardToAppropriateFoundation(_ card: Card) throws {
        let foundation = foundations.filter({ $0.suit == card.suit }).first!
        try move(card, to: foundation)
    }
    
    func autoUpdateFoundations() {
        let exposedCards = freecells.map({ $0.topItem }).compactMap { $0 } +
                                columns.map({ $0.topItem }).compactMap { $0 }
        
        for exposedCard in exposedCards {
            if canAutostack(exposedCard) {
                do {
                    try moveCardToAppropriateFoundation(exposedCard)
                    return autoUpdateFoundations()
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
        #warning("TODO: evaluate if canAutostack(_:) works, then figure out how to work this recursively - something involving if canAutostack(_:) then auto-stack and call autoUpdateFoundations() again")
        
    }
}

extension Board {
    var clubFoundation: Foundation { return foundations.filter({ $0.suit == .clubs }).first! }
    var diamondFoundation: Foundation { return foundations.filter({ $0.suit == .diamonds }).first! }
    var heartFoundation: Foundation { return foundations.filter({ $0.suit == .hearts }).first! }
    var spadeFoundation: Foundation { return foundations.filter({ $0.suit == .spades }).first! }
    
    /// Return lowest outstanding card for a given suit. Returns nil only if the entire suit has moved up to the foundation.
    /// - Parameter suit: Suit to check lowest outstanding card value.
    func lowestOutstandingCard(for suit: Suit) -> Card? {
        let foundation = foundations.filter({ $0.suit == suit }).first!
        
        guard let topCard = foundation.topItem else { return Card(suit: suit, rank: .ace) }
        guard let nextHighest = topCard.rank.nextHighest else { return nil }
        
        return Card(suit: suit, rank: nextHighest)
    }
    
    var lowestOutstandingRedRank: Rank? {
        switch (lowestOutstandingCard(for: .diamonds)?.rank, lowestOutstandingCard(for: .hearts)?.rank) {
        case (nil, nil):
            return nil
        case (nil, let .some(smallestOutstandingHeart)):
            return smallestOutstandingHeart
        case (.some(let smallestOutstandingDiamond), nil):
            return smallestOutstandingDiamond
        case (let .some(smallestOutstandingDiamond), let .some(smallestOutstandingHeart)):
            return min(smallestOutstandingDiamond, smallestOutstandingHeart)
        }
    }
    
    var lowestOutstandingBlackRank: Rank? {
        switch(lowestOutstandingCard(for: .clubs)?.rank, lowestOutstandingCard(for: .spades)?.rank) {
        case (nil, nil):
            return nil
        case (nil, let .some(smallestOutstandingSpade)):
            return smallestOutstandingSpade
        case (.some(let smallestOutstandingClub), nil):
            return smallestOutstandingClub
        case (let .some(smallestOutstandingClub), let .some(smallestOutstandingSpade)):
            return min(smallestOutstandingClub, smallestOutstandingSpade)
        }
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
