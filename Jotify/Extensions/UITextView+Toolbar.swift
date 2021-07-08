//
//  File.swift
//  Jotify
//
//  Created by Harrison Leath on 7/8/21.
//

import UIKit

extension UITextView {
    
    //add bullet at cursor (or replacing cursor's selection)
    func addBullet() {
        if let range = self.selectedTextRange {
            self.replace(range, withText: "\u{2022} ")
        }
    }
    
    //make new line and then add bullet at cursor
    func addBulletOnReturn() {
        if let range = self.selectedTextRange {
            self.replace(range, withText: "\n" + "\u{2022} ")
        }
    }
    
    //mke new line at cursor
    func addNewLineOnReturn() {
        if let range = self.selectedTextRange {
            self.replace(range, withText: "\n")
        }
    }
}
