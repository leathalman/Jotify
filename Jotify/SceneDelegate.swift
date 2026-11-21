//
//  SceneDelegate.swift
//  Jotify
//
//  Created by Harrison Leath on 1/16/21.
//

import UIKit
import SwiftUI

class SceneDelegate: UIResponder, UIWindowSceneDelegate, UNUserNotificationCenterDelegate {
    
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        
        UNUserNotificationCenter.current().delegate = self
                
        //handle initial setup from dedicated controller
        SetupController().handleApplicationSetup()
                
        //check if user is logged in
        if !AuthManager().uid.isEmpty {
            print("logged in")
            setupWindows(scene: scene, vc: PageBoyController())
        } else {
            print("not logged in")
            if SetupController.firstLauch ?? false {
                setupWindows(scene: scene, vc: OnboardingController())
            } else {
                setupWindows(scene: scene, vc: UIHostingController(rootView: SignUpView()))
            }
        }
        
        //pull up recent note widget launched app
        maybePressedRecentNoteWidget(urlContexts: connectionOptions.urlContexts)
        
        guard let _ = (scene as? UIWindowScene) else { return }
    }
    
    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
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
        // Called as the scene transitions from the background to the foreground,
        // including on cold launch.
        showPrivacyOverlayIfNeeded()
    }

    /// Covers the app with the biometric lock when it's enabled.
    ///
    /// Presents from the top-most view controller: presenting from the root
    /// silently failed whenever something else was already up (a note opened
    /// from the widget or a reminder, a share sheet, an alert), skipping the
    /// lock entirely. No-op if the lock is already showing.
    func showPrivacyOverlayIfNeeded() {
        guard !AuthManager().uid.isEmpty,
              UserDefaults.standard.bool(forKey: "useBiometrics"),
              var top = window?.rootViewController else { return }
        while let presented = top.presentedViewController {
            if presented is PrivacyOverlayController { return }
            top = presented
        }
        if top is PrivacyOverlayController { return }

        let poc = PrivacyOverlayController()
        poc.modalPresentationStyle = .fullScreen
        poc.isModalInPresentation = true
        top.present(poc, animated: false, completion: nil)
    }
    
    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
        // Lock before iOS takes the app-switcher snapshot, so notes aren't
        // visible there. (Showing the lock only on foreground left the
        // snapshot uncovered.)
        showPrivacyOverlayIfNeeded()

        ReminderController.renumberBadgesOfPendingNotifications()

        // Keep observing the payment queue for the app's whole lifetime (as
        // Apple recommends). This used to call stopObserving() here, but
        // startObserving() only runs at launch, so after the first trip to
        // the background purchases and restores never completed.
    }
    
    func scene(_ scene: UIScene, continue userActivity: NSUserActivity) {
        if let incomingUrl = userActivity.webpageURL {
            print("Incoming URL is \(incomingUrl)")
            handleIncomingReferralURL(incomingUrl)
        }
    }

    //App opened from background - used partially for widgets
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        print("Received a URL through a custom scheme...")
        guard let urlinfo = URLContexts.first?.url else { return }
        if handleIncomingReferralURL(urlinfo) {
            return
        }
        maybePressedRecentNoteWidget(urlContexts: URLContexts)
    }

    @discardableResult
    func handleIncomingReferralURL(_ url: URL) -> Bool {
        guard let components = URLComponents(url: url, resolvingAgainstBaseURL: false),
              let queryItems = components.queryItems else { return false }
        var matched = false
        for queryItem in queryItems where queryItem.name == "invitedby" {
            print("Parameter \(queryItem.name) has a value of \(queryItem.value ?? "")")
            UserDefaults.standard.set(queryItem.value, forKey: "referralId")
            matched = true
        }
        return matched
    }
    
    //collect data and present EditingController if widget pressed
    private func maybePressedRecentNoteWidget(urlContexts: Set<UIOpenURLContext>) {
        guard let _: UIOpenURLContext = urlContexts.first(where: { $0.url.scheme == "recentnotewidget-link" }) else { return }
        print("🚀 Launched from widget")
        
        //read data from GroupDataManager then create FBNote object
        let content = GroupDataManager.readData(path: "recentNoteContent")
        let color = GroupDataManager.readData(path: "recentNoteColor")
        let date = GroupDataManager.readData(path: "recentNoteDate")
        let id = GroupDataManager.readData(path: "recentNoteID")
        
        EditingData.currentNote = FBNote(content: content, timestamp: date.getTimestamp(), id: id, color: color)
        
        let presentable = StatusBarResponsiveNavigationController(rootViewController: EditingController())
        presentable.modalPresentationStyle = .fullScreen
        
        if !AuthManager().uid.isEmpty {
            print("logged in")
            if !UserDefaults.standard.bool(forKey: "useBiometrics") {
                window?.rootViewController?.present(presentable, animated: true, completion: nil)
            }
        }
    }
    
    func setupWindows(scene: UIScene, vc: UIViewController) {
        if let windowScene = scene as? UIWindowScene {
            let window = UIWindow(windowScene: windowScene)
            window.rootViewController = vc
            self.window = window
            window.makeKeyAndVisible()
        }
    }
    
    //app in background when user interacts with notification
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        let userInfo = response.notification.request.content.userInfo
        
        if response.notification.request.content.categoryIdentifier ==
            "NOTE_REMINDER" {
            openNoteFromNotification(userInfo: userInfo)
        }
        else {
            // Handle other notification types...
        }
        completionHandler()
    }
    
    //app in foreground when user interacts with notification
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        //show an alert at top of screen while application is open
        completionHandler([.banner, .list, .sound])
    }
    
    func openNoteFromNotification(userInfo: [AnyHashable : Any]) {
        // Reminders scheduled by older builds (or rebuilt by the old badge
        // renumbering) may be missing fields; don't crash on them.
        guard let noteID = userInfo["noteID"] as? String,
              let color = userInfo["color"] as? String,
              let timestamp = userInfo["timestamp"] as? Double,
              let content = userInfo["content"] as? String else {
            print("Reminder notification is missing note info: \(userInfo)")
            return
        }

        print("NoteID from reminder: \(noteID)")
        
        EditingData.currentNote = FBNote(content: content, timestamp: timestamp, id: noteID, color: color)
        
        DataManager.removeReminder(uid: noteID) { success in
            if !success! {
                print("There was an error deleting the reminder")
            } else {
                print("Reminder was succesfully deleted and removed from backend")
                UIApplication.shared.decrementBadge()
            }
        }
        
        let presentable = StatusBarResponsiveNavigationController(rootViewController: EditingController())
        presentable.modalPresentationStyle = .fullScreen
        // Present under the privacy lock if it's up, so the note is only
        // revealed once the user unlocks.
        guard var top = window?.rootViewController else { return }
        while let presented = top.presentedViewController, !(presented is PrivacyOverlayController) {
            top = presented
        }
        top.present(presentable, animated: true)
    }
}

