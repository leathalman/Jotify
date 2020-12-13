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
//        context.mergePolicy = NSMergeByPropertyStoreTrumpMergePolicy
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
    
    //save changes from operations (create/delete) to context
    func saveContext() {
        CoreDataManager.shared.enqueue { context in
            do {
                try context.save()
                
            } catch let error as NSError {
                print("Could not save. \(error), \(error.userInfo)")
            }
        }
    }
    
    //create new Note object in context
    //automatically sets:
    //  reminder = false
    //  reminderData = ""
    func createNote(content: String, date: Double, color: UIColor) {
        let entity = NSEntityDescription.entity(forEntityName: "Note", in: context)!
        let note = NSManagedObject(entity: entity, insertInto: context)
        
        note.setValue(content, forKeyPath: "content")
        note.setValue(UIColor.stringFromColor(color: color), forKey: "color")
        note.setValue(date, forKey: "date")
        
        note.setValue(date, forKey: "createdDate")
        note.setValue(date, forKey: "modifiedDate")
        note.setValue(false, forKey: "isReminder")
        note.setValue("", forKey: "reminderDate")
        
        note.setValue(date.formattedString(), forKey: "dateString")
    }
    
    //update NoteData.notes, essentially used to update SavedNoteController datasource
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
}
