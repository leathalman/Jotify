//
//  UIView+Gradient.swift
//  Jotify
//
//  Created by Harrison Leath on 6/20/21.
//

import UIKit

extension UIView {
    /// Returns the first `GradientAnimator` subview, if any. Replaces the
    /// previous `viewWithTag(007)` lookup — type-based, no magic number.
    var gradientAnimator: GradientAnimator? {
        subviews.compactMap { $0 as? GradientAnimator }.first
    }

    func setGradient(theme: GradientThemes) {
        removeGradient()
        let gradientView = GradientAnimator(frame: self.frame, theme: theme, _startPoint: GradientPoints.topRight, _endPoint: GradientPoints.bottomLeft, _animationDuration: 3.0)
        insertSubview(gradientView, at: 0)
        gradientView.startAnimate()
    }

    func removeGradient() {
        gradientAnimator?.removeFromSuperview()
    }
}
