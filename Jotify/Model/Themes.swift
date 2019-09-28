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
    
    func setupVibrantDarkMode() {
        InterfaceColors.writeViewColor = .grayBackground
        InterfaceColors.viewBackgroundColor = .grayBackground
        InterfaceColors.cellColor = .cellDark
        InterfaceColors.fontColor = .white
        InterfaceColors.navigationBarColor = .grayBackground
        InterfaceColors.searchBarColor = .grayBackground
        InterfaceColors.actionSheetColor = .grayBackground
        InterfaceColors.separatorColor = .white
    }
    
    func setupPureDarkMode() {
        InterfaceColors.writeViewColor = .black
        InterfaceColors.viewBackgroundColor = .black
        InterfaceColors.cellColor = .cellPureDark ?? UIColor.cellDark
        InterfaceColors.fontColor = .white
        InterfaceColors.navigationBarColor = .black
        InterfaceColors.searchBarColor = .black
        InterfaceColors.actionSheetColor = .black
        InterfaceColors.separatorColor = .white
    }
    
    func setupDefaultMode() {        
        InterfaceColors.viewBackgroundColor = .white
        InterfaceColors.navigationBarColor = .white
        InterfaceColors.searchBarColor = .white
        InterfaceColors.cellColor = .cellLight
        InterfaceColors.fontColor = .black

    }
}
