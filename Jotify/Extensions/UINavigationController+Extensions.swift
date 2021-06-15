//
//  UINavigationController+Extensions.swift
//  Jotify
//
//  Created by Harrison Leath on 2/1/21.
//

import UIKit

extension UINavigationController {
    
    func configure(color: UIColor, isTextWhite: Bool? = false) {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = color
        appearance.shadowColor = .clear
        
        if isTextWhite ?? false {
            appearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white]
        }
        
        navigationBar.standardAppearance = appearance
        navigationBar.scrollEdgeAppearance = navigationBar.standardAppearance
    }
}
