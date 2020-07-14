//
//  PageViewController.swift
//  Jotify
//
//  Created by Harrison Leath on 6/30/19.
//  Copyright © 2019 Harrison Leath. All rights reserved.
//

import Blueprints
import UIKit

class PageViewController: UIPageViewController, UIPageViewControllerDelegate {
    var currentIndex = 0
    var lastPosition: CGFloat = 0
            
    let savedNotesController = UINavigationController(rootViewController: SavedNoteController(collectionViewLayout: UICollectionViewFlowLayout()))
    let writeNotesController = WriteNoteController()
    
    lazy var orderedViewControllers: [UIViewController] = {
        return [self.savedNotesController, self.writeNotesController]
    }()
    
    override init(transitionStyle style: UIPageViewController.TransitionStyle, navigationOrientation: UIPageViewController.NavigationOrientation, options: [UIPageViewController.OptionsKey : Any]? = nil) {
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupPageController()
    }
    
    func setupPageController() {
        view.backgroundColor = UIColor.clear

        dataSource = self
        delegate = self
        
        if let firstViewController = orderedViewControllers.last {
            setViewControllers([firstViewController],
                               direction: .forward,
                               animated: true,
                               completion: nil)
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(enableSwipe(notification:)), name:NSNotification.Name(rawValue: "enableSwipe"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(disableSwipe(notification:)), name:NSNotification.Name(rawValue: "disableSwipe"), object: nil)
    }
    
    @objc func disableSwipe(notification: Notification){
        self.dataSource = nil
    }

    @objc func enableSwipe(notification: Notification){
        self.dataSource = self
    }
    

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension PageViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {

        guard let viewControllerIndex = orderedViewControllers.firstIndex(of: viewController) else {
            return nil
        }
        
        let previousIndex = viewControllerIndex - 1
        
        guard previousIndex >= 0 else {
            return nil
        }
        
        guard orderedViewControllers.count > previousIndex else {
            return nil
        }
        
        return orderedViewControllers[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {

        guard let viewControllerIndex = orderedViewControllers.firstIndex(of: viewController) else {
            return nil
        }
        
        let nextIndex = viewControllerIndex + 1
        let orderedViewControllersCount = orderedViewControllers.count

        guard orderedViewControllersCount != nextIndex else {
            return nil
        }
        
        guard orderedViewControllersCount > nextIndex else {
            return nil
        }
        
        return orderedViewControllers[nextIndex]
    }
}
