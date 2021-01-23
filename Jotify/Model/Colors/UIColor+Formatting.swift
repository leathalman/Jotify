//
//  Colors+Formatting.swift
//  Jotify
//
//  Created by Harrison Leath on 2/8/20.
//  Copyright © 2020 Harrison Leath. All rights reserved.
//

import UIKit

extension UIColor {
    
    static func stringFromColor(color: UIColor) -> String {
        
        if UserDefaults.standard.bool(forKey: "useRandomColor") == false {
            return "staticNoteColor"
        }
        
//        switch UserDefaults.standard.string(forKey: "noteColorTheme") {
//        case "default":
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
//            default: // also case .medPurple
//                return "medPurple"
//            }
//        case "sunset":
//            switch color {
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
//            default: // also case .red2
//                return "red2"
//            }
//        case "kypool":
//            switch color {
            // theme - kypool
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
//            default: // also case .blue4
//                return "blue4"
//            }
//        case "celestial":
//            switch color {
            // theme - celestial
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
//            default: // also case .darkRed2:
//                return "darkRed2"
//            }
//        case "scarletAzure":
//            switch color {
            // theme - scarletAzure
            case .dBlue:
                return "dBlue"
            case .dRed:
                return "dRed"
            case .dGold:
                return "dGold"
            case .lBlue:
                return "lBlue"
            case .lRed:
                return "lRed"
            case .lGold:
                return "lGold"
//            default: // also case "red2"
//                return "red2"
//            }
//        default: // also case "appleVibrant"
//            switch color {
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
//        }
    }
    
    static func colorFromString(string: String) -> UIColor {
        
        if UserDefaults.standard.bool(forKey: "useRandomColor") == false {
            return UserDefaults.standard.color(forKey: "staticNoteColor") ?? .white
        }
        
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
        // theme - kypool
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
        // theme - celestial
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
        // theme - scarletAzure
        case "dBlue":
            return .dBlue
        case "dRed":
            return .dRed
        case "dGold":
            return .dGold
        case "lBlue":
            return .lBlue
        case "lRed":
            return .lRed
        case "lGold":
            return .lGold
        // theme - appleVibrant
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
            return .blue2
        }
    }
}
