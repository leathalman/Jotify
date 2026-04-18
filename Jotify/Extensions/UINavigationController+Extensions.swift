//
//  UINavigationController+Extensions.swift
//  Jotify
//
//  Created by Harrison Leath on 2/1/21.
//

import UIKit

extension UIViewController {

    /// Configure this view controller's navigation bar appearance. On iOS 15+
    /// the per-VC `navigationItem` appearance takes precedence over
    /// `UINavigationBar.standardAppearance`, so setting it here — rather than
    /// globally on the nav controller — reliably wins on iOS 26, where the
    /// system otherwise paints Liquid Glass over the bar.
    func configureNavigationBar(bgColor: UIColor) {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = bgColor
        // iOS 26 falls back to a glass material if backgroundEffect is non-nil.
        appearance.backgroundEffect = nil
        appearance.shadowColor = .clear
        appearance.titleTextAttributes = [
            .foregroundColor: bgColor.isDarkColor ? UIColor.white : .black
        ]

        navigationItem.standardAppearance = appearance
        navigationItem.scrollEdgeAppearance = appearance
        navigationItem.compactAppearance = appearance
        navigationItem.compactScrollEdgeAppearance = appearance
    }
}
