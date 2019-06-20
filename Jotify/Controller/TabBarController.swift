//
//  TabBarController.swift
//  Sticky Notes
//
//  Created by Harrison Leath on 5/27/19.
//  Copyright © 2019 Harrison Leath. All rights reserved.
//

import UIKit
import BubbleTabBar

class TabBarController: UITabBarController, UITabBarControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.delegate = self
        
        let savedNotesViewController = UINavigationController(rootViewController: SavedNoteController(collectionViewLayout: UICollectionViewFlowLayout()))
        let savedItem = UITabBarItem()
        savedItem.title = "Notes"
        savedItem.tag = 0
        if #available(iOS 13.0, *) {
            savedItem.image = UIImage(systemName: "square.grid.2x2")
        } else {
            savedItem.image = UIImage(named: "dashboard")
        }
        savedNotesViewController.tabBarItem = savedItem
        
        let writeNoteViewController = WriteNoteController()
        let writeItem = UITabBarItem()
        writeItem.title = "Write"
        writeItem.tag = 1
        if #available(iOS 13.0, *) {
            writeItem.image = UIImage(systemName: "pencil.circle")
        } else {
            writeItem.image = UIImage(named: "menu")
        }
        writeNoteViewController.tabBarItem = writeItem
        
        let settingsViewController = UINavigationController(rootViewController: SettingsController(style: .grouped))
        let settingsItem = UITabBarItem()
        settingsItem.title = "Settings"
        settingsItem.tag = 2
        if #available(iOS 13.0, *) {
            settingsItem.image = UIImage(systemName: "gear")
        } else {
            settingsItem.image = UIImage(named: "settings")
        }
        settingsViewController.tabBarItem = settingsItem
        
        viewControllers = [savedNotesViewController, writeNoteViewController, settingsViewController]
        
        self.selectedIndex = 1
    }
    
    func tabBarController(_ tabBarController: UITabBarController, animationControllerForTransitionFrom fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return TabBarTransition(viewControllers: tabBarController.viewControllers)
    }
    
}

class TabBarTransition: NSObject, UIViewControllerAnimatedTransitioning {
    
    let viewControllers: [UIViewController]?
    let transitionDuration: Double = 0.2
    
    init(viewControllers: [UIViewController]?) {
        self.viewControllers = viewControllers
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return TimeInterval(transitionDuration)
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        guard
            let fromVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from),
            let fromView = fromVC.view,
            let fromIndex = getIndex(forViewController: fromVC),
            let toVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to),
            let toView = toVC.view,
            let toIndex = getIndex(forViewController: toVC)
            else {
                transitionContext.completeTransition(false)
                return
        }
        
        let frame = transitionContext.initialFrame(for: fromVC)
        var fromFrameEnd = frame
        var toFrameStart = frame
        fromFrameEnd.origin.x = toIndex > fromIndex ? frame.origin.x - frame.width : frame.origin.x + frame.width
        toFrameStart.origin.x = toIndex > fromIndex ? frame.origin.x + frame.width : frame.origin.x - frame.width
        toView.frame = toFrameStart
        
        DispatchQueue.main.async {
            transitionContext.containerView.addSubview(toView)
            UIView.animate(withDuration: self.transitionDuration, animations: {
                fromView.frame = fromFrameEnd
                toView.frame = frame
            }, completion: {success in
                fromView.removeFromSuperview()
                transitionContext.completeTransition(success)
            })
        }
    }
    
    func getIndex(forViewController vc: UIViewController) -> Int? {
        guard let vcs = self.viewControllers else { return nil }
        for (index, thisVC) in vcs.enumerated() {
            if thisVC == vc { return index }
        }
        return nil
    }
}
