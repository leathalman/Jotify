//
//  OnboardingController.swift
//  Jotify
//
//  Created by Harrison Leath on 1/13/22.
//

import UIKit
import Pageboy

class OnboardingController: PageboyViewController, PageboyViewControllerDataSource {

    // MARK: Properties
    
    var statusBarStyle: UIStatusBarStyle = .lightContent
    
    //view controllers that will be displayed in page view controller.
    let vc1 = WelcomeViewController()
    let vc2 = WelcomeViewController()
    
    private lazy var viewControllers: [UIViewController] = {
        return [self.vc1, self.vc2]
    }()
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //set PageboyViewControllerDataSource dataSource to configure page view controller
        dataSource = self
        
        //remove bounce effect when overscrolling from page to page
        bounces = false
                
        //setup the color system for background with light/dark mode
        if traitCollection.userInterfaceStyle == .light {
            ColorManager.bgColor = .jotifyGray
        } else if traitCollection.userInterfaceStyle == .dark {
            ColorManager.bgColor = .mineShaft
        }
        
        view.backgroundColor = .clear
    }

    // MARK: PageboyViewControllerDataSource
    
    func numberOfViewControllers(in pageboyViewController: PageboyViewController) -> Int {
        viewControllers.count //how many view controllers to display in the page view controller.
    }
    
    func viewController(for pageboyViewController: PageboyViewController, at index: PageboyViewController.PageIndex) -> UIViewController? {
        viewControllers[index] //view controller to display at a specific index for the page view controller.
    }
    
    func defaultPage(for pageboyViewController: PageboyViewController) -> PageboyViewController.Page? {
        return .first
    }
    
    // MARK: Actions
    
    func scrollToNextPage() {
        scrollToPage(.next, animated: true) { (vc, result, result2) in
//            if result && result2 {
//                let writeNoteController = vc as! WriteNoteController
//                writeNoteController.field.becomeFirstResponder()
//            }
        }
    }
    
    // MARK: TraitCollection
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        if traitCollection.userInterfaceStyle == .light {
            ColorManager.bgColor = .jotifyGray
        } else if traitCollection.userInterfaceStyle == .dark {
            ColorManager.bgColor = .mineShaft
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return statusBarStyle
    }
}
