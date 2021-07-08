//
//  UIColor+StringInterpretor.swift
//  Jotify
//
//  Created by Harrison Leath on 6/21/21.
//

import UIKit

extension UIColor {
    
    func getString() -> String {
        switch self {
        //sunset
        case .sunset1: return "sunset1"
        case .sunset2: return "sunset2"
        case .sunset3: return "sunset3"
        
        //minoas
        case .minoas1: return "minoas1"
        case .minoas2: return "minoas2"
        case .minoas3: return "minoas3"
        case .minoas4: return "minoas4"
        
        //sunrise
        case .sunrise1: return "sunrise1"
        case .sunrise2: return "sunrise2"
        case .sunrise3: return "sunrise3"
        case .sunrise4: return "sunrise4"
            
        //eros
        case .eros1: return "eros1"
        case .eros2: return "eros2"
        case .eros3: return "eros3"
            
        //olympia
        case .olympia1: return "olympia1"
        case .olympia2: return "olympia2"
        case .olympia3: return "olympia3"
        case .olympia4: return "olympia4"
            
        //caelestibus
        case .caelestibus1: return "caelestibus1"
        case .caelestibus2: return "caelestibus2"
        case .caelestibus3: return "caelestibus3"
        case .caelestibus4: return "caelestibus4"
            
        //kypool
        case .kypool1: return "kypool1"
        case .kypool2: return "kypool2"
        case .kypool3: return "kypool3"
        case .kypool4: return "kypool4"
            
        //caeruleum
        case .caeruleum1: return "caeruleum1"
        case .caeruleum2: return "caeruleum2"
        case .caeruleum3: return "caeruleum3"
        case .caeruleum4: return "caeruleum4"
            
        //error
        default: return "systemBlue"
        }
    }
}

extension String {
    
    func getColor() -> UIColor {
        switch self {
        //sunset
        case "sunset1": return .sunset1
        case "sunset2": return .sunset2
        case "sunset3": return .sunset3
            
        //minoas
        case "minoas1": return .minoas1
        case "minoas2": return .minoas2
        case "minoas3": return .minoas3
        case "minoas4": return .minoas4
        
        //sunrise
        case "sunrise1": return .sunrise1
        case "sunrise2": return .sunrise2
        case "sunrise3": return .sunrise3
        case "sunrise4": return .sunrise4
            
        //eros
        case "eros1": return .eros1
        case "eros2": return .eros2
        case "eros3": return .eros3
            
        //olympia
        case "olympia1": return .olympia1
        case "olympia2": return .olympia2
        case "olympia3": return .olympia3
        case "olympia4": return .olympia4
            
        //caelestibus
        case "caelestibus1": return .caelestibus1
        case "caelestibus2": return .caelestibus2
        case "caelestibus3": return .caelestibus3
        case "caelestibus4": return .caelestibus4
            
        //kypool
        case "kypool1": return .kypool1
        case "kypool2": return .kypool2
        case "kypool3": return .kypool3
        case "kypool4": return .kypool4
            
        //caeruleum
        case "caeruleum1": return .caeruleum1
        case "caeruleum2": return .caeruleum2
        case "caeruleum3": return .caeruleum3
        case "caeruleum4": return .caeruleum4
            
        //error
        default: return .systemBlue
        }
    }
}
