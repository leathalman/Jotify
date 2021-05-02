//
//  CustomColors.swift
//  Jotify
//
//  Created by Harrison Leath on 2/1/21.
//

import UIKit

extension UIColor {
    //import all of the theme colors
    
    //MISC: dark-greyish
    static let mineShaft = UIColor(r: 40, g: 40, b: 40)
    static let lightTrail = UIColor(r: 239, g: 243, b: 244)
    static let gainsboro = UIColor(hex: "#E8ECED")
    
    //default v2 theme
    static let geranium = UIColor(hex: "#E95452")
    static let chineseViolet = UIColor(hex: "#8D82A0")
    static let viridian = UIColor(hex: "#4FB598")
    static let tealBlue = UIColor(hex: "#47ACD1")
    static let spanishOrange = UIColor(hex: "FF8F40")
    static let gamboge = UIColor(hex: "#E7A953")
    static let rose = UIColor(hex: "#E3568F")
    static let cornflower = UIColor(hex: "#4E69CA")
    
    //kypool theme
    static let fuchsia = UIColor(hex: "#FE4891")
    static let fuchsiaPlus = UIColor(hex: "#EC4688")
    static let fireOpal = UIColor(hex: "#F77062")
    static let fireOpalPlus = UIColor(hex: "#E85D4E")
    static let aquamarine = UIColor(hex: "#006D77") //atl: 2a9d8f
    static let aquamarinePlus = UIColor(hex: "#12BA93")
    static let blueCrayola = UIColor(hex: "#2272FC")
    static let blueCrayolaPlus = UIColor(hex: "#1A61DB")
    
    //array of color themes
    static var defaultTheme = [geranium, chineseViolet, viridian, tealBlue, spanishOrange, gamboge, rose, cornflower]
    static var kypoolTheme = [fuchsia, fuchsiaPlus, fireOpal, fireOpalPlus, aquamarine, aquamarinePlus, blueCrayola, blueCrayolaPlus]
}
