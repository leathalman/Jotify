//
//  SettingsManager.swift
//  Jotify
//
//  Created by Harrison Leath on 2/6/21.
//

import UIKit

class SettingsManager {
    
    let defaults = UserDefaults.standard
    
    //list of user settings
    static var theme: String = ""
    
    //get values from user defaults and expose them in static vars in SettingsManager
    //so they can be accessed across the application
    func retrieveSettingsFromDefaults() {
        //defaults at "theme" should never been nil because a default value is registered in AppDelegate
        SettingsManager.theme = defaults.string(forKey: "theme")!
        print("Current theme is: \(SettingsManager.theme)")
    }
}
