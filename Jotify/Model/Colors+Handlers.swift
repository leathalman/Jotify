//
//  Colors+Handlers.swift
//  Jotify
//
//  Created by Harrison Leath on 6/30/19.
//  Copyright © 2019 Harrison Leath. All rights reserved.
//

import UIKit

struct StoredColors {
    static var noteColor = UIColor()
    static var noteColorString = String()
    static var staticNoteColor = UIColor()
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

    func lighter(by percentage: CGFloat = 30.0) -> UIColor? {
        return self.adjust(by: abs(percentage))
    }

    func darker(by percentage: CGFloat = 30.0) -> UIColor? {
        return self.adjust(by: -1 * abs(percentage))
    }

    func adjust(by percentage: CGFloat = 30.0) -> UIColor? {
        var red: CGFloat = 0, green: CGFloat = 0, blue: CGFloat = 0, alpha: CGFloat = 0
        if self.getRed(&red, green: &green, blue: &blue, alpha: &alpha) {
            return UIColor(red: min(red + percentage/100, 1.0),
                           green: min(green + percentage/100, 1.0),
                           blue: min(blue + percentage/100, 1.0),
                           alpha: alpha)
        }
        return nil
    }
}

class Colors {
    
    static var defaultColors = [UIColor.lightRed, .medRed, .lightOrange, .medOrange, .lightYellow, .medYellow, .lightGreen, .medGreen, .heavyGreen, .lightBlue, .medBlue, .lightPurple, .medPurple]
    static var defaultColorsStrings = ["lightRed", "medRed", "lightOrange", "medOrange", "lightYellow", "medYellow", "lightGreen", "medGreen", "heavyGreen", "lightBlue", "medBlue", "lightPurple", "medPurple"]
    
    static var sunsetColors = [UIColor.blue1, .blue2, .purple1, .lightBlue1, .lightBlue2, .orange1, .red1, .red2]
    static var sunsetColorsStrings = ["blue1", "blue2", "purple1", "lightBlue1", "lightBlue2", "orange1", "red1", "red2"]
    
    static var kypoolColors = [UIColor.pink1, .pink2, .red3, .red4, .green1, .green2, .blue3, .blue4]
    static var kypoolColorsStrings = ["pink1", "pink2", "red3", "red4", "green1", "green2", "blue3", "blue4"]
    
    static var celestialColors = [UIColor.green3, .green4, .purple2, .purple3, .blue5, .blue6, .darkRed1, .darkRed2]
    static var celestialColorsStrings = ["green3", "green4", "purple2", "purple3", "blue5", "blue6", "darkRed1", "darkRed2"]
    
    static var appleVibrantColors = [UIColor.systemRed, .systemBlue, .systemGreen, .systemPink, .systemOrange, .systemPurple, .systemTeal, .systemYellow]
    static var appleVibrantColorsStrings = ["systemRed", "systemBlue", "systemGreen", "systemPink", "systemOrange", "systemPurple", "systemTeal", "systemYellow"]
    
    static func stringFromColor(color: UIColor) -> String {
        
        if UserDefaults.standard.bool(forKey: "useRandomColor") == false {
            return "staticNoteColor"
        }
        
        switch UserDefaults.standard.string(forKey: "noteColorTheme") {
        case "default":
            switch color {
            // theme - default
            case .lightRed:
                return "lightRed"
            case .medRed:
                return "medRed"
            case .lightOrange:
                return "lightOrange"
            case .medOrange:
                return "medOrange"
            case .lightYellow:
                return "lightYellow"
            case .medYellow:
                return "medYellow"
            case .lightGreen:
                return "lightGreen"
            case .medGreen:
                return "medGreen"
            case .heavyGreen:
                return "heavyGreen"
            case .lightBlue:
                return "lightBlue"
            case .medBlue:
                return "medBlue"
            case .lightPurple:
                return "lightPurple"
            default: // also case .medPurple
                return "medPurple"
            }
        case "sunset":
            switch color {
            // theme - sunset
            case .blue1:
                return "blue1"
            case .blue2:
                return "blue2"
            case .purple1:
                return "purple1"
            case .lightBlue1:
                return "lightBlue1"
            case .lightBlue2:
                return "lightBlue2"
            case .orange1:
                return "orange1"
            case .red1:
                return "red1"
            default: // also case .red2
                return "red2"
            }
        case "kypool":
            switch color {
            case .pink1:
                return "pink1"
            case .pink2:
                return "pink2"
            case .red3:
                return "red3"
            case .red4:
                return "red4"
            case .green1:
                return "green1"
            case .green2:
                return "green2"
            case .blue3:
                return "blue3"
            default: // also case .blue4
                return "blue4"
            }
        case "celestial":
            switch color {
            case .green3:
                return "green3"
            case .green4:
                return "green4"
            case .purple2:
                return "purple2"
            case .purple3:
                return "purple3"
            case .blue5:
                return "blue5"
            case .blue6:
                return "blue6"
            case .darkRed1:
                return "darkRed1"
            default: // also case .darkRed2:
                return "darkRed2"
            }
        default: // also case "appleVibrant"
            switch color {
            case .systemTeal:
                return "systemTeal"
            case .systemGreen:
                return "systemGreen"
            case .systemRed:
                return "systemRed"
            case .systemBlue:
                return "systemBlue"
            case .systemPink:
                return "systemPink"
            case .systemOrange:
                return "systemOrange"
            case .systemPurple:
                return "systemPurple"
            case .systemTeal:
                return "systemTeal"
            default: // also case .systemYellow
                return "systemYellow"
            }
        }
    }
    
    static func colorFromString(string: String) -> UIColor {
        
        if UserDefaults.standard.bool(forKey: "useRandomColor") == false {
            return UserDefaults.standard.color(forKey: "staticNoteColor") ?? .white
        }
        
        switch UserDefaults.standard.string(forKey: "noteColorTheme") {
        case "default":
            switch string {
            // theme - default
            case "lightRed":
                return .lightRed
            case "medRed":
                return .medRed
            case "lightOrange":
                return .lightOrange
            case "medOrange":
                return .medOrange
            case "lightYellow":
                return .lightYellow
            case "medYellow":
                return .medYellow
            case "lightGreen":
                return .lightGreen
            case "medGreen":
                return .medGreen
            case "heavyGreen":
                return .heavyGreen
            case "lightBlue":
                return .lightBlue
            case "medBlue":
                return .medBlue
            case "lightPurple":
                return .lightPurple
            default: // also case "medPurple"
                return .medPurple
            }
        case "sunset":
            switch string {
            // theme - sunset
            case "blue1":
                return .blue1
            case "blue2":
                return .blue2
            case "purple1":
                return .purple1
            case "lightBlue1":
                return .lightBlue1
            case "lightBlue2":
                return .lightBlue2
            case "orange1":
                return .orange1
            case "red1":
                return .red1
            default: // also case "red2"
                return .red2
            }
        case "kypool":
            switch string {
            case "pink1":
                return .pink1
            case "pink2":
                return .pink2
            case "red3":
                return .red3
            case "red4":
                return .red4
            case "green1":
                return .green1
            case "green2":
                return .green2
            case "blue3":
                return .blue3
            default: // also case "blue4"
                return .blue4
            }
        case "celestial":
            switch string {
            case "green3":
                return .green3
            case "green4":
                return .green4
            case "purple2":
                return .purple2
            case "purple3":
                return .purple3
            case "blue5":
                return .blue5
            case "blue6":
                return .blue6
            case "darkRed1":
                return .darkRed1
            default: // also case "darkRed2"
                return .darkRed2
            }
        default: // also case "appleVibrant"
            switch string {
            case "systemTeal":
                return .systemTeal
            case "systemGreen":
                return .systemGreen
            case "systemRed":
                return .systemRed
            case "systemBlue":
                return .systemBlue
            case "systemPink":
                return .systemPink
            case "systemOrange":
                return .systemOrange
            case "systemPurple":
                return .systemPurple
            default: // also case "systemYellow"
                return .systemYellow
            }
        }
    }
}
