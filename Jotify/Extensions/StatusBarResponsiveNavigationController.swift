//
//  UINavigationController+Bar.swift
//  Jotify
//
//  Created by Harrison Leath on 7/31/21.
//

import UIKit

//allows the child view to dictate the style of the status bar
class StatusBarResponsiveNavigationController: UINavigationController {
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return topViewController?.preferredStatusBarStyle ?? .default
    }
}
