//
//  Colors+Formatting.swift
//  Jotify
//
//  Created by Harrison Leath on 2/8/20.
//  Copyright © 2020 Harrison Leath. All rights reserved.
//

import UIKit

extension Colors {
    
    static func stringFromColor(color: UIColor) -> String {
        if color == lightRed {
            return "lightRed"
            
        } else if color == medRed {
            return "medRed"
            
        } else if color == lightOrange {
            return "lightOrange"
            
        } else if color == medOrange {
            return "medOrange"
            
        } else if color == lightYellow {
            return "lightYellow"
            
        } else if color == medYellow {
            return "medYellow"
            
        } else if color == lightGreen {
            return "lightGreen"
            
        } else if color == medGreen {
            return "medGreen"
            
        } else if color == heavyGreen {
            return "heavyGreen"
            
        } else if color == lightBlue {
            return "lightBlue"
            
        } else if color == medBlue {
            return "medBlue"
            
        } else if color == lightPurple {
            return "lightPurple"
            
        } else if color == medPurple {
            return "medPurple"
        }
        
        if color == blue1 {
            return "blue1"
            
        } else if color == blue2 {
            return "blue2"
            
        } else if color == purple1 {
            return "purple1"
            
        } else if color == lightBlue1 {
            return "lightBlue1"
            
        } else if color == lightBlue2 {
            return "lightBlue2"
            
        } else if color == orange1 {
            return "orange1"
            
        } else if color == red1 {
            return "red1"
            
        } else if color == red2 {
            return "red2"
        }
        
        if color == pink1 {
            return "pink1"
            
        } else if color == pink2 {
            return "pink2"
            
        } else if color == red3 {
            return "red3"
            
        } else if color == red4 {
            return "red4"
            
        } else if color == green1 {
            return "green1"
            
        } else if color == green2 {
            return "green2"
            
        } else if color == blue3 {
            return "blue3"
            
        } else if color == blue4 {
            return "blue4"
        }
        
        if color == green3 {
            return "green3"
            
        } else if color == green4 {
            return "green4"
            
        } else if color == purple2 {
            return "purple2"
            
        } else if color == purple3 {
            return "purple3"
            
        } else if color == blue5 {
            return "blue5"
            
        } else if color == blue6 {
            return "blue6"
            
        } else if color == darkRed1 {
            return "darkRed1"
            
        } else if color == darkRed2 {
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
        
        if color == lGold {
            return "lGold"
            
        } else if color == dBlue {
            return "dBlue"
            
        } else if color == lRed {
            return "lRed"
            
        } else if color == lBlue {
            return "lBlue"
            
        } else if color == dRed {
            return "dRed"
            
        } else if color == dGold {
            return "dGold"
        }
        
        if UserDefaults.standard.bool(forKey: "useRandomColor") == false {
            return "staticNoteColor"
        }
        
        return "blue2"
    }
    
    static func colorFromString(string: String) -> UIColor {
        if string == "lightRed" {
            return lightRed
            
        } else if string == "medRed" {
            return medRed
            
        } else if string == "lightOrange" {
            return lightOrange
            
        } else if string == "medOrange" {
            return medOrange
            
        } else if string == "lightYellow" {
            return lightYellow
            
        } else if string == "medYellow" {
            return medYellow
            
        } else if string == "lightGreen" {
            return lightGreen
            
        } else if string == "medGreen" {
            return medGreen
            
        } else if string == "heavyGreen" {
            return heavyGreen
            
        } else if string == "lightBlue" {
            return lightBlue
            
        } else if string == "medBlue" {
            return medBlue
            
        } else if string == "lightPurple" {
            return lightPurple
            
        } else if string == "medPurple" {
            return medPurple
        }
        
        if string == "blue1" {
            return blue1
            
        } else if string == "blue2" {
            return blue2
            
        } else if string == "purple1" {
            return purple1
            
        } else if string == "lightBlue1" {
            return lightBlue1
            
        } else if string == "lightBlue2" {
            return lightBlue2
            
        } else if string == "orange1" {
            return orange1
            
        } else if string == "red1" {
            return red1
            
        } else if string == "red2" {
            return red2
        }
        
        if string == "pink1" {
            return pink1
            
        } else if string == "pink2" {
            return pink2
            
        } else if string == "red3" {
            return red3
            
        } else if string == "red4" {
            return red4
            
        } else if string == "green1" {
            return green1
            
        } else if string == "green2" {
            return green2
            
        } else if string == "blue3" {
            return blue3
            
        } else if string == "blue4" {
            return blue4
        }
        
        if string == "green3" {
            return green3
            
        } else if string == "green4" {
            return green4
            
        } else if string == "purple2" {
            return purple2
            
        } else if string == "purple3" {
            return purple3
            
        } else if string == "blue5" {
            return blue5
            
        } else if string == "blue6" {
            return blue6
            
        } else if string == "darkRed1" {
            return darkRed1
            
        } else if string == "darkRed2" {
            return darkRed2
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
        
        if string == "lGold" {
            return lGold
            
        } else if string == "dBlue" {
            return dBlue
            
        } else if string == "lRed" {
            return lRed
            
        } else if string == "lBlue" {
            return lBlue
            
        } else if string == "dRed" {
            return dRed
            
        } else if string == "dGold" {
            return dGold
        }
        
        if UserDefaults.standard.bool(forKey: "useRandomColor") == false {
            return UserDefaults.standard.color(forKey: "staticNoteColor") ?? UIColor.white
        }
        return blue2
    }
}
