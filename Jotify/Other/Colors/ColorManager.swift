//
//  ColorManager.swift
//  Jotify
//
//  Created by Harrison Leath on 2/1/21.
//

import UIKit

class ColorManager {
    
    var indexes = [Int]()

    //an instance of ColorManager must be created to persist the value of indexes
    //fill an array of indexes that correspond to the array as a parameter
    //remove elements from indexes array as they are selected from parameter array
    //repeat when indexes is empty
    func getRandomColor(theme: Array<UIColor>) -> UIColor {
        if indexes.count == 0 {
            print("Filling indexes array")
            indexes = Array(0..<theme.count)
        }
        let randomIndex = Int(arc4random_uniform(UInt32(indexes.count)))
        let anIndex = indexes.remove(at: randomIndex)
        return theme[anIndex]
    }
}
