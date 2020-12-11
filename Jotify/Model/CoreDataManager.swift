//
//  CoreDataManager.swift
//  Jotify
//
//  Created by Harrison Leath on 10/5/19.
//  Copyright © 2019 Harrison Leath. All rights reserved.
//

import CoreData
import UIKit

struct NoteData {
    static var notes = [Note]()
    static var recentNote: Note!
}

class CoreDataManager {
    static let shared = CoreDataManager()
    
    private var context: NSManagedObjectContext
    private var container: NSPersistentCloudKitContainer
    
    let appDelegate = UIApplication.shared.delegate as? AppDelegate
    let persistentContainerQueue = OperationQueue()
    
    private init() {
        self.container = appDelegate!.persistentContainer
        self.context = appDelegate!.persistentContainer.viewContext
        persistentContainerQueue.maxConcurrentOperationCount = 1
        context.automaticallyMergesChangesFromParent = true
    }
    
    func enqueue(block: @escaping (_ context: NSManagedObjectContext) -> Void) {
        persistentContainerQueue.addOperation {
            let context: NSManagedObjectContext = self.container.newBackgroundContext()
            context.performAndWait {
                block(context)
                try? context.save()
            }
        }
    }
    
    func fetchNotes() {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Note")
        fetchRequest.returnsObjectsAsFaults = false
        
        let sortBy = UserDefaults.standard.string(forKey: "sortBy")
        var sortDescriptor: NSSortDescriptor?
        
        switch sortBy {
        case "content":
            sortDescriptor = NSSortDescriptor(key: "content", ascending: true)
        case "date":
            sortDescriptor = NSSortDescriptor(key: "modifiedDate", ascending: false)
        case "color":
            sortDescriptor = NSSortDescriptor(key: "color", ascending: false)
        case "reminders":
            sortDescriptor = NSSortDescriptor(key: "isReminder", ascending: false)
        case .none:
            sortDescriptor = NSSortDescriptor(key: "modifiedDate", ascending: false)
        case .some(_):
            sortDescriptor = NSSortDescriptor(key: "modifiedDate", ascending: false)
        }
        
        fetchRequest.sortDescriptors = [sortDescriptor] as? [NSSortDescriptor]
        
        CoreDataManager.shared.enqueue { _ in
            do {
                NoteData.notes = try self.context.fetch(fetchRequest) as! [Note]
                
            } catch let error as NSError {
                print("Could not fetch. \(error), \(error.userInfo)")
            }
        }
    }
    
    func setLastNote() {
        fetchNotes()
        NoteData.recentNote = NoteData.notes.first
    }
    
    func saveContext() {
        CoreDataManager.shared.enqueue { context in
            do {
                try context.save()
                
            } catch let error as NSError {
                print("Could not save. \(error), \(error.userInfo)")
            }
        }
    }
}
