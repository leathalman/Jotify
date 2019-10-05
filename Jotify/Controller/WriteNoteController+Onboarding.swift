//
//  WriteNoteController+Onboarding.swift
//  Jotify
//
//  Created by Harrison Leath on 10/5/19.
//  Copyright © 2019 Harrison Leath. All rights reserved.
//

import UIKit

extension WriteNoteController {
    
//    func presentOnboarding() {
//        //check to see if the user is new, updated, or neither
//        let standard = UserDefaults.standard
//        let shortVersionKey = "CFBundleShortVersionString"
//        let currentVersion = Bundle.main.infoDictionary![shortVersionKey] as! String
//        let previousVersion = standard.object(forKey: shortVersionKey) as? String
//        if previousVersion == currentVersion {
//            //same version, no update
//            print("same version")
//
//        } else {
//            // replace with `if let previousVersion = previousVersion {` if you need the exact value
//            if previousVersion != nil {
//                // new version
//                print("new version")
//                presentUpdateOnboarding(viewController: self, tintColor: StoredColors.noteColor)
//
//            } else {
//                // first launch
//                print("first launch")
//                presentFirstLaunchOnboarding(viewController: self, tintColor: StoredColors.noteColor)
//            }
//            standard.set(currentVersion, forKey: shortVersionKey)
//        }
//    }
    
    //TEMPORARY VERSION BECAUSE THIS WAS NOT IMPLEMENTED IN 1.0.0
    //CHANGE FROM FIRST LAUNCH TO NEW VERSION FOR ALL FUTURE UPDATES
    func presentOnboarding() {
        //check to see if the user is new, updated, or neither
        let standard = UserDefaults.standard
        let shortVersionKey = "CFBundleShortVersionString"
        let currentVersion = Bundle.main.infoDictionary![shortVersionKey] as! String
        let previousVersion = standard.object(forKey: shortVersionKey) as? String
        if previousVersion == currentVersion {
            //same version, no update
            print("same version")
            
        } else {
            // replace with `if let previousVersion = previousVersion {` if you need the exact value
            if previousVersion != nil {
                // new version
                print("new version")
                presentUpdateOnboarding(viewController: self, tintColor: StoredColors.noteColor)
                
            } else {
                // first launch
                print("first launch")
                presentUpdateOnboarding(viewController: self, tintColor: StoredColors.noteColor)
            }
            standard.set(currentVersion, forKey: shortVersionKey)
        }
    }
    
    func presentUpdateOnboarding(viewController: UIViewController, tintColor: UIColor) {
        //Jotify v1.1.0 Onboarding
        let whatsNew = WhatsNew(
            title: "What's New",
            items: [
                WhatsNew.Item(
                    title: "Reminders",
                    subtitle: "Jotify now natively supports reminders! To set a reminder, tap into a note and click on the alarm icon on the top left hand corner. Once a note becomes a reminder, the border around the note will change color, and once a reminder has been delivered, simply click on your note to clear it.",
                    image: UIImage(named: "reminder")
                ),
                WhatsNew.Item(
                    title: "OLED Dark Mode",
                    subtitle: "Pure Dark Mode has been changed, so it now closely resembles Apple's signature dark mode.",
                    image: UIImage(named: "moon")
                ),
                WhatsNew.Item(
                    title: "Minor Improvements",
                    subtitle: "A few small notable changes: settings have been updated to look more inline with iOS 13, onboarding now supports dark mode, you can now tap anywhere to bring up the keyboard, and added haptic feedback to button presses.",
                    image: UIImage(named: "add")
                ),
                WhatsNew.Item(
                    title: "Bug Fixes",
                    subtitle: "Small fixes regarding deleting notes and settings on iPhone SE.",
                    image: UIImage(named: "bugFix")
                ),
            ]
        )
        
        var configuration = WhatsNewViewController.Configuration()
        
        if UserDefaults.standard.bool(forKey: "darkModeEnabled") == true {
            configuration.apply(theme: .darkDefault)
            configuration.backgroundColor = .grayBackground
            
        } else {
            configuration.apply(theme: .default)
        }
        
        configuration.titleView.titleColor = tintColor
        configuration.titleView.insets = UIEdgeInsets(top: 40, left: 20, bottom: 15, right: 15)
        configuration.itemsView.titleFont = .boldSystemFont(ofSize: 17)
        configuration.itemsView.imageSize = .preferred
        configuration.completionButton.hapticFeedback = .impact(.medium)
        configuration.detailButton?.titleColor = tintColor
        configuration.completionButton.backgroundColor = tintColor
        configuration.completionButton.insets.bottom = 50
        configuration.apply(animation: .fade)
        
        let whatsNewViewController = WhatsNewViewController(
            whatsNew: whatsNew,
            configuration: configuration
        )
        
        DispatchQueue.main.async {
            viewController.present(whatsNewViewController, animated: true)
        }
    }
    
    func presentFirstLaunchOnboarding(viewController: UIViewController, tintColor: UIColor) {
        let whatsNew = WhatsNew(
            title: "Welcome!",
            items: [
                WhatsNew.Item(
                    title: "Notes",
                    subtitle: "Creating notes is simple: type and enter. Your notes are automatically saved and synced to all of your devices. Swipe right to view your notes.",
                    image: UIImage(named: "write")
                ),
                WhatsNew.Item(
                    title: "Privacy",
                    subtitle: "Jotify does not have access to any of your data and never will. All of your notes are just that, yours.",
                    image: UIImage(named: "lock")
                ),
                WhatsNew.Item(
                    title: "No Accounts. Ever.",
                    subtitle: "Jotify uses your iCloud account to store notes, so no annoying emails or extra passwords to worry about.",
                    image: UIImage(named: "person")
                ),
                WhatsNew.Item(
                    title: "Dark Mode",
                    subtitle: "It looks pretty good. You should check it out.",
                    image: UIImage(named: "moon")
                ),
                WhatsNew.Item(
                    title: "Open Source",
                    subtitle: "Jotify is open source, so you know exactly what is running on your device. Feel free to check it out on GitHub.",
                    image: UIImage(named: "github")
                )
            ]
        )
        
        var configuration = WhatsNewViewController.Configuration()
        
        if UserDefaults.standard.bool(forKey: "darkModeEnabled") == true {
            configuration.apply(theme: .darkDefault)
            configuration.backgroundColor = .grayBackground
            
        } else {
            configuration.apply(theme: .default)
        }
        
        configuration.titleView.titleColor = tintColor
        configuration.titleView.insets = UIEdgeInsets(top: 40, left: 20, bottom: 15, right: 15)
        configuration.itemsView.titleFont = .boldSystemFont(ofSize: 17)
        configuration.itemsView.imageSize = .preferred
        configuration.completionButton.hapticFeedback = .impact(.medium)
        configuration.detailButton?.titleColor = tintColor
        configuration.completionButton.backgroundColor = tintColor
        configuration.apply(animation: .fade)
        
        let whatsNewViewController = WhatsNewViewController(
            whatsNew: whatsNew,
            configuration: configuration
        )
        
        DispatchQueue.main.async {
            viewController.present(whatsNewViewController, animated: true)
        }
    }
}
