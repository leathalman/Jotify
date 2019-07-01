//
//  PageViewController.swift
//  Jotify
//
//  Created by Harrison Leath on 6/30/19.
//  Copyright © 2019 Harrison Leath. All rights reserved.
//

import UIKit
import Pageboy
import Blueprints

class PageViewController: PageboyViewController, PageboyViewControllerDataSource {
    
    var viewControllers = [UIViewController]()
    
    let savedNotesController = UINavigationController(rootViewController: SavedNoteController(collectionViewLayout: UICollectionViewFlowLayout()))
    let writeNotesController = WriteNoteController()
    let settingsController = UINavigationController(rootViewController: SettingsController(style: .grouped))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewControllers = [savedNotesController, writeNotesController, settingsController]
        
        dataSource = self
    }
    
    func numberOfViewControllers(in pageboyViewController: PageboyViewController) -> Int {

        return viewControllers.count
    }
    
    func viewController(for pageboyViewController: PageboyViewController,
                        at index: PageboyViewController.PageIndex) -> UIViewController? {
        return viewControllers[index]
    }
    
    func defaultPage(for pageboyViewController: PageboyViewController) -> PageboyViewController.Page? {
        return Page.at(index: 1)
    }
  
    //implement dots??
    
//    func presentationCount(for pageViewController: UIPageViewController) -> Int {
//        return viewControllers.count
//    }
//
//    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
//        return 1
//    }
}
