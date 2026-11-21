//
//  UIViewController+Extensions.swift
//  Jotify
//
//  Created by Harrison Leath on 1/18/21.
//

import UIKit
import AudioToolbox
import UserNotifications

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
        UIApplication.shared.setRootViewController(vc, duration: duration)
    }

    //change StatusBarStyle in parent, PageViewController
    //override and set a given status bar style
    //**only call this method when PageViewController is present**
    func setStatusBarStyle(style: UIStatusBarStyle) {
        guard let rootVC = UIApplication.shared.firstKeyWindow?.rootViewController as? PageBoyController else { return }
        rootVC.statusBarStyle = style
        rootVC.animateStatusBarAppearanceUpdate()
    }

    //change StatusBarStyle in parent, PageViewController
    //override any previous customization and just use default style
    //**only call this method when PageViewController is present**
    func enableAutomaticStatusBarStyle() {
        guard let rootVC = UIApplication.shared.firstKeyWindow?.rootViewController as? PageBoyController else { return }
        rootVC.statusBarStyle = .default
        rootVC.animateStatusBarAppearanceUpdate()
    }

    //fade the status bar between styles instead of snapping, matching the
    //length of the push/pop and page transitions it usually accompanies
    func animateStatusBarAppearanceUpdate() {
        UIView.animate(withDuration: 0.2) { self.setNeedsStatusBarAppearanceUpdate() }
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

extension UIApplication {
    /// Sets the app icon badge to the number of reminders that have fired
    /// and are still in Notification Center, after optionally clearing one.
    /// (Replaces decrementing `applicationIconBadgeNumber`, deprecated in
    /// iOS 17; there's no public getter for the badge any more, so it's
    /// derived from the delivered notifications instead.)
    func refreshReminderBadge(clearing reminderID: String? = nil) {
        let center = UNUserNotificationCenter.current()
        if let reminderID, !reminderID.isEmpty {
            center.removeDeliveredNotifications(withIdentifiers: [reminderID])
        }
        center.getDeliveredNotifications { delivered in
            let count = delivered.filter { $0.request.content.categoryIdentifier == "NOTE_REMINDER" }.count
            center.setBadgeCount(count)
        }
    }

    /// Swaps the window's root view controller with a cross-fade. Anything
    /// presented on the old root (a settings sheet, say) is dismissed first
    /// so it doesn't outlive the screen it was shown from.
    func setRootViewController(_ vc: UIViewController, duration: Double = 0.4) {
        guard let window = firstKeyWindow else { return }
        let swap = {
            window.rootViewController = vc
            window.makeKeyAndVisible()
            UIView.transition(with: window, duration: duration, options: .transitionCrossDissolve, animations: nil, completion: nil)
        }
        if let presented = window.rootViewController?.presentedViewController {
            presented.dismiss(animated: true, completion: swap)
        } else {
            swap()
        }
    }
}
