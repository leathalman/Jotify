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
        //default v2
        case "geranium": return .geranium
        case "chineseViolet": return .chineseViolet
        case "viridian": return .viridian
        case "tealBlue": return .tealBlue
        case "spanishOrange": return .spanishOrange
        case "gamboge": return .gamboge
        case "rose": return .rose
        case "cornflower": return .cornflower
        //kypool
        case "fuchsia": return .fuchsia
        case "fuchsiaPlus": return .fuchsiaPlus
        case "fireOpal": return .fireOpal
        case "fireOpalPlus": return .fireOpalPlus
        case "aquamarine": return .aquamarine
        case "aquamarinePlus": return .aquamarinePlus
        case "blueCrayola": return .blueCrayola
        case "blueCrayolaPlus": return .blueCrayolaPlus
        //error
        default: return .systemBlue
        }
    }
    
    //take self(string) and return a color array from themes in CustomColors.swift
    func getColorArray() -> Array<UIColor> {
        switch self {
        case "Default": return UIColor.defaultTheme
        case "Kypool": return UIColor.kypoolTheme
        default:
            return UIColor.defaultTheme
        }
    }
}

extension UIColor {
    
    func getString() -> String {
        switch self {
        //default v2
        case .geranium: return "geranium"
        case .chineseViolet: return "chineseViolet"
        case .viridian: return "viridian"
        case .tealBlue: return "tealBlue"
        case .spanishOrange: return "spanishOrange"
        case .gamboge: return "gamboge"
        case .rose: return "rose"
        case .cornflower: return "cornflower"
        //kypool
        case .fuchsia: return "fuchsia"
        case .fuchsiaPlus: return "fuchsiaPlus"
        case .fireOpal: return "fireOpal"
        case .fireOpalPlus: return "fireOpalPlus"
        case .aquamarine: return "aquamarine"
        case .aquamarinePlus: return "aquamarinePlus"
        case .blueCrayola: return "blueCrayola"
        case .blueCrayolaPlus: return "blueCrayolaPlus"
        //error
        default: return "systemBlue"
        }
    }
}
