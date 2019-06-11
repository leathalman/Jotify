//
//  TabBarController.swift
//  Sticky Notes
//
//  Created by Harrison Leath on 5/27/19.
//  Copyright © 2019 Harrison Leath. All rights reserved.
//

import UIKit
import BubbleTabBar
//import ChameleonFramework

class TabBarController: BubbleTabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        let savedNotesVC = UINavigationController(rootViewController: SavedNoteController(collectionViewLayout: UICollectionViewFlowLayout()))
        //title must match navigation controller title set in viewDidLoad() for each viewcontroller
        let savedItem = CBTabBarItem(title: "Notes", image: #imageLiteral(resourceName: "dashboard"), tag: 0)
        savedItem.tintColor = UIColor.red
        savedNotesVC.tabBarItem = savedItem
        
        let writeNoteVC = WriteNoteController()
        let writeItem = CBTabBarItem(title: "Write", image: #imageLiteral(resourceName: "menu"), tag: 1)
        writeItem.tintColor = UIColor.blue
        writeNoteVC.tabBarItem = writeItem
        
        let settingsVC = UINavigationController(rootViewController: SettingsController())
        let settingsItem = CBTabBarItem(title: "Settings", image: #imageLiteral(resourceName: "settings"), tag: 2)
        settingsItem.tintColor = .black
        settingsVC.tabBarItem = settingsItem
        
        viewControllers = [savedNotesVC, writeNoteVC, settingsVC]
        
        //set back to 1 when testing is done
        self.selectedIndex = 1
    }
}
