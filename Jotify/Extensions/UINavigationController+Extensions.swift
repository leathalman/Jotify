//
//  UINavigationController+Extensions.swift
//  Jotify
//
//  Created by Harrison Leath on 2/1/21.
//

import UIKit

extension UINavigationController {
    
    func enablePersistence() {
        navigationBar.shadowImage = UIImage()
        navigationBar.setBackgroundImage(nil, for: .default)
        navigationBar.isTranslucent = false
        navigationItem.setHidesBackButton(true, animated: true)
    }
    
    func setColor(color: UIColor) {
        navigationBar.backgroundColor = color
        navigationBar.barTintColor = color
    }
}
