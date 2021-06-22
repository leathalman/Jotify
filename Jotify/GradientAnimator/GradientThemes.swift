//
//  GradientThemes.swift
//  Jotify
//
//  Created by Harrison Leath on 6/20/21.
//

import UIKit

@objc public enum GradientThemes: Int {
    case Sunrise
    case Maldives
    case Amin
    case NeonLife
    case BlueLagoon
    case Celestial
    case Kyoopal
    case SolidStone
    case All
    
    public func colors() -> [UIColor] {
        switch self {
        case .Sunrise:
            return [.sunrise1, .sunrise2, .sunrise3]
        case .Amin:
            return [.amin1, .amin2, .amin3, .amin4]
        case .Maldives:
            return [.maldives1, .maldives2, .maldives3, .maldives4]
        case .NeonLife:
            return [.neonlife1, .neonlife2, .neonlife3]
        case .BlueLagoon:
            return [.bluelagoon1, .bluelagoon2, .bluelagoon3, .bluelagoon4]
        case .Celestial:
            return [.celestrial1, .celestrial2, .celestrial3, .celestrial4]
        case .Kyoopal:
            return [.kypool1, .kypool2, .kypool3, .kypool4,]
        case .SolidStone:
            return [.solidstone1, .solidstone2, .solidstone3, .solidstone4]
        case .All:
            return [.sunrise1, .sunrise2, .sunrise3, .amin1, .amin2, .amin3, .amin4, .maldives1, .maldives2, .maldives3, .maldives4, .neonlife1, .neonlife2, .neonlife3, .bluelagoon1, .bluelagoon2, .bluelagoon3, .bluelagoon4, .celestrial1, .celestrial2, .celestrial3, .celestrial4, .kypool1, .kypool2, .kypool3, .kypool4, .solidstone1, .solidstone2, .solidstone3, .solidstone4]
        }
    }
}

extension UIColor {
    //MISC: dark-greyish
    static let mineShaft = UIColor(r: 40, g: 40, b: 40)
    static let lightTrail = UIColor(r: 239, g: 243, b: 244)
    static let gainsboro = UIColor(hex: "#E8ECED")
    
    //sunrise - https://coolors.co/ffa17f-42434f-00223e
    static let sunrise1 = UIColor(hex: "FFA17F")
    static let sunrise2 = UIColor(hex: "42434F")
    static let sunrise3 = UIColor(hex: "00223E")
    
    //amin - https://coolors.co/ff1b6b-b561a6-888bca-45caff
    static let amin1 = UIColor(hex: "#FF1B6B")
    static let amin2 = UIColor(hex: "#B561A6")
    static let amin3 = UIColor(hex: "#888BCA")
    static let amin4 = UIColor(hex: "#0084B8")
    
    //maldives - https://coolors.co/f4c152-f5a782-f49180-e92027
    static let maldives1 = UIColor(hex: "#F4C152")
    static let maldives2 = UIColor(hex: "#F5A782")
    static let maldives3 = UIColor(hex: "#F49180")
    static let maldives4 = UIColor(hex: "#E92027")
    
    //neonlife - https://coolors.co/22c1c3-5fbf99-fdbb2d
    static let neonlife1 = UIColor(hex: "#22c1c3")
    static let neonlife2 = UIColor(hex: "#5fbf99")
    static let neonlife3 = UIColor(hex: "#fdbb2d")
    
    //bluelagoon - https://coolors.co/432371-8a5975-cf8e79-faae7b
    static let bluelagoon1 = UIColor(hex: "#432371")
    static let bluelagoon2 = UIColor(hex: "#8A5975")
    static let bluelagoon3 = UIColor(hex: "#CF8E79")
    static let bluelagoon4 = UIColor(hex: "#FAAE7B")
    
    //celestial
    static let celestrial1 = #colorLiteral(red: 0.007843137255, green: 0.3137254902, blue: 0.7725490196, alpha: 1)
    static let celestrial2 = #colorLiteral(red: 0.168627451, green: 0.3450980392, blue: 0.6078431373, alpha: 1)
    static let celestrial3 = #colorLiteral(red: 0.7215686275, green: 0.2196078431, blue: 0.4823529412, alpha: 1)
    static let celestrial4 = #colorLiteral(red: 0.831372549, green: 0.2470588235, blue: 0.5529411765, alpha: 1)
    
    //kypool
    static let kypool1 = #colorLiteral(red: 0.1411764706, green: 0.8235294118, blue: 0.5725490196, alpha: 1)
    static let kypool2 = #colorLiteral(red: 0.1215686275, green: 0.7725490196, blue: 0.5333333333, alpha: 1)
    static let kypool3 = #colorLiteral(red: 0.7607843137, green: 0.2941176471, blue: 0.7137254902, alpha: 1)
    static let kypool4 = #colorLiteral(red: 0.8352941176, green: 0.3450980392, blue: 0.7843137255, alpha: 1)

    //solidstone - https://coolors.co/030034-024273-019fcc-00d4ff
    static let solidstone1 = UIColor(hex: "#030034")
    static let solidstone2 = UIColor(hex: "#024273")
    static let solidstone3 = UIColor(hex: "#019fcc")
    static let solidstone4 = UIColor(hex: "#00d4ff")
}
