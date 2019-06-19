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
        
        view.backgroundColor = .white
        
        let savedNotesVC = UINavigationController(rootViewController: SavedNoteController(collectionViewLayout: UICollectionViewFlowLayout()))
        //title must match navigation controller title set in viewDidLoad() for each viewcontroller
        let savedItem = CBTabBarItem(title: "Notes", image: UIImage(systemName: "square.grid.2x2"), tag: 0)
        savedItem.tintColor = UIColor.red
        savedNotesVC.tabBarItem = savedItem
        
        let writeNoteVC = WriteNoteController()
        let writeItem = CBTabBarItem(title: "Write", image: UIImage(systemName: "pencil.circle"), tag: 1)
        writeItem.tintColor = UIColor.blue
        writeNoteVC.tabBarItem = writeItem
        
        let settingsVC = UINavigationController(rootViewController: SettingsController())
        let settingsItem = CBTabBarItem(title: "Settings", image: UIImage(systemName: "gear"), tag: 2)
        settingsItem.tintColor = .black
        settingsVC.tabBarItem = settingsItem
        
        viewControllers = [savedNotesVC, writeNoteVC, settingsVC]
        
        self.selectedIndex = 1
    }
    
//    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
//        if item.tag == 0 {
//            print("Saved Notes")
//            let savedNotesController = SavedNoteController()
//            savedNotesController.fetchNotes()
//        } else if item.tag == 1 {
//            print("Write")
//        } else if item.tag == 2 {
//            print("Settings")
//        }
//    }
    
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
