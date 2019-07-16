//
//  Themes.swift
//  Jotify
//
//  Created by Harrison Leath on 7/16/19.
//  Copyright © 2019 Harrison Leath. All rights reserved.
//

import UIKit

struct InterfaceColors {
    
    //colors for light/dark mode toggle
    static var viewBackgroundColor = UIColor()
    static var navigationBarColor = UIColor()
    static var cellColor = UIColor()
    static var fontColor = UIColor()
    static var writeViewColor = UIColor()
    static var searchBarColor = UIColor()
    static var actionSheetColor = UIColor()
    static var separatorColor = UIColor()
}

class Themes {
    
    func setupDarkMode() {
        print("dark mode")
        
        InterfaceColors.writeViewColor = .grayBackground
        InterfaceColors.viewBackgroundColor = .grayBackground
        InterfaceColors.cellColor = .grayBackground
        InterfaceColors.fontColor = .white
        InterfaceColors.navigationBarColor = .grayBackground
        InterfaceColors.searchBarColor = .grayBackground
        InterfaceColors.actionSheetColor = .grayBackground
        InterfaceColors.separatorColor = .white
    }
    
    func setupDefaultMode() {
        print("default mode")
        
        InterfaceColors.viewBackgroundColor = .white
        InterfaceColors.navigationBarColor = .white
        InterfaceColors.searchBarColor = .white
        InterfaceColors.cellColor = .white
        InterfaceColors.fontColor = .black

    }
}
