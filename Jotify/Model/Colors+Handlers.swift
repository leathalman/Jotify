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
}

extension UIColor {
    convenience init(r: CGFloat, g: CGFloat, b: CGFloat) {
        self.init(red: r/255, green: g/255, blue: b/255, alpha: 1)
    }
    
    static let lightRed = UIColor(r: 254, g: 129, b: 118)
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
    
}

class Colors {
    
    static var softColors = [UIColor.lightRed, UIColor.medRed, UIColor.lightOrange, UIColor.medOrange, UIColor.lightYellow, UIColor.medYellow, UIColor.lightGreen, UIColor.medGreen, UIColor.heavyGreen, UIColor.lightBlue, UIColor.medBlue, UIColor.lightPurple, UIColor.medPurple]
    static var softColorNames = ["lightRed", "medRed", "lightOrange", "medOrange", "lightYellow", "medYellow", "lightGreen", "medGreen", "heavyGreen", "lightBlue", "medBlue", "lightPurple", "medPurple"]
    
    static func stringFromColor(color: UIColor) -> String {
        
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
            
        } else {
            return "white"
        }
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

        } else {
            return UIColor.white
        }
    }

    
}
