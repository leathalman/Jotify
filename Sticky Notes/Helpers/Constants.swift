//
//  Constants.swift
//  Sticky Notes
//
//  Created by Harrison Leath on 5/8/19.
//  Copyright © 2019 Harrison Leath. All rights reserved.
//

import UIKit

struct Colors {
    
    static var lightPurple = UIColor(red:90/255, green: 50/255, blue: 120/255, alpha: 1)
    
    static var darkPurple = UIColor(red:70/255, green: 38/255, blue: 92/255, alpha: 1)
    
    static var white = UIColor(red:255/255, green: 255/255, blue: 255/255, alpha: 1)
    
    static var darkBlue = UIColor(red: 36/255, green: 69/225, blue: 35/55, alpha: 1)
    
    static var lighterDarkBlue = UIColor(red: 36, green: 41, blue: 50, alpha: 1)
    
    static var gray = UIColor(red: 50, green: 54, blue: 63, alpha: 1)
    
    static var offWhite = UIColor(red: 247, green: 247, blue: 247, alpha: 1)
        
    var blueGradient:CAGradientLayer!
    
    init() {
        let startBlue = UIColor(red: 164 / 255.0, green: 237 / 255.0, blue: 221 / 255.0, alpha: 1.0).cgColor
        let endBlue = UIColor(red: 108 / 255.0, green: 209 / 255.0, blue: 221 / 255.0, alpha: 1.0).cgColor
        
        self.blueGradient = CAGradientLayer()
        self.blueGradient.colors = [startBlue, endBlue]
        self.blueGradient.locations = [0.0, 1.0]
    }
}
