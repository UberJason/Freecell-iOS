//
//  TextInitializing.swift
//  FreecellKit
//
//  Created by Jason Ji on 4/6/20.
//  Copyright © 2020 Jason Ji. All rights reserved.
//

import Foundation
import DeckKit

// Expect string to have format like "[♠️3, ❤️4, ♦️K, ♣️Q]"

public protocol Parser {
    associatedtype Output
    func parse(from text: String) -> Output
}

public extension Parser {
    func stripBrackets(from text: String) -> String? {
        guard let firstBracketIndex = text.firstIndex(of: "["),
            let secondBracketIndex = text.lastIndex(of: "]") else { return nil }
        
        if secondBracketIndex == text.index(after: firstBracketIndex) { return "" }
        
        let startIndex = text.index(after: firstBracketIndex)
        let endIndex = text.index(before: secondBracketIndex)
        
        return String(text[startIndex...endIndex])
    }
}

public struct BoardParser: Parser {
    public init() {}
    
    public func parse(from text: String) -> Board? {
        let groups = text.split(separator: "\n").map { String($0) }
        let freecellText = groups[1]
        let foundationText = groups[3]
        let columnsTexts = Array(groups[5..<groups.count])
        
        let freecells = parseFreecells(from: freecellText)
        let foundations = parseFoundations(from: foundationText)
        let columns = parseColumns(from: columnsTexts)
        
        return Board.preconfigured(withFreecells: freecells, foundations: foundations, columns: columns)
    }
    
    public func parse(fromFile filename: String, bundle: Bundle = Bundle.main) -> Board? {
        guard let path = bundle.path(forResource: filename, ofType: "txt"),
            let data = try? Data(contentsOf: URL(fileURLWithPath: path)),
            let string = String(data: data, encoding: .utf8) else {
                return nil
        }
        
        return parse(from: string)
    }
    
    func parseFreecells(from text: String) -> [FreeCell] {
        return text
            .split(separator: " ")
            .compactMap { FreeCell(text: String($0)) }
    }
    
    func parseFoundations(from text: String) -> [Foundation] {
        return text
            .split(separator: " ")
            .compactMap { Foundation(text: String($0)) }
    }
    
    func parseColumns(from texts: [String]) -> [Column] {
        return texts.compactMap { Column(text: $0) }
    }
}

public struct CardParser: Parser {
    public func parse(from text: String) -> [Card] {
        guard let stripped = stripBrackets(from: text) else { return [] }
        
        return stripped
            .split(separator: ",")
            .map { $0.trimmingCharacters(in: .whitespaces) }
            .compactMap(Card.init)
    }
}

public struct SuitParser: Parser {
    public func parse(from text: String) -> Suit? {
        guard let firstBracketIndex = text.firstIndex(of: "["),
            let secondBracketIndex = text.lastIndex(of: "]") else { return nil }
        
        let startIndex = text.index(after: firstBracketIndex)
        let endIndex = text.index(before: secondBracketIndex)
        
        return Suit(text: String(text[startIndex...endIndex]))
    }
}

public extension FreeCell {
      convenience init?(text: String) {
        let cards = CardParser().parse(from: text)
        
        guard cards.count < 2 else { return nil }
        self.init(card: cards.first)
    }
}

public extension Foundation {
    // First try to parse a card. Requirement: should have one card representing the top card. e.g. "[♠️3]"
    // If that's not available, try to parse a suit. Requirement: should look like "[♠️]" to represent an empty Spade foundation.
    convenience init?(text: String) {
        let cards = CardParser().parse(from: text)
        
        if cards.count == 1 {
            self.init(topCard: cards.first!)
        }
        else {
            guard let suit = SuitParser().parse(from: text) else { return nil }
            self.init(suit: suit)
        }
    }
}

public extension Column {
    convenience init?(text: String) {
        let cards = CardParser().parse(from: text)
        self.init(cards: cards)
    }
}
