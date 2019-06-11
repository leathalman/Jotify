//
//  Styles.swift
//  Jotify
//
//  Created by Harrison Leath on 5/31/19.
//  Copyright © 2019 Harrison Leath. All rights reserved.
//

import Foundation
import UIKit

struct Theme {
    
    static var backgroundColor:UIColor?
    static var textColor:UIColor?
    static var navigationColor:UIColor?
    
    static public func defaultTheme() {
        self.backgroundColor = UIColor.white
        self.textColor = UIColor.blue
        self.navigationColor = UIColor.white
        updateDisplay()
    }
    
    static public func darkTheme() {
        self.backgroundColor = UIColor.blue
        self.textColor = UIColor.white
        self.navigationColor = UIColor.blue
        updateDisplay()
    }
    
    static public func updateDisplay() {
        let proxyButton = UIButton.appearance()
        proxyButton.setTitleColor(Theme.textColor, for: .normal)
        proxyButton.backgroundColor = Theme.navigationColor
        
        let proxyNavBar = UINavigationBar.appearance()
        proxyNavBar.tintColor = Theme.navigationColor
        proxyNavBar.isTranslucent = false
        
        let proxyView = UIView.appearance()
        proxyView.backgroundColor = backgroundColor
    }
}


//start themeing stuff
//        UINavigationBar.appearance().barTintColor = UIColor.flatRedDark
//        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white]
//        UINavigationBar.appearance().largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white]
//        UITableView.appearance().backgroundColor = UIColor.flatRed
