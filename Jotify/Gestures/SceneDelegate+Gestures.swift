//
//  SceneDelegate+Gestures.swift
//  Jotify
//
//  Created by Harrison Leath on 3/17/21.
//

import UIKit

extension SceneDelegate: UIGestureRecognizerDelegate {
    //setups up gesture recognizer for use across entire window
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
