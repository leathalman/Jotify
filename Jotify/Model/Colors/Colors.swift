//
//  Colors.swift
//  Jotify
//
//  Created by Harrison Leath on 2/8/20.
//  Copyright © 2020 Harrison Leath. All rights reserved.
//

import UIKit

class Colors {
    
    // Contains all of the custom colors used in note themes and misc. backgrounds
    
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
    
    static var defaultColors = [lightRed, medRed, lightOrange, medOrange, lightYellow, medYellow, lightGreen, medGreen, heavyGreen, lightBlue, medBlue, lightPurple, medPurple]
    static var defaultColorsStrings = ["lightRed", "medRed", "lightOrange", "medOrange", "lightYellow", "medYellow", "lightGreen", "medGreen", "heavyGreen", "lightBlue", "medBlue", "lightPurple", "medPurple"]
    
    static var sunsetColors = [blue1, blue2, purple1, lightBlue1, lightBlue2, orange1, red1, red2]
    static var sunsetColorsStrings = ["blue1", "blue2", "purple1", "lightBlue1", "lightBlue2", "orange1", "red1", "red2"]
    
    static var kypoolColors = [pink1, pink2, red3, red4, green1, green2, blue3, blue4]
    static var kypoolColorsStrings = ["pink1", "pink2", "red3", "red4", "green1", "green2", "blue3", "blue4"]
    
    static var celestialColors = [green3, green4, purple2, purple3, blue5, blue6, darkRed1, darkRed2]
    static var celestialColorsStrings = ["green3", "green4", "purple2", "purple3", "blue5", "blue6", "darkRed1", "darkRed2"]
    
    static var appleVibrantColors = [UIColor.systemRed, UIColor.systemBlue, UIColor.systemGreen, UIColor.systemPink, UIColor.systemOrange, UIColor.systemPurple, UIColor.systemTeal, UIColor.systemYellow]
    static var appleVibrantColorsStrings = ["systemRed", "systemBlue", "systemGreen", "systemPink", "systemOrange", "systemPurple", "systemTeal", "systemYellow"]
    
    static var scarletAzureColors = [lGold, dBlue, lRed, lBlue, dRed, dGold]
    static var scarletAzureColorsString = ["lGold", "dBlue", "lRed", "lBlue", "dRed", "dGold"]
    
    // sunset
    static let blue1 = UIColor(red: 0.1450980392, green: 0.4588235294, blue: 0.9882352941, alpha: 1)
    static let blue2 = UIColor(red: 0.1450980392, green: 0.4274509804, blue: 0.9019607843, alpha: 1)
    static let purple1 = UIColor(red: 0.4352941176, green: 0.1137254902, blue: 0.7843137255, alpha: 1)
    static let lightBlue1 = UIColor(red: 0.368627451, green: 0.6470588235, blue: 0.8901960784, alpha: 1)
    static let lightBlue2 = UIColor(red: 0.3098039216, green: 0.6745098039, blue: 0.9960784314, alpha: 1)
    static let orange1 = UIColor(red: 0.8941176471, green: 0.5764705882, blue: 0.1176470588, alpha: 1)
    static let red1 = UIColor(red: 0.9647058824, green: 0.2745098039, blue: 0.2745098039, alpha: 1)
    static let red2 = UIColor(red: 1, green: 0.3450980392, blue: 0.3450980392, alpha: 1)
    
    // kypool
    static let pink1 = UIColor(red: 0.9960784314, green: 0.3176470588, blue: 0.5882352941, alpha: 1)
    static let pink2 = UIColor(red: 0.9254901961, green: 0.2862745098, blue: 0.5411764706, alpha: 1)
    static let red3 = UIColor(red: 0.9098039216, green: 0.3647058824, blue: 0.3058823529, alpha: 1)
    static let red4 = UIColor(red: 0.968627451, green: 0.4392156863, blue: 0.3843137255, alpha: 1)
    static let green1 = UIColor(red: 0, green: 0.8901960784, blue: 0.6823529412, alpha: 1)
    static let green2 = UIColor(red: 0.07843137255, green: 0.7960784314, blue: 0.6274509804, alpha: 1)
    static let blue3 = UIColor(red: 0.1450980392, green: 0.4588235294, blue: 0.9882352941, alpha: 1)
    static let blue4 = UIColor(red: 0.1450980392, green: 0.4274509804, blue: 0.9019607843, alpha: 1)
    
    // celestial
    static let green3 = UIColor(red: 0.1411764706, green: 0.8235294118, blue: 0.5725490196, alpha: 1)
    static let green4 = UIColor(red: 0.1215686275, green: 0.7725490196, blue: 0.5333333333, alpha: 1)
    static let purple2 = UIColor(red: 0.7607843137, green: 0.2941176471, blue: 0.7137254902, alpha: 1)
    static let purple3 = UIColor(red: 0.8352941176, green: 0.3450980392, blue: 0.7843137255, alpha: 1)
    static let blue5 = UIColor(red: 0.007843137255, green: 0.3137254902, blue: 0.7725490196, alpha: 1)
    static let blue6 = UIColor(red: 0.168627451, green: 0.3450980392, blue: 0.6078431373, alpha: 1)
    static let darkRed1 = UIColor(red: 0.7215686275, green: 0.2196078431, blue: 0.4823529412, alpha: 1)
    static let darkRed2 = UIColor(red: 0.831372549, green: 0.2470588235, blue: 0.5529411765, alpha: 1)
    
    // scarlet azure
    static let dBlue = UIColor(r: 192, g: 108, b: 132)
    static let dRed = UIColor(r: 53, g: 92, b: 125)
    static let dGold = UIColor(r: 232, g: 188, b: 118)
    static let lBlue = UIColor(r: 58, g: 101, b: 137)
    static let lRed = UIColor(r: 201, g: 129, b: 150)
    static let lGold = UIColor(r: 233, g: 189, b: 124)
}
