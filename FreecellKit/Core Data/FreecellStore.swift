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
        guard let modelURL = Bundle(for: type(of: self)).url(forResource: modelName, withExtension: "momd"),
            let model = NSManagedObjectModel(contentsOf: modelURL) else { fatalError("Invalid NSManagedObjectModel") }
        
        container = NSPersistentContainer(name: modelName, managedObjectModel: model)
        container.loadPersistentStores { (storeDescription, error) in
            if let error = error {
                print("Failed to load store: \(error.localizedDescription)")
            }
            print(storeDescription)
        }
    }
    
    public func createRecord(_ result: GameResult, moves: Int, time: TimeInterval, in managedObjectContext: NSManagedObjectContext? = nil) -> CDGameRecord {
        let context = managedObjectContext ?? container.viewContext
        
        let record = CDGameRecord(context: context)
        record.result = result
        record.moves = moves
        record.time = time

        return record
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
    
    public func save() throws {
        try container.viewContext.save()
    }
}
