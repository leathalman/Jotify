//
//  CoreDataManager.swift
//  Jotify
//
//  Created by Harrison Leath on 10/5/19.
//  Copyright © 2019 Harrison Leath. All rights reserved.
//

import UIKit
import CoreData

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
        persistentContainerQueue.addOperation() {
            let context: NSManagedObjectContext = self.container.newBackgroundContext()
            context.performAndWait{
                block(context)
                try? context.save()
            }
        }
    }
    
}
