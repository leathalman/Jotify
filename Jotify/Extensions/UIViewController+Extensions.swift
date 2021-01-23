//
//  UIViewController+Extensions.swift
//  Jotify
//
//  Created by Harrison Leath on 1/18/21.
//

import UIKit
import AudioToolbox

extension UIViewController {
    //play haptic feedback from any viewcontroller
    func playHapticFeedback() {
        // iPhone 7 and newer
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
    }
}
