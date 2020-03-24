//
//  FreecellStore.swift
//  FreecellKit
//
//  Created by Jason Ji on 3/18/20.
//  Copyright © 2020 Jason Ji. All rights reserved.
//

import Foundation
import CoreData

public class FreecellStore {
    let container: NSPersistentContainer
    
    public init(modelName: String = "Freecell") {
        guard let model = NSManagedObjectModel.mergedModel(from: [Bundle(for: type(of: self))]) else { fatalError("Invalid NSManagedObjectModel") }
        container = NSPersistentContainer(name: modelName, managedObjectModel: model)
        container.loadPersistentStores { (storeDescription, error) in
            if let error = error {
                print("Failed to load store: \(error.localizedDescription)")
            }
        }
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
    
    public func createRecord(_ result: GameResult, moves: Int, time: TimeInterval, in managedObjectContext: NSManagedObjectContext? = nil) -> CDGameRecord {
        let context = managedObjectContext ?? container.viewContext
        
        return CDGameRecord(result: result, moves: moves, time: time, managedObjectContext: context)
    }
    
    public func createRecord(from record: JSONGameRecord) -> CDGameRecord {
        return createRecord(record.result, moves: record.moves, time: record.time)
    }
    
    public func allRecords() -> [GameRecord] {
        let fetchRequest: NSFetchRequest<CDGameRecord> = CDGameRecord.fetchRequest()
        do {
            let results = try container.viewContext.fetch(fetchRequest)
            return results
        } catch let error {
            print("Failed to fetch records: \(error.localizedDescription)")
            return []
        }
    }
    
    public func resetAllRecords(in managedObjectContext: NSManagedObjectContext? = nil) {
        let context = managedObjectContext ?? container.viewContext
        
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "CDGameRecord")
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        let _ = try? context.execute(batchDeleteRequest)
    }
    
    public func save() throws {
        try container.viewContext.save()
    }
}
