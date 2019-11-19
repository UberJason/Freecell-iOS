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

public class Board: ObservableObject {
    public var freecells: [FreeCell]
    public var foundations: [Foundation]
    public var columns: [Column]
    
    public lazy var publisher: AnyPublisher<BoardEvent, Never> = eventSubject.eraseToAnyPublisher()
    private var eventSubject = PassthroughSubject<BoardEvent, Never>()
    
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
    
    public func __testPublisher() {
        eventSubject.send(.debug)
    }
}

public enum BoardEvent {
    case debug
    case moved(from: CardLocation, to: CardLocation)
}
