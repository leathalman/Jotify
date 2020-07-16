//
//  UIViewController+Extensions.swift
//  Jotify
//
//  Created by Harrison Leath on 9/7/19.
//  Copyright © 2019 Harrison Leath. All rights reserved.
//

import AudioToolbox
import UIKit

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func playHapticFeedback() {
        if UserDefaults.standard.bool(forKey: "useHaptics") {
            if UIDevice.current.hasTapticEngine {
                // iPhone 6s and iPhone 6s Plus
                let peek = SystemSoundID(1519)
                AudioServicesPlaySystemSoundWithCompletion(peek, nil)
                
            } else {
                // iPhone 7 and newer
                let generator = UIImpactFeedbackGenerator(style: .medium)
                generator.impactOccurred()
            }
        }
    }
}
