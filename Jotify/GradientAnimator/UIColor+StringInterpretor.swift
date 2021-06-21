//
//  UIColor+StringInterpretor.swift
//  Jotify
//
//  Created by Harrison Leath on 6/21/21.
//

import UIKit

extension UIColor {
    
    func getNewString() -> String {
        switch self {
        //sunrise
        case .sunrise1: return "sunrise1"
        case .sunrise2: return "sunrise2"
        case .sunrise3: return "sunrise3"
        case .sunrise4: return "sunrise4"
        
        //amin
        case .amin1: return "amin1"
        case .amin2: return "amin2"
        case .amin3: return "amin3"
        case .amin4: return "amin4"
        
        //maldives
        case .maldives1: return "maldives1"
        case .maldives2: return "maldives2"
        case .maldives3: return "maldives3"
        case .maldives4: return "maldives4"
            
        //neonlife
        case .neonlife1: return "neonlife1"
        case .neonlife2: return "neonlife2"
        case .neonlife3: return "neonlife3"
            
        //bluelagoon
        case .bluelagoon1: return "bluelagoon1"
        case .bluelagoon2: return "bluelagoon2"
        case .bluelagoon3: return "bluelagoon3"
        case .bluelagoon4: return "bluelagoon4"
            
        //celestrial
        case .celestrial1: return "celestrial1"
        case .celestrial2: return "celestrial2"
        case .celestrial3: return "celestrial3"
        case .celestrial4: return "celestrial4"
            
        //kypool
        case .kypool1: return "kypool1"
        case .kypool2: return "kypool2"
        case .kypool3: return "kypool3"
        case .kypool4: return "kypool4"
            
        //solidstone
        case .solidstone1: return "solidstone1"
        case .solidstone2: return "solidstone2"
        case .solidstone3: return "solidstone3"
        case .solidstone4: return "solidstone4"
            
        //error
        default: return "systemBlue"
        }
    }
}

extension String {
    
    func getNewColor() -> UIColor {
        switch self {
        //sunrise
        case "sunrise1": return .sunrise1
        case "sunrise2": return .sunrise2
        case "sunrise3": return .sunrise3
        case "sunrise4": return .sunrise4
            
        //amin
        case "amin1": return .amin1
        case "amin2": return .amin2
        case "amin3": return .amin3
        case "amin4": return .amin4
        
        //maldives
        case "maldives1": return .maldives1
        case "maldives2": return .maldives2
        case "maldives3": return .maldives3
        case "maldives4": return .maldives4
            
        //neonlife
        case "neonlife1": return .neonlife1
        case "neonlife2": return .neonlife2
        case "neonlife3": return .neonlife3
            
        //bluelagoon
        case "bluelagoon1": return .bluelagoon1
        case "bluelagoon2": return .bluelagoon2
        case "bluelagoon3": return .bluelagoon3
        case "bluelagoon4": return .bluelagoon4
            
        //celestrial
        case "celestrial1": return .celestrial1
        case "celestrial2": return .celestrial2
        case "celestrial3": return .celestrial3
        case "celestrial4": return .celestrial4
            
        //kypool
        case "kypool1": return .kypool1
        case "kypool2": return .kypool2
        case "kypool3": return .kypool3
        case "kypool4": return .kypool4
            
        //solidstone
        case "solidstone1": return .solidstone1
        case "solidstone2": return .solidstone2
        case "solidstone3": return .solidstone3
        case "solidstone4": return .solidstone4
            
        //error
        default: return .systemBlue
        }
    }
}
