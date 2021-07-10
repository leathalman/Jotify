//
//  InitialSetupController.swift
//  Jotify
//
//  Created by Harrison Leath on 7/9/21.
//

import WidgetKit

class InitialSetupController {
    
    //setup URL for widgets
    private func setupWidget() {
        GroupDataManager.writeData(path: GroupDataPaths.color, content: "systemBlue")
        GroupDataManager.writeData(path: GroupDataPaths.content, content: "This is a placeholder note until you start writing.")
        GroupDataManager.writeData(path: GroupDataPaths.date, content: "July 2, 2002")
        print("Setting up widgets...")
        if #available(iOS 14.0, *) {
            WidgetCenter.shared.reloadAllTimelines()
        }
    }
    
    //default Userdefaults
    private func setupDefaults() {
        UserDefaults.standard.register(defaults: [
            "hasMigrated": false,
            "multilineInputEnabled": false,
            "useHaptics": true,
            "deleteOldNotes": false
        ])
    }
    
    func handleApplicationSetup() {
        let defaults = UserDefaults.standard
        let shortVersionKey = "CFBundleShortVersionString"
        guard let currentVersion = Bundle.main.infoDictionary![shortVersionKey] as? String else {
            print("Current version could not be found")
            return
        }
        let previousVersion = defaults.object(forKey: shortVersionKey) as? String
        if previousVersion == currentVersion {
            // same version, no update
            print("same version")
        } else {
            if previousVersion != nil {
                // new version
                print("new version")
                
            } else {
                // first launch
                print("first launch")
                setupWidget()
                setupDefaults()
            }
            defaults.set(currentVersion, forKey: shortVersionKey)
        }
    }
    
}
