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

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    let themes = Themes()
    
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
            "darkModeEnabled": false,
            "vibrantDarkModeEnabled": false,
            "pureDarkModeEnabled": false,
            "useBiometrics": false,
            "writeNotePlaceholder": "Start typing or swipe left for saved notes...",
            "com.austinleath.Jotify.Premium": false,
        ])
        
        if UserDefaults.standard.bool(forKey: "darkModeEnabled") == true {
            if UserDefaults.standard.bool(forKey: "vibrantDarkModeEnabled") == true {
                themes.setupVibrantDarkMode()
            } else if UserDefaults.standard.bool(forKey: "pureDarkModeEnabled") {
                themes.setupPureDarkMode()
            }
        } else {
            themes.setupDefaultMode()
        }
                
        switch Config.appConfiguration {
        case .Debug:
            print("Debug")
        case .TestFlight:
            print("Testflight")
//            UserDefaults.standard.set(true, forKey: "com.austinleath.Jotify.Premium")
        case .AppStore:
            print("AppStore")
        }
        
        return true
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        saveNoteBeforeExiting()
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
    
    func saveNoteBeforeExiting() {
        if EditingData.isEditing == true {
            let noteDetailController = NoteDetailController()
            let index = EditingData.index
            let newContent = EditingData.newContent
            let newDate = EditingData.newDate
            let notes = EditingData.notes
            noteDetailController.notes = notes
            noteDetailController.updateContent(index: index, newContent: newContent, newDate: newDate)
            print("Note data successfully saved.")
            
        } else {
            print("No new note data to save.")
        }
    }
}
