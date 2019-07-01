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

class Colors {
    
    static var softColors = [UIColor.lightRed, UIColor.medRed, UIColor.lightOrange, UIColor.medOrange, UIColor.medGreen, UIColor.heavyGreen, UIColor.lightBlue, UIColor.medBlue, UIColor.lightPurple, UIColor.medPurple, UIColor.heavyPurple]
    static var softColorNames = ["lightRed", "medRed", "lightOrange", "medOrange", "medGreen", "heavyGreen", "lightBlue", "medBlue", "lightPurple", "medPurple", "heavyPurple"]
    
    static func stringFromColor(color: UIColor) -> String {
        
        if color == UIColor.lightRed {
            return "lightRed"
            
        } else if color == UIColor.medRed {
            return "medRed"
            
        } else if color == UIColor.lightOrange {
            return "lightOrange"
            
        } else if color == UIColor.medOrange {
            return"medOrange"
            
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
            
        } else if color == UIColor.heavyPurple {
            return "heavyPurple"
            
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

        } else if string == "heavyPurple" {
            return UIColor.heavyPurple

        } else {
            return UIColor.white
        }
    }

    
}
