//
//  Convenience.swift
//  DeckKit
//
//  Created by Jason Ji on 11/15/19.
//  Copyright © 2019 Jason Ji. All rights reserved.
//

import Foundation

public extension Rank {
    var ofClubs: Card { return Card(suit: .clubs, rank: self) }
    var ofDiamonds: Card { return Card(suit: .diamonds, rank: self) }
    var ofHearts: Card { return Card(suit: .hearts, rank: self) }
    var ofSpades: Card { return Card(suit: .spades, rank: self) }
}

public extension Card {
    static var ace: Rank { return Rank.ace }
    static var two: Rank { return Rank.two }
    static var three: Rank { return Rank.three }
    static var four: Rank { return Rank.four }
    static var five: Rank { return Rank.five }
    static var six: Rank { return Rank.six }
    static var seven: Rank { return Rank.seven }
    static var eight: Rank { return Rank.eight }
    static var nine: Rank { return Rank.nine }
    static var ten: Rank { return Rank.ten }
    static var jack: Rank { return Rank.jack }
    static var queen: Rank { return Rank.queen }
    static var king: Rank { return Rank.king }
}
