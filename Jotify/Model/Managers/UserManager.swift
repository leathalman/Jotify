//
//  SettingsManager.swift
//  Jotify
//
//  Created by Harrison Leath on 2/6/21.
//

import UIKit

struct Settings {
    //visible to user
    var multilineInputEnabled: Bool
    var deleteOldNotes: Bool
    var useHaptics: Bool
    var useBiometrics: Bool
    
    //invisible to user
    var hasMigrated: Bool
}

class User {
    static var settings: Settings? {
        didSet {
            let defaults = UserDefaults.standard
            defaults.setValue(settings?.multilineInputEnabled, forKey: "multilineInputEnabled")
            defaults.setValue(settings?.hasMigrated, forKey: "hasMigrated")
            defaults.setValue(settings?.deleteOldNotes, forKey: "deleteOldNotes")
            defaults.setValue(settings?.useHaptics, forKey: "useHaptics")
            defaults.setValue(settings?.useBiometrics, forKey: "useBiometrics")
            print("Userdefaults settings updated")
        }
    }
        
    //gets the current settings document from Firebase and updates the model
    static func updateSettings() {
        //success should never be nil and settings should never be nil when success is true
        DataManager.retrieveUserSettings { (settings, success) in
            if success! {
                User.settings = settings
            } else {
                print("Error retrieving settings")
            }
        }
    }
}
