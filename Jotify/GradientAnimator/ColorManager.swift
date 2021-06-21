//
//  ColorManager.swift
//  Jotify
//
//  Created by Harrison Leath on 2/1/21.
//

import UIKit

class ColorManager {
    
    static var themes: [GradientThemes] = [.Amin, .BlueLagoon, .Celestial, .DIMIGO, .GentleCare, .Kyoopal, .Maldives, .NeonLife, .SolidStone, .Sunrise]
    static var allColors = GradientThemes.All.colors()
    
    static var noteColor = UIColor()
    static var indexes = [Int]()
    static var bgColor = UIColor()

    //a static instance of ColorManager must be created to persist the value of indexes
    //fill an array of indexes that correspond to the array as a parameter
    //remove elements from indexes array as they are selected from parameter array
    //repeat when indexes is empty
    @discardableResult static func setNewNoteColor() -> UIColor {
        let count = GradientThemes.All.colors().count
        if ColorManager.indexes.count == 0 {
            ColorManager.indexes = Array(0..<count)
        }
        let randomIndex = Int(arc4random_uniform(UInt32(ColorManager.indexes.count)))
        print(ColorManager.indexes.count)
        let anIndex = ColorManager.indexes.remove(at: randomIndex)
        ColorManager.noteColor = allColors[anIndex]
        return allColors[anIndex]
    }
}
