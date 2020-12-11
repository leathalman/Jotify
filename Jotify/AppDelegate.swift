//
//  AppDelegate.swift
//  Jotify
//
//  Created by Harrison Leath on 6/23/19.
//  Copyright © 2019 Harrison Leath. All rights reserved.
//

import CoreData
import UIKit
import UserNotifications
import WidgetKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
                
        let center = UNUserNotificationCenter.current()
        center.delegate = self
        
        UserDefaults.standard.register(defaults: [
            "noteColorTheme": "default",
            "useRandomColor": true,
            "sortBy": "date",
            "showAlertOnDelete": true,
            "showAlertOnSort": true,
            "vibrantDarkModeEnabled": false,
            "pureDarkModeEnabled": false,
            "useBiometrics": false,
            "writeNotePlaceholder": "Start typing or swipe right for saved notes...",
            "com.austinleath.Jotify.Premium": false,
            "useSystemMode": true,
            "showRatingPrompt": true,
            "useHaptics": true
        ])
                
        if UserDefaults.standard.bool(forKey: "darkModeEnabled") == true {
            if UserDefaults.standard.bool(forKey: "vibrantDarkModeEnabled") == true {
                Themes().setupVibrantDarkMode()
            } else if UserDefaults.standard.bool(forKey: "pureDarkModeEnabled") {
                Themes().setupPureDarkMode()
            }
        } else {
            Themes().setupDefaultMode()
        }
        
        CoreDataManager.shared.fetchNotes()
                        
        switch Config.appConfiguration {
        case .Debug:
            print("debug")
//            UserDefaults.standard.set(true, forKey: "com.austinleath.Jotify.Premium")
        case .TestFlight:
            print("testflight")
        case .AppStore:
            print("appStore")
        }
                
        return true
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        if EditingData.writeNoteViewText != "" {
            NoteData.tempNote = NoteData.notes.first
            NoteData.tempNote.content = EditingData.writeNoteViewText
            NoteData.tempNote.color = UIColor.stringFromColor(color: StoredColors.noteColor)
            
            GroupDataManager().writeData(path: "widgetDate", content: NoteData.tempNote.dateString ?? "Date not found")
            GroupDataManager().writeData(path: "widgetContent", content: EditingData.writeNoteViewText)
            GroupDataManager().writeData(path: "widgetColor", content: UIColor.stringFromColor(color: StoredColors.noteColor))
            
            if #available(iOS 14.0, *) {
                WidgetCenter.shared.reloadAllTimelines()
            }
            
            CoreDataManager.shared.fetchNotes()
        }
        saveContext()
    }
    
    // MARK: UISceneSession Lifecycle
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    // MARK: - Core Data stack
    
    lazy var applicationDocumentsDirectory: URL = {
        // The directory the application uses to store the Core Data store file. This code uses a directory named "com.MyApp" in the application's documents Application Support directory.
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return urls[urls.count-1]
    }()

    lazy var managedObjectModel: NSManagedObjectModel = {
        // The managed object model for the application. This property is not optional. It is a fatal error for the application not to be able to find and load its model.
        let modelURL = Bundle.main.url(forResource: "Jotify", withExtension: "momd")!
        return NSManagedObjectModel(contentsOf: modelURL)!
    }()
    
    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it. This property is optional since there are legitimate error conditions that could cause the creation of the store to fail.
        // Create the coordinator and store
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.appendingPathComponent("SingleViewCoreData.sqlite")
        var failureReason = "There was an error creating or loading the application's saved data."
        do {
            try coordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: url, options: [NSMigratePersistentStoresAutomaticallyOption: true,NSInferMappingModelAutomaticallyOption: true])
        } catch {
            // Report any error we got.
            var dict = [String: AnyObject]()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data" as AnyObject?
            dict[NSLocalizedFailureReasonErrorKey] = failureReason as AnyObject?

            dict[NSUnderlyingErrorKey] = error as NSError
            let wrappedError = NSError(domain: "JOTIFY_ERROR", code: 9999, userInfo: dict)
            // Replace this with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog("Unresolved error \(wrappedError), \(wrappedError.userInfo)")
            abort()
        }

        return coordinator
    }()
    
    lazy var persistentContainer: NSPersistentCloudKitContainer = {
        let container = NSPersistentCloudKitContainer(name: "Jotify")
        
        // set a merge policy when queues do not work properly
        // you never want a merge conflict to exist becuase data will be lost
        // only set for backup cases
//        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        
        // get the store description
        guard let description = container.persistentStoreDescriptions.first else {
            fatalError("Could not retrieve a persistent store description.")
        }
        
        // initialize the CloudKit schema
        let id = "iCloud.com.austinleath.Jotify"
        let options = NSPersistentCloudKitContainerOptions(containerIdentifier: id)
        description.cloudKitContainerOptions = options
        
        container.loadPersistentStores(completionHandler: { _, error in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        
        description.shouldInferMappingModelAutomatically = true
        description.shouldMigrateStoreAutomatically = true
        
        return container
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    // when app is in foreground
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
//        let userInfo = notification.request.content.userInfo
        print("THIS IS FIRED")
        
        // display banner when app is open
        completionHandler(UNNotificationPresentationOptions.alert)
    }
    
    // when app is in background / or notification is tapped
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        
        if let reminderText = userInfo["reminderBodyText"] {
            print("Reminder Text: \(reminderText)")
        }
        
        print(userInfo)
        
        completionHandler()
    }
}
