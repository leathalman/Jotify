//
//  UIColor+Extensions.swift
//  Jotify
//
//  Created by Harrison Leath on 1/25/21.
//

import UIKit

extension UIColor {
    convenience init(r: CGFloat, g: CGFloat, b: CGFloat) {
        self.init(red: r / 255, green: g / 255, blue: b / 255, alpha: 1)
    }
    
    //dark-greyish
    static let mineShaft = UIColor(r: 40, g: 40, b: 40)
}
