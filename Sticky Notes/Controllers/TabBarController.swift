//
//  TabBarController.swift
//  Sticky Notes
//
//  Created by Harrison Leath on 5/27/19.
//  Copyright © 2019 Harrison Leath. All rights reserved.
//

import UIKit
import BubbleTabBar

class TabBarController: BubbleTabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        let savedNotesVC = UINavigationController(rootViewController: SavedNoteController())
        //title must match navigation controller title set in viewDidLoad() for each viewcontroller
        let savedItem = CBTabBarItem(title: "Notes", image: #imageLiteral(resourceName: "dashboard"), tag: 0)
        savedNotesVC.tabBarItem = savedItem
        
        let writeNoteVC = WriteNoteController()
        let writeItem = CBTabBarItem(title: "Write", image: #imageLiteral(resourceName: "menu"), tag: 1)
        writeItem.tintColor = UIColor.init(r: 250, g: 77, b: 77)
        writeNoteVC.tabBarItem = writeItem
        
        let settingsVC = UINavigationController(rootViewController: SettingsController())
        let settingsItem = CBTabBarItem(title: "Settings", image: #imageLiteral(resourceName: "settings"), tag: 2)
        settingsItem.tintColor = .gray
        settingsVC.tabBarItem = settingsItem
        
        viewControllers = [savedNotesVC, writeNoteVC, settingsVC]
        
        self.selectedIndex = 1
    }
}
