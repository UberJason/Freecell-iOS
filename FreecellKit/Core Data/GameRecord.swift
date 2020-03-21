//
//  GameRecord.swift
//  FreecellKit
//
//  Created by Jason Ji on 2/15/20.
//  Copyright © 2020 Jason Ji. All rights reserved.
//

import Foundation
import CoreData

public enum GameResult: String {
    case win, loss
    
    var opposite: GameResult {
        return self == .win ? .loss : .win
    }
}

public protocol GameRecord {
    var result: GameResult { get set }
    var moves: Int { get set }
    var time: TimeInterval { get set }
}

public class CDGameRecord: NSManagedObject, GameRecord {
    public var result: GameResult {
        get {
            return GameResult(rawValue: resultCD!)!
        }
        set {
            resultCD = newValue.rawValue
        }
    }
    
    public var moves: Int {
        get {
            return Int(movesCD)
        }
        set {
            movesCD = Int64(newValue)
        }
    }
    
    public var time: TimeInterval {
        get {
            return timeCD
        }
        set {
            timeCD = newValue
        }
    }
    
}
