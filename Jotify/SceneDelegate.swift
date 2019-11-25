//
//  SceneDelegate.swift
//  Jotify
//
//  Created by Harrison Leath on 6/23/19.
//  Copyright © 2019 Harrison Leath. All rights reserved.
//

import LocalAuthentication
import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    
    let appDelegate = UIApplication.shared.delegate as? AppDelegate
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        
        if let windowScene = scene as? UIWindowScene {
            let window = UIWindow(windowScene: windowScene)
            window.rootViewController = PageViewController()
            self.window = window
            window.makeKeyAndVisible()
        }
        
        guard let _ = (scene as? UIWindowScene) else { return }
    }
    
    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not neccessarily discarded (see `application:didDiscardSceneSessions` instead).
    }
    
    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }
    
    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }
    
    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
        if UserDefaults.standard.bool(forKey: "useBiometrics") == true {
            let privacyController = PrivacySettingsController()
            privacyController.setupBiometricsView(window: window!)
            privacyController.unlockButton.addTarget(self, action: #selector(unlockPressed(sender:)), for: .touchUpInside)
            privacyController.authenticateUserWithBioMetrics(window: window!)
        }
    }
    
    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
        
        // Save changes in the application's managed object context when the application transitions to the background.
        
        print("App entered background")
        
        let privacyController = PrivacySettingsController()
        privacyController.removeBlurView(window: window!)
                
        renumberBadgesOfPendingNotifications()
        appDelegate?.saveNoteBeforeExiting()
        (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
    }
    
    @objc func unlockPressed(sender: UIButton) {
        let privacyController = PrivacySettingsController()
        privacyController.authenticateUserWithBioMetrics(window: window!)
    }
    
    func renumberBadgesOfPendingNotifications() {
        // once reminders are delivered it will override the badge number
        // so it will increment correctly as long as the notifications have been delivered
        // but a new reminder scheduled after the others have been delivered will still be badge = 1
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().getPendingNotificationRequests { pendingNotificationRequests in
                if pendingNotificationRequests.count > 0 {
                    let notificationRequests = pendingNotificationRequests
                        .filter { $0.trigger is UNCalendarNotificationTrigger }
                        .sorted(by: { (r1, r2) -> Bool in
                            let r1Trigger = r1.trigger as! UNCalendarNotificationTrigger
                            let r2Trigger = r2.trigger as! UNCalendarNotificationTrigger
                            let r1Date = r1Trigger.nextTriggerDate()!
                            let r2Date = r2Trigger.nextTriggerDate()!
                            
                            return r1Date.compare(r2Date) == .orderedAscending
                        })
                    
                    let identifiers = notificationRequests.map { $0.identifier }
                    UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: identifiers)
                    
                    notificationRequests.enumerated().forEach { index, request in
                        if let trigger = request.trigger {
                            let content = UNMutableNotificationContent()
                            content.body = request.content.body
                            content.sound = .default
                            content.badge = (index + 1) as NSNumber
                            
                            let request = UNNotificationRequest(identifier: request.identifier, content: content, trigger: trigger)
                            UNUserNotificationCenter.current().add(request)
                        }
                    }
                }
            }
        } else if let pendingNotifications = UIApplication.shared.scheduledLocalNotifications, pendingNotifications.count > 0 {
            let notifications = pendingNotifications
                .filter { $0.fireDate != nil }
                .sorted(by: { n1, n2 in n1.fireDate!.compare(n2.fireDate!) == .orderedAscending })
            
            notifications.forEach { UIApplication.shared.cancelLocalNotification($0) }
            notifications.enumerated().forEach { index, notification in
                notification.applicationIconBadgeNumber = index + 1
                UIApplication.shared.scheduleLocalNotification(notification)
            }
        }
    }
}
