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

extension UIViewController {
    public var isVisible: Bool {
        if isViewLoaded {
            return view.window != nil
        }
        return false
    }
    
    public var isTopViewController: Bool {
        if self.navigationController != nil {
            return self.navigationController?.visibleViewController === self
        } else if self.tabBarController != nil {
            return self.tabBarController?.selectedViewController == self && self.presentedViewController == nil
        } else {
            return self.presentedViewController == nil && self.isVisible
        }
    }
}

extension UIDevice {
    enum DevicePlatform: String {
        case other = "Old Device"
        case iPhone6S = "iPhone 6S"
        case iPhone6SPlus = "iPhone 6S Plus"
        case iPhone7 = "iPhone 7"
        case iPhone7Plus = "iPhone 7 Plus"
    }
    
    var platform: DevicePlatform {
        get {
            var sysinfo = utsname()
            uname(&sysinfo)
            let platform = String(bytes: Data(bytes: &sysinfo.machine, count: Int(_SYS_NAMELEN)), encoding: .ascii)!.trimmingCharacters(in: .controlCharacters)
            switch platform {
            case "iPhone9,2", "iPhone9,4":
                return .iPhone7Plus
            case "iPhone9,1", "iPhone9,3":
                return .iPhone7
            case "iPhone8,2":
                return .iPhone6SPlus
            case "iPhone8,1":
                return .iPhone6S
            default:
                return .other
            }
        }
    }
    
    var hasTapticEngine: Bool {
        get {
            return platform == .iPhone6S || platform == .iPhone6SPlus ||
                platform == .iPhone7 || platform == .iPhone7Plus
        }
    }
    
    var hasHapticFeedback: Bool {
        get {
            return platform == .iPhone7 || platform == .iPhone7Plus
        }
    }
}
