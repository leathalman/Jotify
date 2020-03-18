//
//  Colors.swift
//  Jotify
//
//  Created by Harrison Leath on 2/8/20.
//  Copyright © 2020 Harrison Leath. All rights reserved.
//

import UIKit

extension UIColor {
    
    // Contains all of the custom colors used in note themes and misc. backgrounds
    
    //light/dark accent colors
    static let grayBackground = UIColor(r: 40, g: 40, b: 40)
    static let offBlackBackground = UIColor(r: 25, g: 25, b: 25)
    static let cellLight = UIColor(r: 246, g: 246, b: 246)
    static let cellDark = UIColor(r: 35, g: 35, b: 35)
    static let cellPureDark = cellDark.adjust(by: -3.75)
    static let cellHighlightDefault = UIColor(r: 209, g: 209, b: 214)
    static let cellHighlightDark = UIColor(r: 58, g: 58, b: 60)
    
    // default
    static let lightRed = UIColor(r: 254, g: 129, b: 118)
    static let lightRedBack = UIColor(r: 221, g: 86, b: 75)
    static let medRed = UIColor(r: 254, g: 151, b: 114)
    static let lightOrange = UIColor(r: 254, g: 171, b: 109)
    static let medOrange = UIColor(r: 253, g: 193, b: 104)
    static let lightYellow = UIColor(r: 254, g: 215, b: 119)
    static let medYellow = UIColor(r: 253, g: 224, b: 119)
    static let lightGreen = UIColor(r: 192, g: 223, b: 129)
    static let medGreen = UIColor(r: 155, g: 215, b: 112)
    static let heavyGreen = UIColor(r: 121, g: 190, b: 168)
    static let lightBlue = UIColor(r: 96, g: 156, b: 225)
    static let medBlue = UIColor(r: 103, g: 143, b: 254)
    static let lightPurple = UIColor(r: 138, g: 138, b: 239)
    static let medPurple = UIColor(r: 144, g: 91, b: 236)
    
    //sunset
    static let blue1 = UIColor(r: 37, g: 117, b: 252)
    static let blue2 = UIColor(r: 37, g: 109, b: 230)
    static let purple1 = UIColor(r: 111, g: 29, b: 200)
    static let lightBlue1 = UIColor(r: 94, g: 165, b: 227)
    static let lightBlue2 = UIColor(r: 79, g: 172, b: 254)
    static let orange1 = UIColor(r: 228, g: 147, b: 30)
    static let red1 = UIColor(r: 246, g: 70, b: 70)
    static let red2 = UIColor(r: 1, g: 88, b: 88)
    
    //kypool
    static let pink1 = UIColor(r: 254, g: 81, b: 150)
    static let pink2 = UIColor(r: 236, g: 73, b: 138)
    static let red3 = UIColor(r: 232, g: 93, b: 78)
    static let red4 = UIColor(r: 247, g: 112, b: 98)
    static let green1 = UIColor(r: 0, g: 227, b: 174)
    static let green2 = UIColor(r: 20, g: 203, b: 160)
    static let blue3 = UIColor(r: 37, g: 117, b: 252)
    static let blue4 = UIColor(r: 37, g: 109, b: 230)
    
    //celestial
    static let green3 = UIColor(r: 36, g: 210, b: 146)
    static let green4 = UIColor(r: 31, g: 197, b: 136)
    static let purple2 = UIColor(r: 194, g: 74, b: 182)
    static let purple3 = UIColor(r: 213, g: 88, b: 200)
    static let blue5 = UIColor(r: 2, g: 80, b: 197)
    static let blue6 = UIColor(r: 43, g: 88, b: 155)
    static let darkRed1 = UIColor(r: 184, g: 56, b: 123)
    static let darkRed2 = UIColor(r: 212, g: 63, b: 141)
    
    // scarlet azure
    static let dBlue = UIColor(r: 192, g: 108, b: 132)
    static let dRed = UIColor(r: 53, g: 92, b: 125)
    static let dGold = UIColor(r: 232, g: 188, b: 118)
    static let lBlue = UIColor(r: 58, g: 101, b: 137)
    static let lRed = UIColor(r: 201, g: 129, b: 150)
    static let lGold = UIColor(r: 233, g: 189, b: 124)
    
    static var defaultColors = [lightRed, medRed, lightOrange, medOrange, lightYellow, medYellow, lightGreen, medGreen, heavyGreen, lightBlue, medBlue, lightPurple, medPurple]
    static var defaultColorsStrings = ["lightRed", "medRed", "lightOrange", "medOrange", "lightYellow", "medYellow", "lightGreen", "medGreen", "heavyGreen", "lightBlue", "medBlue", "lightPurple", "medPurple"]
    
    static var sunsetColors = [blue1, blue2, purple1, lightBlue1, lightBlue2, orange1, red1, red2]
    static var sunsetColorsStrings = ["blue1", "blue2", "purple1", "lightBlue1", "lightBlue2", "orange1", "red1", "red2"]
    
    static var kypoolColors = [pink1, pink2, red3, red4, green1, green2, blue3, blue4]
    static var kypoolColorsStrings = ["pink1", "pink2", "red3", "red4", "green1", "green2", "blue3", "blue4"]
    
    static var celestialColors = [green3, green4, purple2, purple3, blue5, blue6, darkRed1, darkRed2]
    static var celestialColorsStrings = ["green3", "green4", "purple2", "purple3", "blue5", "blue6", "darkRed1", "darkRed2"]
    
    static var appleVibrantColors = [UIColor.systemRed, .systemBlue, .systemGreen, .systemPink, UIColor.systemOrange, .systemPurple, .systemTeal, .systemYellow]
    static var appleVibrantColorsStrings = ["systemRed", "systemBlue", "systemGreen", "systemPink", "systemOrange", "systemPurple", "systemTeal", "systemYellow"]
    
    static var scarletAzureColors = [lGold, dBlue, lRed, lBlue, dRed, dGold]
    static var scarletAzureColorsString = ["lGold", "dBlue", "lRed", "lBlue", "dRed", "dGold"]
}
