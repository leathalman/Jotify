//
//  MigrationHandler.swift
//  Jotify
//
//  Created by Harrison Leath on 2/16/21.
//

import CoreData
import UIKit

class MigrationHandler {
        
    var context: NSManagedObjectContext
    private var container: NSPersistentCloudKitContainer
    
    static var CDNotes: [Note] = []
    
    private let appDelegate = UIApplication.shared.delegate as? AppDelegate
    private let persistentContainerQueue = OperationQueue()
    
    init() {
        self.container = appDelegate!.persistentContainer
        self.context = appDelegate!.persistentContainer.viewContext
        persistentContainerQueue.maxConcurrentOperationCount = 1
        context.automaticallyMergesChangesFromParent = true
        
        fetchCloudKitData()
    }
    
    private func fetchCloudKitData() {
        //don't fetch any data if migration already happened
        if UserDefaults.standard.bool(forKey: "hasMigrated") { return }
        let fetchRequest = NSFetchRequest<Note>(entityName: "Note")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "modifiedDate", ascending: true)]
        do {
            MigrationHandler.CDNotes = try self.context.fetch(fetchRequest)
            
        } catch {
            fatalError("Failed to fetch entities: \(error)")
        }
    }
}
