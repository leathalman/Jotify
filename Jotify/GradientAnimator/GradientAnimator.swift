//
//  GradientAnimator.swift
//  Jotify
//
//  Created by Harrison Leath on 6/20/21.
//

import UIKit

@objc
public enum GradientPoints: Int {
    case left
    case top
    case right
    case bottom
    case topLeft
    case topRight
    case bottomLeft
    case bottomRight
    
    var point: CGPoint {
        switch self {
        case .left: return CGPoint(x: 0.0, y: 0.5)
        case .top: return CGPoint(x: 0.5, y: 0.0)
        case .right: return CGPoint(x: 1.0, y: 0.5)
        case .bottom: return CGPoint(x: 0.5, y: 1.0)
        case .topLeft: return CGPoint(x: 0.0, y: 0.0)
        case .topRight: return CGPoint(x: 1.0, y: 0.0)
        case .bottomLeft: return CGPoint(x: 0.0, y: 1.0)
        case .bottomRight: return CGPoint(x: 1.0, y: 1.0)
        }
    }
}

open class GradientAnimator: UIView {
    private var gradient = CAGradientLayer()
    private var currentGradient: Int = 0
    public var colors : [UIColor] = [UIColor]()
    private var startPoint: GradientPoints = GradientPoints.topRight
    private var endPoint: GradientPoints = GradientPoints.bottomLeft
    private var animationDuration : TimeInterval = 5.0
    var gradientTheme: GradientThemes  = GradientThemes.Sunrise
    
    
    public init(frame: CGRect,inputColors:[UIColor],_startPoint:GradientPoints,_endPoint:GradientPoints,_animationDuration:TimeInterval) {
        self.gradient.frame = frame
        colors  = inputColors
        startPoint = _startPoint
        endPoint = _endPoint
        animationDuration = _animationDuration
        super.init(frame: frame)
        NotificationCenter.default.addObserver(forName: UIApplication.didBecomeActiveNotification, object: nil, queue: OperationQueue.main) { (notification) in
            self.startAnimate()
        }
        
    }
    
    public init(frame: CGRect,theme:GradientThemes,_startPoint:GradientPoints,_endPoint:GradientPoints,_animationDuration:TimeInterval) {
        self.gradient.frame = frame
        colors  = theme.colors()
        startPoint = _startPoint
        endPoint = _endPoint
        animationDuration = _animationDuration
        
        super.init(frame: frame)
        //startAnimate()
        NotificationCenter.default.addObserver(forName: UIApplication.didBecomeActiveNotification, object: nil, queue: OperationQueue.main) { (notification) in
            self.startAnimate()
        }
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override open func layoutSubviews() {
        super.layoutSubviews()
        gradient.frame = bounds
    }
    
    fileprivate func currentGradientSet() -> [CGColor] {
        guard colors.count > 0 else { return [] }
        return [colors[currentGradient % colors.count].cgColor, colors[(currentGradient + 1) % colors.count].cgColor]
    }
    
    private func addcolor(_ color: UIColor) {
        self.colors.append(color)
    }
    
    public func startAnimate() {
        gradient.removeAllAnimations()
        gradient.frame = bounds
        gradient.colors = currentGradientSet()
        gradient.startPoint = startPoint.point
        gradient.endPoint = endPoint.point
        gradient.drawsAsynchronously = true
        layer.addSublayer(gradient)
        animateGradient()
    }
    
    private func animateGradient() {
        currentGradient += 1
        let animation = CABasicAnimation(keyPath: "colors")
        animation.duration = animationDuration
        animation.toValue = currentGradientSet()
        animation.fillMode = CAMediaTimingFillMode.forwards
        animation.isRemovedOnCompletion = false
        animation.delegate = self
        gradient.add(animation, forKey: "colorChange")
    }
    
    open override func removeFromSuperview() {
        super.removeFromSuperview()
        gradient.removeAllAnimations()
        gradient.removeFromSuperlayer()
        
    }    
}

extension GradientAnimator:CAAnimationDelegate{
    public func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        if flag {
            gradient.colors = currentGradientSet()
            animateGradient()
        }
    }
}
