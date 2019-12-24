//
//  UINavigationController+Extensions.swift
//  Jotify
//
//  Created by Harrison Leath on 12/23/19.
//  Copyright © 2019 Harrison Leath. All rights reserved.
//

import UIKit

extension UINavigationController {
   open override var preferredStatusBarStyle: UIStatusBarStyle {
      return topViewController?.preferredStatusBarStyle ?? .default
   }
}
