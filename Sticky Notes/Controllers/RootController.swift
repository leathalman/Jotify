//
//  RootController.swift
//  Sticky Notes
//
//  Created by Harrison Leath on 5/8/19.
//  Copyright © 2019 Harrison Leath. All rights reserved.
//

import UIKit
import SwipeViewController

class ViewController: SwipeViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let VC1 = LeftViewController()
        VC1.view.backgroundColor = UIColor.white
        VC1.title = "Saved"
        let VC2 = MiddleViewController()
        VC2.view.backgroundColor = UIColor.purple
        VC2.title = "Notes"
        let VC3 = RightViewController()
        VC3.view.backgroundColor = UIColor.blue
        VC3.title = "Settings"
        
        setViewControllerArray([VC1, VC2, VC3])
        setFirstViewController(1)
        setSelectionBar(80, height: 3, color: UIColor(red: 0.23, green: 0.55, blue: 0.92, alpha: 1.0))
        setButtonsWithSelectedColor(UIFont.systemFont(ofSize: 18), color: UIColor.black, selectedColor: UIColor(red: 0.23, green: 0.55, blue: 0.92, alpha: 1.0))
        equalSpaces = true
        
        //Button with image example
        //        let buttonOne = SwipeButtonWithImage(image: UIImage(named: "Settings"), selectedImage: UIImage(named: "YellowHearts"), size: CGSize(width: 40, height: 40))
        //        setButtonsWithImages([buttonOne, buttonOne, buttonOne])
        
//        let barButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(push))
//        setNavigationWithItem(UIColor.white, leftItem: barButtonItem, rightItem: nil)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//    @objc func push(sender: UIBarButtonItem) {
//        let VC4 = UIViewController()
//        VC4.view.backgroundColor = UIColor.purple
//        VC4.title = "Cool"
//        self.pushViewController(VC4, animated: true)
//    }
    
    
}
