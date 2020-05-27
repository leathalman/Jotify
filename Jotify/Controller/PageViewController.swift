//
//  PageViewController.swift
//  Jotify
//
//  Created by Harrison Leath on 6/30/19.
//  Copyright © 2019 Harrison Leath. All rights reserved.
//

import Blueprints
import Pageboy
import UIKit

class PageViewController: PageboyViewController, PageboyViewControllerDataSource {
    var viewControllers = [UIViewController]()
    
    let savedNotesController = UINavigationController(rootViewController: SavedNoteController(collectionViewLayout: UICollectionViewFlowLayout()))
    let writeNotesController = WriteNoteController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        viewControllers = [savedNotesController, writeNotesController]
        viewControllers = [UINavigationController(rootViewController: ColorPickerController())]
        
        dataSource = self
        isScrollEnabled = true
        bounces = false
    }
    
    func numberOfViewControllers(in pageboyViewController: PageboyViewController) -> Int {
        return viewControllers.count
    }
    
    func viewController(for pageboyViewController: PageboyViewController,
                        at index: PageboyViewController.PageIndex) -> UIViewController? {
        return viewControllers[index]
    }
    
    func defaultPage(for pageboyViewController: PageboyViewController) -> PageboyViewController.Page? {
        return Page.at(index: 0)
    }
}
