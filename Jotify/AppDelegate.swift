//
//  AppDelegate.swift
//  Jotify
//
//  Created by Harrison Leath on 1/16/21.
//

import FirebaseCore
import FirebaseFirestore
import FirebaseAuth
import AuthenticationServices

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FirebaseApp.configure()

        // Enable Firestore's disk-backed cache so the snapshot listener can
        // serve notes immediately from local storage on cold launch and
        // reconcile with the server in the background. Must be set before
        // any other `Firestore.firestore()` access.
        let firestoreSettings = FirestoreSettings()
        firestoreSettings.cacheSettings = PersistentCacheSettings()

        #if DEBUG && targetEnvironment(simulator)
        // Debug simulator builds talk to the local Firebase Emulator Suite
        // (`npx firebase-tools emulators:start`, then
        // `node scripts/seed-emulator.mjs`) instead of production. Set the
        // `USE_PRODUCTION_FIREBASE` environment variable in the scheme to opt
        // out. Device builds can't reach the Mac's localhost, so they always
        // use production.
        if ProcessInfo.processInfo.environment["USE_PRODUCTION_FIREBASE"] == nil {
            Auth.auth().useEmulator(withHost: "127.0.0.1", port: 9099)
            firestoreSettings.host = "127.0.0.1:8080"
            firestoreSettings.isSSLEnabled = false
            print("Firebase: using local emulators (auth :9099, firestore :8080)")
        }
        #endif

        Firestore.firestore().settings = firestoreSettings

        //check to see if Apple credential revoked since last launch
        didAppleIDStateRevokeWhileTerminated()
        
        //register notification types to be handled when interacted with
        registerNotificationActions()
        
        //listen for App Store transactions (Ask to Buy approvals, refunds, purchases on other devices)
        PremiumStore.shared.start()
        
        return true
    }
    
    // MARK: UISceneSession Lifecycle
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    //check to see if Apple credential revoked since last launch
    func didAppleIDStateRevokeWhileTerminated() {
        // Retrieve user ID saved in UserDefaults
        if let userID = UserDefaults.standard.string(forKey: "appleAuthorizedUserIdKey") {
            
            // Check Apple ID credential state
            ASAuthorizationAppleIDProvider().getCredentialState(forUserID: userID, completion: {
                credentialState, error in
                
                switch(credentialState) {
                case .authorized:
                    break
                case .notFound,
                        .transferred,
                        .revoked:
                    // Credential no longer authorized...
                    // Perform sign out
                    AuthManager.signOut()
                    break
                @unknown default:
                    break
                }
            })
        }
    }
    
    func registerNotificationActions() {
        // Define the notification type
        let noteReminderCategory =
        UNNotificationCategory(identifier: "NOTE_REMINDER", actions: [], intentIdentifiers: [], hiddenPreviewsBodyPlaceholder: "", options: .customDismissAction)
        // Register the notification type.
        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.setNotificationCategories([noteReminderCategory])
    }
}
