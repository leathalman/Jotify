//
//  Colors+Handlers.swift
//  Jotify
//
//  Created by Harrison Leath on 6/30/19.
//  Copyright © 2019 Harrison Leath. All rights reserved.
//

import Foundation
import UIKit

struct StoredColors {
    static var noteColor = UIColor()
    static var noteColorString = String()
    static var staticNoteColor = UIColor()
    static var reminderColor = UIColor()
}

extension UIColor {
    convenience init(r: CGFloat, g: CGFloat, b: CGFloat) {
        self.init(red: r/255, green: g/255, blue: b/255, alpha: 1)
    }
    
    static let grayBackground = UIColor(r: 40, g: 40, b: 40)
    static let offBlackBackground = UIColor(r: 25, g: 25, b: 25)
    
    static let cellDark = UIColor(r: 35, g: 35, b: 35)
    static let cellLight = UIColor(r: 250, g: 250, b: 250)
    
    //default
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
    static let blue1 = UIColor(red: 0.1450980392, green: 0.4588235294, blue: 0.9882352941, alpha: 1)
    static let blue2 = UIColor(red: 0.1450980392, green: 0.4274509804, blue: 0.9019607843, alpha: 1)
    static let purple1 = UIColor(red: 0.4352941176, green: 0.1137254902, blue: 0.7843137255, alpha: 1)
    static let lightBlue1 = UIColor(red: 0.368627451, green: 0.6470588235, blue: 0.8901960784, alpha: 1)
    static let lightBlue2 = UIColor(red: 0.3098039216, green: 0.6745098039, blue: 0.9960784314, alpha: 1)
    static let orange1 = UIColor(red: 0.8941176471, green: 0.5764705882, blue: 0.1176470588, alpha: 1)
    static let red1 = UIColor(red: 0.9647058824, green: 0.2745098039, blue: 0.2745098039, alpha: 1)
    static let red2 = UIColor(red: 1, green: 0.3450980392, blue: 0.3450980392, alpha: 1)
    
    //kypool
    static let pink1 = UIColor(red: 0.9960784314, green: 0.3176470588, blue: 0.5882352941, alpha: 1)
    static let pink2 = UIColor(red: 0.9254901961, green: 0.2862745098, blue: 0.5411764706, alpha: 1)
    static let red3 = UIColor(red: 0.9098039216, green: 0.3647058824, blue: 0.3058823529, alpha: 1)
    static let red4 = UIColor(red: 0.968627451, green: 0.4392156863, blue: 0.3843137255, alpha: 1)
    static let green1 = UIColor(red: 0, green: 0.8901960784, blue: 0.6823529412, alpha: 1)
    static let green2 = UIColor(red: 0.07843137255, green: 0.7960784314, blue: 0.6274509804, alpha: 1)
    static let blue3 = UIColor(red: 0.1450980392, green: 0.4588235294, blue: 0.9882352941, alpha: 1)
    static let blue4 = UIColor(red: 0.1450980392, green: 0.4274509804, blue: 0.9019607843, alpha: 1)
    
    //celestial
    static let green3 = UIColor(red: 0.1411764706, green: 0.8235294118, blue: 0.5725490196, alpha: 1)
    static let green4 = UIColor(red: 0.1215686275, green: 0.7725490196, blue: 0.5333333333, alpha: 1)
    static let purple2 = UIColor(red: 0.7607843137, green: 0.2941176471, blue: 0.7137254902, alpha: 1)
    static let purple3 = UIColor(red: 0.8352941176, green: 0.3450980392, blue: 0.7843137255, alpha: 1)
    static let blue5 = UIColor(red: 0.007843137255, green: 0.3137254902, blue: 0.7725490196, alpha: 1)
    static let blue6 = UIColor(red: 0.168627451, green: 0.3450980392, blue: 0.6078431373, alpha: 1)
    static let darkRed1 = UIColor(red: 0.7215686275, green: 0.2196078431, blue: 0.4823529412, alpha: 1)
    static let darkRed2 = UIColor(red: 0.831372549, green: 0.2470588235, blue: 0.5529411765, alpha: 1)
}

extension UIColor {

    func lighter(by percentage: CGFloat = 30.0) -> UIColor? {
        return self.adjust(by: abs(percentage) )
    }

    func darker(by percentage: CGFloat = 30.0) -> UIColor? {
        return self.adjust(by: -1 * abs(percentage) )
    }

    func adjust(by percentage: CGFloat = 30.0) -> UIColor? {
        var red: CGFloat = 0, green: CGFloat = 0, blue: CGFloat = 0, alpha: CGFloat = 0
        if self.getRed(&red, green: &green, blue: &blue, alpha: &alpha) {
            return UIColor(red: min(red + percentage/100, 1.0),
                           green: min(green + percentage/100, 1.0),
                           blue: min(blue + percentage/100, 1.0),
                           alpha: alpha)
        } else {
            return nil
        }
    }
}

class Colors {
    
    static var defaultColors = [UIColor.lightRed, UIColor.medRed, UIColor.lightOrange, UIColor.medOrange, UIColor.lightYellow, UIColor.medYellow, UIColor.lightGreen, UIColor.medGreen, UIColor.heavyGreen, UIColor.lightBlue, UIColor.medBlue, UIColor.lightPurple, UIColor.medPurple]
    static var defaultColorsStrings = ["lightRed", "medRed", "lightOrange", "medOrange", "lightYellow", "medYellow", "lightGreen", "medGreen", "heavyGreen", "lightBlue", "medBlue", "lightPurple", "medPurple"]
    
    static var sunsetColors = [UIColor.blue1, UIColor.blue2, UIColor.purple1, UIColor.lightBlue1, UIColor.lightBlue2, UIColor.orange1, UIColor.red1, UIColor.red2]
    static var sunsetColorsStrings = ["blue1", "blue2", "purple1", "lightBlue1", "lightBlue2", "orange1", "red1", "red2"]
    
    static var kypoolColors = [UIColor.pink1, UIColor.pink2, UIColor.red3, UIColor.red4, UIColor.green1, UIColor.green2, UIColor.blue3, UIColor.blue4]
    static var kypoolColorsStrings = ["pink1", "pink2", "red3", "red4", "green1", "green2", "blue3", "blue4"]
    
    static var celestialColors = [UIColor.green3, UIColor.green4, UIColor.purple2, UIColor.purple3, UIColor.blue5, UIColor.blue6, UIColor.darkRed1, UIColor.darkRed2]
    static var celestialColorsStrings = ["green3", "green4", "purple2", "purple3", "blue5", "blue6", "darkRed1", "darkRed2"]
    
    static var appleVibrantColors = [UIColor.systemRed, UIColor.systemBlue, UIColor.systemGreen, UIColor.systemPink, UIColor.systemOrange, UIColor.systemPurple, UIColor.systemTeal, UIColor.systemYellow]
    static var appleVibrantColorsStrings = ["systemRed", "systemBlue", "systemGreen", "systemPink", "systemOrange", "systemPurple", "systemTeal", "systemYellow"]
    
    static func stringFromColor(color: UIColor) -> String {
        
//        if UserDefaults.standard.string(forKey: "noteColorTheme") == "default" {
            if color == UIColor.lightRed {
                return "lightRed"
                
            } else if color == UIColor.medRed {
                return "medRed"
                
            } else if color == UIColor.lightOrange {
                return "lightOrange"
                
            } else if color == UIColor.medOrange {
                return "medOrange"
                
            } else if color == UIColor.lightYellow {
                return "lightYellow"
                
            } else if color == UIColor.medYellow {
                return "medYellow"
                
            } else if color == UIColor.lightGreen {
                return "lightGreen"
                
            } else if color == UIColor.medGreen {
                return "medGreen"
                
            } else if color == UIColor.heavyGreen {
                return "heavyGreen"
                
            } else if color == UIColor.lightBlue {
                return "lightBlue"
                
            } else if color == UIColor.medBlue {
                return "medBlue"
                
            } else if color == UIColor.lightPurple {
                return "lightPurple"
                
            } else if color == UIColor.medPurple {
                return "medPurple"
            }
        
            if color == UIColor.blue1 {
                return "blue1"
                
            } else if color == UIColor.blue2 {
                return "blue2"
                
            } else if color == UIColor.purple1 {
                return "purple1"
                
            } else if color == UIColor.lightBlue1 {
                return "lightBlue1"
                
            } else if color == UIColor.lightBlue2 {
                return "lightBlue2"
                
            } else if color == UIColor.orange1 {
                return "orange1"
                
            } else if color == UIColor.red1 {
                return "red1"
                
            } else if color == UIColor.red2 {
                return "red2"
            }

            if color == UIColor.pink1 {
                return "pink1"
                
            } else if color == UIColor.pink2 {
                return "pink2"
                
            } else if color == UIColor.red3 {
                return "red3"
                
            } else if color == UIColor.red4 {
                return "red4"
                
            } else if color == UIColor.green1 {
                return "green1"
                
            } else if color == UIColor.green2 {
                return "green2"
                
            } else if color == UIColor.blue3 {
                return "blue3"
                
            } else if color == UIColor.blue4 {
                return "blue4"
            }

            if color == UIColor.green3 {
                return "green3"
                
            } else if color == UIColor.green4 {
                return "green4"
                
            } else if color == UIColor.purple2 {
                return "purple2"
                
            } else if color == UIColor.purple3 {
                return "purple3"
                
            } else if color == UIColor.blue5 {
                return "blue5"
                
            } else if color == UIColor.blue6 {
                return "blue6"
                
            } else if color == UIColor.darkRed1 {
                return "darkRed1"
                
            } else if color == UIColor.darkRed2 {
                return "darkRed2"
            }

            if color == UIColor.systemTeal {
                return "systemTeal"
                
            } else if color == UIColor.systemGreen {
                return "systemGreen"
                
            } else if color == UIColor.systemRed {
                return "systemRed"
                
            } else if color == UIColor.systemBlue {
                return "systemBlue"
                
            } else if color == UIColor.systemPink {
                return "systemPink"
                
            } else if color == UIColor.systemOrange {
                return "systemOrange"
                
            } else if color == UIColor.systemPurple {
                return "systemPurple"
                
            } else if color == UIColor.systemTeal {
                return "systemTeal"
                
            } else if color == UIColor.systemYellow {
                return "systemYellow"
            }
        
        if UserDefaults.standard.bool(forKey: "useRandomColor") == false {
            return "staticNoteColor"
        }
        
        return "white"
    }
    
    static func colorFromString(string: String) -> UIColor {
        
            if string == "lightRed" {
                return UIColor.lightRed
                
            } else if string == "medRed" {
                return UIColor.medRed
                
            } else if string == "lightOrange" {
                return UIColor.lightOrange
                
            } else if string == "medOrange" {
                return UIColor.medOrange
                
            } else if string == "lightYellow" {
                return UIColor.lightYellow
                
            } else if string == "medYellow" {
                return UIColor.medYellow
                
            } else if string == "lightGreen" {
                return UIColor.lightGreen
                
            } else if string == "medGreen" {
                return UIColor.medGreen
                
            } else if string == "heavyGreen" {
                return UIColor.heavyGreen
                
            } else if string == "lightBlue" {
                return UIColor.lightBlue
                
            } else if string == "medBlue" {
                return UIColor.medBlue
                
            } else if string == "lightPurple" {
                return UIColor.lightPurple
                
            } else if string == "medPurple" {
                return UIColor.medPurple
            }
        
            if string == "blue1" {
                return UIColor.blue1
                
            } else if string == "blue2" {
                return UIColor.blue2
                
            } else if string == "purple1" {
                return UIColor.purple1
                
            } else if string == "lightBlue1" {
                return UIColor.lightBlue1
                
            } else if string == "lightBlue2" {
                return UIColor.lightBlue2
                
            } else if string == "orange1" {
                return UIColor.orange1
                
            } else if string == "red1" {
                return UIColor.red1
                
            } else if string == "red2" {
                return UIColor.red2
            }

            if string == "pink1" {
                return UIColor.pink1
                
            } else if string == "pink2" {
                return UIColor.pink2
                
            } else if string == "red3" {
                return UIColor.red3
                
            } else if string == "red4" {
                return UIColor.red4
                
            } else if string == "green1" {
                return UIColor.green1
                
            } else if string == "green2" {
                return UIColor.green2
                
            } else if string == "blue3" {
                return UIColor.blue3
                
            } else if string == "blue4" {
                return UIColor.blue4
            }

            if string == "green3" {
                return UIColor.green3
                
            } else if string == "green4" {
                return UIColor.green4
                
            } else if string == "purple2" {
                return UIColor.purple2
                
            } else if string == "purple3" {
                return UIColor.purple3
                
            } else if string == "blue5" {
                return UIColor.blue5
                
            } else if string == "blue6" {
                return UIColor.blue6
                
            } else if string == "darkRed1" {
                return UIColor.darkRed1
                
            } else if string == "darkRed2" {
                return UIColor.darkRed2
            }

            if string == "systemTeal" {
                return UIColor.systemTeal
                
            } else if string == "systemGreen" {
                return UIColor.systemGreen
                
            } else if string == "systemRed" {
                return UIColor.systemRed
                
            } else if string == "systemBlue" {
                return UIColor.systemBlue
                
            } else if string == "systemPink" {
                return UIColor.systemPink
                
            } else if string == "systemOrange" {
                return UIColor.systemOrange
                
            } else if string == "systemPurple" {
                return UIColor.systemPurple
                
            } else if string == "systemTeal" {
                return UIColor.systemTeal
                
            } else if string == "systemYellow" {
                return UIColor.systemYellow
            }
        
        if UserDefaults.standard.bool(forKey: "useRandomColor") == false {
            return UserDefaults.standard.color(forKey: "staticNoteColor") ?? UIColor.white
        }
        return UIColor.white
    }
    
}
