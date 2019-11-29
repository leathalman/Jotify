//
//  WriteNoteController+Onboarding.swift
//  Jotify
//
//  Created by Harrison Leath on 10/5/19.
//  Copyright © 2019 Harrison Leath. All rights reserved.
//

import UIKit

extension WriteNoteController {
    func presentOnboarding() {
        // check to see if the user is new, updated, or neither
        let standard = UserDefaults.standard
        let shortVersionKey = "CFBundleShortVersionString"
        let currentVersion = Bundle.main.infoDictionary![shortVersionKey] as! String
        let previousVersion = standard.object(forKey: shortVersionKey) as? String
        if previousVersion == currentVersion {
            // same version, no update
            print("same version")
            
        } else {
            // replace with `if let previousVersion = previousVersion {` if you need the exact value
            if previousVersion != nil {
                // new version
                print("new version")
//                presentUpdateOnboarding(viewController: self, tintColor: StoredColors.noteColor)
                
            } else {
                // first launch
                print("first launch")
                presentFirstLaunchOnboarding(viewController: self, tintColor: StoredColors.noteColor)
            }
            standard.set(currentVersion, forKey: shortVersionKey)
        }
    }
    
    func presentUpdateOnboarding(viewController: UIViewController, tintColor: UIColor) {
        // Jotify v1.1.3 Onboarding
        let whatsNew = WhatsNew(
            title: "What's New",
            items: [
                WhatsNew.Item(
                    title: "Features",
                    subtitle: "You can now delete multiple notes at once! Simply long press a note, click \"select multiple\", and then delete as many as your heart desires.",
                    image: UIImage(named: "write")
                ),
                WhatsNew.Item(
                    title: "Improvements",
                    subtitle: "Added an additional dark mode icon for Jotify! To check it out, click on the gear icon, then about, and finally tap on the large icon image. Also added automatic saving for notes whenever the app enters multitasking.",
                    image: UIImage(named: "add")
                ),
                WhatsNew.Item(
                    title: "Bug Fixes",
                    subtitle: "Fixed a bug where notes would incorrectly order themselves after sorting. Also fixed an issue where navigation bar would update with the wrong color in dark mode.",
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
        
        configuration.titleView.insets = UIEdgeInsets(top: 40, left: 20, bottom: 15, right: 15)
        configuration.itemsView.titleFont = .boldSystemFont(ofSize: 17)
        configuration.itemsView.imageSize = .preferred
        configuration.completionButton.hapticFeedback = .impact(.medium)
        configuration.completionButton.insets.bottom = 30
        configuration.apply(animation: .fade)
        
        if UserDefaults.standard.bool(forKey: "useRandomColor") == true {
            configuration.titleView.titleColor = StoredColors.noteColor
            configuration.detailButton?.titleColor = StoredColors.noteColor
            configuration.completionButton.backgroundColor = StoredColors.noteColor
            
        } else if UserDefaults.standard.bool(forKey: "useRandomColor") == false {
            configuration.titleView.titleColor = StoredColors.staticNoteColor
            configuration.detailButton?.titleColor = StoredColors.staticNoteColor
            configuration.completionButton.backgroundColor = StoredColors.staticNoteColor
        }
        
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
        
        configuration.titleView.insets = UIEdgeInsets(top: 40, left: 20, bottom: 15, right: 15)
        configuration.itemsView.titleFont = .boldSystemFont(ofSize: 17)
        configuration.itemsView.imageSize = .preferred
        configuration.completionButton.hapticFeedback = .impact(.medium)
        configuration.completionButton.insets.bottom = 30
        configuration.apply(animation: .fade)
        
        if UserDefaults.standard.bool(forKey: "useRandomColor") == true {
            configuration.titleView.titleColor = StoredColors.noteColor
            configuration.detailButton?.titleColor = StoredColors.noteColor
            configuration.completionButton.backgroundColor = StoredColors.noteColor
            
        } else if UserDefaults.standard.bool(forKey: "useRandomColor") == false {
            configuration.titleView.titleColor = StoredColors.staticNoteColor
            configuration.detailButton?.titleColor = StoredColors.staticNoteColor
            configuration.completionButton.backgroundColor = StoredColors.staticNoteColor
        }
        
        let whatsNewViewController = WhatsNewViewController(
            whatsNew: whatsNew,
            configuration: configuration
        )
        
        DispatchQueue.main.async {
            viewController.present(whatsNewViewController, animated: true)
        }
    }
}
