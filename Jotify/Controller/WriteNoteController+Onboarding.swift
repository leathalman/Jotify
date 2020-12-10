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
        guard let currentVersion = Bundle.main.infoDictionary![shortVersionKey] as? String else {
            print("Current version could not be found")
            return
        }
        let previousVersion = standard.object(forKey: shortVersionKey) as? String
        if previousVersion == currentVersion {
            // same version, no update
            print("same version")
            
        } else {
            if previousVersion != nil {
                // new version
                print("new version")
//                presentUpdateOnboarding(viewController: self, tintColor: StoredColors.noteColor)
                createWidgetSamepleData()
                
            } else {
                // first launch
                print("first launch")
                presentFirstLaunchOnboarding(viewController: self, tintColor: StoredColors.noteColor)
                createWidgetSamepleData()
            }
            standard.set(currentVersion, forKey: shortVersionKey)
        }
    }
    
    func presentUpdateOnboarding(viewController: UIViewController, tintColor: UIColor) {
        // Jotify v1.2.4 Onboarding
        let whatsNew = WhatsNew(
            title: "What's New - v1.2.4",
            items: [
                WhatsNew.Item(
                    title: "Major Changes",
                    subtitle: "• Jotify has a brand new color picker! Check it out in Settings -> Appearance\n• Dark mode is now free for every user. ",
                    image: UIImage(named: "bell")
                ),
                WhatsNew.Item(
                    title: "Minor Improvements",
                    subtitle: "• You can now disable the review prompt in Settings -> Alerts\n• You can disable haptic feedback in Settings -> Appearance\n• Major under-the-hood improvements to paging.",
                    image: UIImage(named: "add")
                ),
                WhatsNew.Item(
                    title: "Bug Fixes",
                    subtitle: "• Random color algorithm now correctly chooses a color after relaunch.\n• Added dark mode support for introductory onboarding screen.\n• Added dynamic enabling/disabling of gesture control in settings.\n• Restore function now behaves properly.\n• Color picker no longer defaults to white if no color is selected.\n• Fixed bug where default app icon was not properly aligned.\n• Fixed bug where haptic feedback was not working on iPhone X and newer.\n• Updated dependencies. Removed Pageboy as a dependency.",
                    image: UIImage(named: "bugFix")
                ),
            ]
        )
        
        var configuration = WhatsNewViewController.Configuration()
        
        if UserDefaults.standard.bool(forKey: "darkModeEnabled") {
            configuration.apply(theme: .darkDefault)
            configuration.backgroundColor = UIColor.grayBackground
            
        } else {
            configuration.apply(theme: .default)
        }
        
        configuration.titleView.insets = UIEdgeInsets(top: 40, left: 20, bottom: 15, right: 15)
        configuration.itemsView.titleFont = .boldSystemFont(ofSize: 17)
        configuration.itemsView.imageSize = .preferred
        configuration.completionButton.hapticFeedback = .impact(.medium)
        configuration.completionButton.insets.bottom = 30
        configuration.apply(animation: .fade)
        
        if UserDefaults.standard.bool(forKey: "useRandomColor") {
            configuration.titleView.titleColor = StoredColors.noteColor
            configuration.detailButton?.titleColor = StoredColors.noteColor
            configuration.completionButton.backgroundColor = StoredColors.noteColor
            
        } else {
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
    
    func createWidgetSamepleData() {
        GroupDataManager().writeData(path: "widgetContent", content: "Have you written a note yet? You should do that.")
        GroupDataManager().writeData(path: "widgetColor", content: UIColor.stringFromColor(color: UIColor.blue2))
        GroupDataManager().writeData(path: "widgetDate", content: "July 2, 2002")
//        WidgetCenter.shared.reloadAllTimelines()
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
                    title: "Reminders",
                    subtitle: "Set reminders on all of your notes with ease. Simply tap on the alarm icon, set a date, and wait.",
                    image: UIImage(named: "reminder")
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
        
        if UserDefaults.standard.bool(forKey: "useSystemMode") {
            if self.traitCollection.userInterfaceStyle == .dark {
                configuration.apply(theme: .darkDefault)
                configuration.backgroundColor = UIColor.grayBackground
            } else {
                configuration.apply(theme: .default)
            }
        }
        
        configuration.titleView.insets = UIEdgeInsets(top: 40, left: 20, bottom: 15, right: 15)
        configuration.itemsView.titleFont = .boldSystemFont(ofSize: 17)
        configuration.itemsView.imageSize = .preferred
        configuration.completionButton.hapticFeedback = .impact(.medium)
        configuration.completionButton.insets.bottom = 30
        configuration.apply(animation: .fade)
        
        if UserDefaults.standard.bool(forKey: "useRandomColor") {
            configuration.titleView.titleColor = StoredColors.noteColor
            configuration.detailButton?.titleColor = StoredColors.noteColor
            configuration.completionButton.backgroundColor = StoredColors.noteColor
            
        } else {
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
