//
//  Extensions.swift
//  Sticky Notes
//
//  Created by Harrison Leath on 5/8/19.
//  Copyright © 2019 Harrison Leath. All rights reserved.
//

import UIKit

let imageCache = NSCache<AnyObject, AnyObject>()

extension String {
    func trunc(length: Int, trailing: String = "…") -> String {
        return (self.count > length) ? self.prefix(length) + trailing : self
    }
}

public extension CALayer {
    
    func addShadow(color: UIColor) {
        self.shadowOffset = .zero
        self.shadowOpacity = 0.3
        self.shadowRadius = 5
        self.shadowColor = color.cgColor
        self.masksToBounds = false
    }
}

extension String {
    func height(constraintedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let label =  UILabel(frame: CGRect(x: 0, y: 0, width: width, height: .greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.text = self
        label.font = font
        label.sizeToFit()
        
        return label.frame.height
    }
}

extension UIView {
    func setGradient(){
        self.removeGradient()
        
        let gradientView = GradientAnimator(frame: self.frame, theme: Colors.shared.themeColor, _startPoint: GradientPoints.bottomLeft, _endPoint: GradientPoints.topRight, _animationDuration: 3.0)
        gradientView.tag = 007
        self.insertSubview(gradientView, at: 0)
        gradientView.startAnimate()
        
    }
    func removeGradient(){
        if let gradView : GradientAnimator = self.subviews.filter({$0.tag == 007}).first as? GradientAnimator{
            gradView.removeFromSuperview()
        }
    }
}


