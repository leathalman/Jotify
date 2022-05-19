//
//  GradientThemes.swift
//  Jotify
//
//  Created by Harrison Leath on 6/20/21.
//

import UIKit

@objc public enum GradientThemes: Int {
    case sunset
    case sunrise
    case minoas
    case eros
    case olympia
    case caelestibus
    case kyoopal
    case caeruleum
    case All
    
    public func colors() -> [UIColor] {
        switch self {
        case .sunset:
            return [.sunset1, .sunset2, .sunset3]
        case .minoas:
            return [.minoas1, .minoas2, .minoas3, .minoas4]
        case .sunrise:
            return [.sunrise1, .sunrise2, .sunrise3, .sunrise4]
        case .eros:
            return [.eros1, .eros2, .eros3]
        case .olympia:
            return [.olympia1, .olympia2, .olympia3, .olympia4]
        case .caelestibus:
            return [.caelestibus1, .caelestibus2, .caelestibus3, .caelestibus4]
        case .kyoopal:
            return [.kypool1, .kypool2, .kypool3, .kypool4,]
        case .caeruleum:
            return [.caeruleum1, .caeruleum2, .caeruleum3, .caeruleum4]
        case .All:
            return [.sunset1, .sunset2, .sunset3, .minoas1, .minoas2, .minoas3, .minoas4, .sunrise1, .sunrise2, .sunrise3, .sunrise4, .eros1, .eros2, .eros3, .olympia1, .olympia2, .olympia3, .olympia4, .caelestibus1, .caelestibus2, .caelestibus3, .caelestibus4, .kypool1, .kypool2, .kypool3, .kypool4, .caeruleum1, .caeruleum2, .caeruleum3, .caeruleum4]
        }
    }
}

extension UIColor {
    //MISC: dark-greyish
    static let mineShaft = UIColor(r: 40, g: 40, b: 40)
    static let lightTrail = UIColor(r: 239, g: 243, b: 244)
    static let gainsboro = UIColor(hex: "#E8ECED")
    static let almostWhite = UIColor(r: 254, g: 254, b: 254)
    
    //sunset - https://coolors.co/ffa17f-42434f-00223e
    static let sunset1 = UIColor(hex: "FFA17F")
    static let sunset2 = UIColor(hex: "42434F")
    static let sunset3 = UIColor(hex: "00223E")
    
    //minoas - https://coolors.co/ff1b6b-b561a6-888bca-45caff
    static let minoas1 = UIColor(hex: "#FF1B6B")
    static let minoas2 = UIColor(hex: "#B561A6")
    static let minoas3 = UIColor(hex: "#888BCA")
    static let minoas4 = UIColor(hex: "#0084B8")
    
    //sunrise - https://coolors.co/f4c152-f5a782-f49180-e92027
    static let sunrise1 = UIColor(hex: "#F4C152")
    static let sunrise2 = UIColor(hex: "#F5A782")
    static let sunrise3 = UIColor(hex: "#F49180")
    static let sunrise4 = UIColor(hex: "#E92027")
    
    //eros - https://coolors.co/22c1c3-5fbf99-fdbb2d
    static let eros1 = UIColor(hex: "#22c1c3")
    static let eros2 = UIColor(hex: "#5fbf99")
    static let eros3 = UIColor(hex: "#fdbb2d")
    
    //olympia - https://coolors.co/432371-8a5975-cf8e79-faae7b
    static let olympia1 = UIColor(hex: "#432371")
    static let olympia2 = UIColor(hex: "#8A5975")
    static let olympia3 = UIColor(hex: "#CF8E79")
    static let olympia4 = UIColor(hex: "#FAAE7B")
    
    //caelestibus
    static let caelestibus1 = #colorLiteral(red: 0.007843137255, green: 0.3137254902, blue: 0.7725490196, alpha: 1)
    static let caelestibus2 = #colorLiteral(red: 0.168627451, green: 0.3450980392, blue: 0.6078431373, alpha: 1)
    static let caelestibus3 = #colorLiteral(red: 0.7215686275, green: 0.2196078431, blue: 0.4823529412, alpha: 1)
    static let caelestibus4 = #colorLiteral(red: 0.831372549, green: 0.2470588235, blue: 0.5529411765, alpha: 1)
    
    //kypool
    static let kypool1 = #colorLiteral(red: 0.1411764706, green: 0.8235294118, blue: 0.5725490196, alpha: 1)
    static let kypool2 = #colorLiteral(red: 0.1215686275, green: 0.7725490196, blue: 0.5333333333, alpha: 1)
    static let kypool3 = #colorLiteral(red: 0.7607843137, green: 0.2941176471, blue: 0.7137254902, alpha: 1)
    static let kypool4 = #colorLiteral(red: 0.8352941176, green: 0.3450980392, blue: 0.7843137255, alpha: 1)

    //caeruleum - https://coolors.co/030034-024273-019fcc-00d4ff
    static let caeruleum1 = UIColor(hex: "#030034")
    static let caeruleum2 = UIColor(hex: "#024273")
    static let caeruleum3 = UIColor(hex: "#019fcc")
    static let caeruleum4 = UIColor(hex: "#00d4ff")
    
    //MISC Colors
    static let jotifyGray = UIColor(red: 239 / 255, green: 240 / 255, blue: 241 / 255, alpha: 1)
    static let jotifyBlue = UIColor(red: 70 / 255, green: 108 / 255, blue: 139 / 255, alpha: 1)

}
