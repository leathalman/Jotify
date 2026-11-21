//
//  UIView+Gradient.swift
//  Jotify
//
//  Created by Harrison Leath on 6/20/21.
//

import UIKit

extension UIView {
    /// The animated gradient background installed by `setGradient`, if any.
    var gradientAnimator: GradientAnimator? {
        subviews.lazy
            .compactMap { $0 as? GradientAnimator }
            .first { !$0.isBeingRemoved }
    }

    /// Shows an animated gradient for `theme` behind this view's content.
    /// Reuses the existing gradient view and blends to the new colors instead
    /// of tearing it down, so a new note's background fades in rather than
    /// cutting.
    func setGradient(theme: GradientThemes) {
        if let existing = gradientAnimator {
            existing.setColors(theme.colors(), animated: true)
            return
        }

        let gradientView = GradientAnimator(frame: bounds, theme: theme, startPoint: .topRight, endPoint: .bottomLeft, stepDuration: 3.0)
        insertSubview(gradientView, at: 0)
        gradientView.startAnimate()

        // Fading in covers the switch back from a solid color picked in the
        // color gallery.
        if window != nil {
            gradientView.alpha = 0
            UIView.animate(withDuration: 0.4) { gradientView.alpha = 1 }
        }
    }

    /// Removes the gradient, fading it out over whatever background color
    /// the caller has already set when the view is on screen.
    func removeGradient(animated: Bool = true) {
        guard let gradientView = gradientAnimator else { return }
        gradientView.isBeingRemoved = true
        guard animated, window != nil else {
            gradientView.removeFromSuperview()
            return
        }
        UIView.animate(withDuration: 0.4, animations: {
            gradientView.alpha = 0
        }, completion: { _ in
            gradientView.removeFromSuperview()
        })
    }
}
