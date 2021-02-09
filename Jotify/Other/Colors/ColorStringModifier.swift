//
//  ColorStringModifier.swift
//  Jotify
//
//  Created by Harrison Leath on 2/3/21.
//

import UIKit

extension String {
    
    func getColor() -> UIColor {
        switch self {
        // theme - default
        case "medRed":
            return .medRed
        case "medOrange":
            return .medOrange
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
        case "medPurple":
            return .medPurple
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
        case "geranium": return .geranium
        case "chineseViolet": return .chineseViolet
        case "viridian": return .viridian
        case "tealBlue": return .tealBlue
        case "spanishOrange": return .spanishOrange
        case "gamboge": return .gamboge
        case "rose": return .rose
        case "cornflower": return .cornflower
        default: // also case "systemYellow"
            return .blue2
        }
    }
    
    //take self(string) and return a color array from themes in CustomColors.swift
    func getColorArray() -> Array<UIColor> {
        switch self {
        case "Default":
            return UIColor.defaultColors
        case "Sunset":
            return UIColor.sunsetColors
        case "Kypool":
            return UIColor.kypoolColors
        case "Celestial":
            return UIColor.celestialColors
        case "Apple Vibrant":
            return UIColor.appleVibrantColors
        case "Scarlet Azure":
            return UIColor.scarletAzureColors
        case "New Default": return UIColor.newDefault
        default:
            return UIColor.defaultColors
        }
    }
}

extension UIColor {
    
    func getString() -> String {
        switch self {
        // theme - default
        case .medRed:
            return "medRed"
        case .medOrange:
            return "medOrange"
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
        case .medPurple:
            return "medPurple"
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
        // theme - appleVibrant
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
        case .geranium: return "geranium"
        case .chineseViolet: return "chineseViolet"
        case .viridian: return "viridian"
        case .tealBlue: return "tealBlue"
        case .spanishOrange: return "spanishOrange"
        case .gamboge: return "gamboge"
        case .rose: return "rose"
        case .cornflower: return "cornflower"
        default: // also case .systemYellow
            return "systemYellow"
        }
    }
}
