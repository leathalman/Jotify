//
//  TabBarController.swift
//  Sticky Notes
//
//  Created by Harrison Leath on 5/27/19.
//  Copyright © 2019 Harrison Leath. All rights reserved.
//

import UIKit

class TabBarController: BubbleTabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }
    
    func setupView() {
        view.backgroundColor = .white
        
        let savedNotesVC = SavedNoteController()
        savedNotesVC.tabBarItem = UITabBarItem(title: "Saved", image: #imageLiteral(resourceName: "dashboard"), tag: 0)
        savedNotesVC.title = "Saved Notes"
        let writeNoteVC = WriteNoteController()
        writeNoteVC.tabBarItem = UITabBarItem(title: "Write", image: #imageLiteral(resourceName: "menu"), tag: 1)
        writeNoteVC.title = "Write"
        let settingsVC = SettingsController()
        settingsVC.tabBarItem = UITabBarItem(title: "Settings", image: #imageLiteral(resourceName: "settings"), tag: 2)
        settingsVC.title = "Settings"
        
        viewControllers = [savedNotesVC, writeNoteVC, settingsVC]
    }
}
