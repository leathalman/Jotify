//
//  SystemPopAnimator.swift
//  CustomTransition
//
//  Created by Tibor Bödecs on 2018. 04. 26..
//  Copyright © 2018. Tibor Bödecs. All rights reserved.
//

import UIKit

open class CustomAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    public enum TransitionType {
        case navigation
        case modal
    }
    
    let type: TransitionType
    let duration: TimeInterval
    
    public init(type: TransitionType, duration: TimeInterval = 0.25) {
        self.type = type
        self.duration = duration
        
        super.init()
    }
    
    open func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return self.duration
    }
    
    open func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        fatalError("You have to implement this method for yourself!")
    }
}

open class SystemPopAnimator: CustomAnimator {
    
    let interactionController: UIPercentDrivenInteractiveTransition?
    
    public init(type: TransitionType,
                duration: TimeInterval = 0.25,
                interactionController: UIPercentDrivenInteractiveTransition? = nil) {
        self.interactionController = interactionController
        
        super.init(type: type, duration: duration)
    }
    
    open override func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard
            let fromViewController = transitionContext.viewController(forKey: .from),
            let toViewController = transitionContext.viewController(forKey: .to)
            else {
                return
        }
        let containerView = transitionContext.containerView
        if self.type == .navigation {
            containerView.insertSubview(toViewController.view, belowSubview: fromViewController.view)
        }
        
        let animations = {
            fromViewController.view.frame = containerView.bounds.offsetBy(dx: containerView.frame.size.width, dy: 0)
            toViewController.view.frame = containerView.bounds
        }
        
        UIView.animate(withDuration: self.transitionDuration(using: transitionContext),
                       delay: 0,
                       options: [.curveEaseOut],
                       animations: animations) { _ in
                        
                        transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
    }
}

open class SystemPushAnimator: CustomAnimator {
    
    open override func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard
            let fromViewController = transitionContext.viewController(forKey: .from),
            let toViewController = transitionContext.viewController(forKey: .to)
            else {
                return
        }
        let containerView = transitionContext.containerView
        toViewController.view.frame = containerView.bounds.offsetBy(dx: containerView.frame.size.width, dy: 0.0)
        containerView.addSubview(toViewController.view)
        
        let animations = {
            toViewController.view.frame = containerView.bounds
            fromViewController.view.frame = containerView.bounds.offsetBy(dx: -containerView.frame.size.width, dy: 0)
            
        }
        UIView.animate(withDuration: self.transitionDuration(using: transitionContext),
                       delay: 0,
                       options: [.curveEaseOut],
                       animations: animations) { _ in
                        
                        transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
    }
}

class PopAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    open var duration = 1.0
    var presenting = true
    var originFrame = CGRect.zero
    
    var dismissCompletion: (() -> Void)?
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
        let toView = transitionContext.view(forKey: .to)!
        let recipeView = presenting ? toView : transitionContext.view(forKey: .from)!
        
        let initialFrame = presenting ? originFrame : recipeView.frame
        let finalFrame = presenting ? recipeView.frame : originFrame
        
        let xScaleFactor = presenting ?
            initialFrame.width / finalFrame.width :
            finalFrame.width / initialFrame.width
        
        let yScaleFactor = presenting ?
            initialFrame.height / finalFrame.height :
            finalFrame.height / initialFrame.height
        
        let scaleTransform = CGAffineTransform(scaleX: xScaleFactor, y: yScaleFactor)
        
        if presenting {
            recipeView.transform = scaleTransform
            recipeView.center = CGPoint(
                x: initialFrame.midX,
                y: initialFrame.midY)
            recipeView.clipsToBounds = true
        }
        
        recipeView.layer.cornerRadius = presenting ? 20.0 : 0.0
        recipeView.layer.masksToBounds = true
        
        containerView.addSubview(toView)
        containerView.bringSubviewToFront(recipeView)
        
        UIView.animate(
            withDuration: duration,
            delay:0.0,
            usingSpringWithDamping: 0.2,
            initialSpringVelocity: 0.2,
            animations: {
                recipeView.transform = self.presenting ? .identity : scaleTransform
                recipeView.center = CGPoint(x: finalFrame.midX, y: finalFrame.midY)
                recipeView.layer.cornerRadius = !self.presenting ? 20.0 : 0.0
        }, completion: { _ in
            if !self.presenting {
                self.dismissCompletion?()
            }
            transitionContext.completeTransition(true)
        })
    }
    
    private func handleRadius(recipeView: UIView, hasRadius: Bool) {
        recipeView.layer.cornerRadius = hasRadius ? 20.0 : 0.0
    }
}
