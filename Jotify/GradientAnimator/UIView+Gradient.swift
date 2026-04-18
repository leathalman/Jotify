//
//  UIView+Gradient.swift
//  Jotify
//
//  Created by Harrison Leath on 6/20/21.
//

import UIKit

extension UIView {
    func setGradient(theme: GradientThemes) {
        self.removeGradient()
        let gradientView = GradientAnimator(frame: self.frame, theme: theme, _startPoint: GradientPoints.topRight, _endPoint: GradientPoints.bottomLeft, _animationDuration: 3.0)
        gradientView.tag = 007
        self.insertSubview(gradientView, at: 0)
        gradientView.startAnimate()
    }
    
    func removeGradient() {
        if let gradView : GradientAnimator = self.subviews.filter({$0.tag == 007}).first as? GradientAnimator{
            gradView.removeFromSuperview()
        }
    }
}
