//
//  ColorManager.swift
//  Jotify
//
//  Created by Harrison Leath on 2/1/21.
//

import UIKit

class ColorManager {
    
    static var themes: [GradientThemes] = [.minoas, .olympia, .caelestibus, .kyoopal, .sunrise, .eros, .caeruleum, .sunset]
    static var allColors = GradientThemes.All.colors()
    
    // Non-placeholder defaults. The previous `UIColor()` placeholder crashed
    // on `isEqual:` because it has no color space. Both values are always
    // overwritten before they're observed in a real flow (bgColor by
    // PageBoyController.viewDidLoad based on interface style; noteColor by
    // setNoteColor()), but a sensible default prevents any latent crash
    // during early app launch.
    static var noteColor: UIColor = .systemBlue
    static var indexes = [Int]()
    static var bgColor: UIColor = .systemBackground
    
    //a static instance of ColorManager must be created to persist the value of indexes
    //fill an array of indexes that correspond to the array as a parameter
    //remove elements from indexes array as they are selected from parameter array
    //repeat when indexes is empty
    @discardableResult static func setNoteColor() -> UIColor {
        let count = GradientThemes.All.colors().count
        if ColorManager.indexes.count == 0 {
            ColorManager.indexes = Array(0..<count)
        }
        let randomIndex = Int.random(in: 0..<ColorManager.indexes.count)
        let anIndex = ColorManager.indexes.remove(at: randomIndex)
        ColorManager.noteColor = allColors[anIndex]
        return allColors[anIndex]
    }
}
