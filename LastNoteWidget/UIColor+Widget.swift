//
//  UIColor+Widget.swift
//  Jotify
//
//  Created by Harrison Leath on 12/9/20.
//  Copyright © 2020 Harrison Leath. All rights reserved.
//

import UIKit
import SwiftUI

extension UIColor {
    
    convenience init(r: CGFloat, g: CGFloat, b: CGFloat) {
        self.init(red: r / 255, green: g / 255, blue: b / 255, alpha: 1)
    }
    
    var suColor: Color { Color(self) }
    
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
}

class WidgetColorInterpretor {
    func colorFromString(string: String) -> Color {
//        if UserDefaults.standard.bool(forKey: "useRandomColor") == false {
//            return Color(UserDefaults.standard.color(forKey: "staticNoteColor") ?? .white)
//        }
        
        switch string {
        // theme - default
        case "lightRed":
            return Color(.lightRed)
        case "medRed":
            return Color(.medRed)
        case "lightOrange":
            return Color(.lightOrange)
        case "medOrange":
            return Color(.medOrange)
        case "lightYellow":
            return Color(.lightYellow)
        case "medYellow":
            return Color(.medYellow)
        case "lightGreen":
            return Color(.lightGreen)
        case "medGreen":
            return Color(.medGreen)
        case "heavyGreen":
            return Color(.heavyGreen)
        case "lightBlue":
            return Color(.lightBlue)
        case "medBlue":
            return Color(.medBlue)
        case "lightPurple":
            return Color(.lightPurple)
        case "medPurple": // also case "medPurple"
            return Color(.medPurple)
        // theme - sunset
        case "blue1":
            return Color(.blue1)
        case "blue2":
            return Color(.blue2)
        case "purple1":
            return Color(.purple1)
        case "lightBlue1":
            return Color(.lightBlue1)
        case "lightBlue2":
            return Color(.lightBlue2)
        case "orange1":
            return Color(.orange1)
        case "red1":
            return Color(.red1)
        case "red2": // also case "red2"
            return Color(.red2)
        // theme - kypool
        case "pink1":
            return Color(.pink1)
        case "pink2":
            return Color(.pink2)
        case "red3":
            return Color(.red3)
        case "red4":
            return Color(.red4)
        case "green1":
            return Color(.green1)
        case "green2":
            return Color(.green2)
        case "blue3":
            return Color(.blue3)
        case "blue4": // also case "blue4"
            return Color(.blue4)
        // theme - celestial
        case "green3":
            return Color(.green3)
        case "green4":
            return Color(.green4)
        case "purple2":
            return Color(.purple2)
        case "purple3":
            return Color(.purple3)
        case "blue5":
            return Color(.blue5)
        case "blue6":
            return Color(.blue6)
        case "darkRed1":
            return Color(.darkRed1)
        case "darkRed2": // also case "darkRed2"
            return Color(.darkRed2)
        // theme - scarletAzure
        case "dBlue":
            return Color(.dBlue)
        case "dRed":
            return Color(.dRed)
        case "dGold":
            return Color(.dGold)
        case "lBlue":
            return Color(.lBlue)
        case "lRed":
            return Color(.lRed)
        case "lGold":
            return Color(.lGold)
        // also case "appleVibrant"
        case "systemTeal":
            return Color(.systemTeal)
        case "systemGreen":
            return Color(.systemGreen)
        case "systemRed":
            return Color(.systemRed)
        case "systemBlue":
            return Color(.systemBlue)
        case "systemPink":
            return Color(.systemPink)
        case "systemOrange":
            return Color(.systemOrange)
        case "systemPurple":
            return Color(.systemPurple)
        case "systemYellow": // also case "systemYellow"
            return Color(.systemYellow)
        default: // also case "red2"
            return Color(.black)
        }
    }
}

