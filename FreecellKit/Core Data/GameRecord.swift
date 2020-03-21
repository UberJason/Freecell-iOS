//
//  GameRecord.swift
//  FreecellKit
//
//  Created by Jason Ji on 2/15/20.
//  Copyright © 2020 Jason Ji. All rights reserved.
//

import Foundation
import CoreData

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
    
    public convenience init(result: GameResult, moves: Int, time: TimeInterval, managedObjectContext: NSManagedObjectContext) {
        let entity = NSEntityDescription.entity(forEntityName: "CDGameRecord", in: managedObjectContext)!
        self.init(entity: entity, insertInto: managedObjectContext)
        self.result = result
        self.moves = moves
        self.time = time
    }
}

public struct JSONGameRecord: GameRecord, Codable {
    public var result: GameResult
    public var moves: Int = 0
    public var time: TimeInterval = 0
}
