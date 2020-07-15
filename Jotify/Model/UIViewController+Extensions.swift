//
//  FeedbackHandler.swift
//  Jotify
//
//  Created by Harrison Leath on 7/15/20.
//  Copyright © 2020 Harrison Leath. All rights reserved.
//

import AudioToolbox
import UIKit

extension UIViewController {
    func playHapticFeedback() {
        
        if UIDevice.current.hasTapticEngine {
            // iPhone 6s and iPhone 6s Plus
            let peek = SystemSoundID(1519)
            AudioServicesPlaySystemSoundWithCompletion(peek, nil)
            
        } else {
            // iPhone 7 and newer
            let generator = UIImpactFeedbackGenerator(style: .medium)
            generator.impactOccurred()
            print("OH")
        }
    }
}
