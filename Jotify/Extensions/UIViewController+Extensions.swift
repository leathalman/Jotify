//
//  UIViewController+Extensions.swift
//  Jotify
//
//  Created by Harrison Leath on 1/18/21.
//

import UIKit
import AudioToolbox

extension UIApplication {
    /// iOS 15+ replacement for the deprecated `UIApplication.shared.windows.first`.
    var firstKeyWindow: UIWindow? {
        let windows = connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .flatMap { $0.windows }
        return windows.first { $0.isKeyWindow } ?? windows.first
    }
}

extension UIViewController {
    
    /// The current root view controller. Falls back to `self` if no key
    /// window is available — previously this chain force-unwrapped and
    /// crashed during light/dark mode transitions when scenes momentarily
    /// had no key window.
    var rootViewController: UIViewController {
        UIApplication.shared.firstKeyWindow?.rootViewController ?? self
    }
    
    //play haptic feedback from any viewcontroller
    func playHapticFeedback() {
        if UserDefaults.standard.bool(forKey: "useHaptics") {
            // iPhone 7 and newer
            let generator = UIImpactFeedbackGenerator(style: .medium)
            generator.impactOccurred()
        }
    }
    
    //add gesture recognizer to hide keyboard when view is tapped
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    //set a new rootViewController with animation
    func setRootViewController(duration: Double, vc: UIViewController) {
        guard let window = UIApplication.shared.firstKeyWindow else { return }
        window.rootViewController = vc
        window.makeKeyAndVisible()
        UIView.transition(with: window, duration: duration, options: .transitionCrossDissolve, animations: nil, completion: nil)
    }

    //change StatusBarStyle in parent, PageViewController
    //override and set a given status bar style
    //**only call this method when PageViewController is present**
    func setStatusBarStyle(style: UIStatusBarStyle) {
        guard let rootVC = UIApplication.shared.firstKeyWindow?.rootViewController as? PageBoyController else { return }
        rootVC.statusBarStyle = style
        rootVC.setNeedsStatusBarAppearanceUpdate()
    }

    //change StatusBarStyle in parent, PageViewController
    //override any previous customization and just use default style
    //**only call this method when PageViewController is present**
    func enableAutomaticStatusBarStyle() {
        guard let rootVC = UIApplication.shared.firstKeyWindow?.rootViewController as? PageBoyController else { return }
        rootVC.statusBarStyle = .default
        rootVC.setNeedsStatusBarAppearanceUpdate()
    }
    
    //tell is viewcontroller was presented modally or was pushed by navigation stack
    var isModal: Bool {
        if let index = navigationController?.viewControllers.firstIndex(of: self), index > 0 {
            return false
        } else if presentingViewController != nil {
            return true
        } else if navigationController?.presentingViewController?.presentedViewController == navigationController {
            return true
        } else if tabBarController?.presentingViewController is UITabBarController {
            return true
        } else {
            return false
        }
    }
}
