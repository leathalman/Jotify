//
//  AuthManager.swift
//  Zurich
//
//  Created by Harrison Leath on 1/11/21.
//

import FirebaseAuth

class AuthManager {
    
    //current user uid
    public var uid: String {
        if Auth.auth().currentUser != nil {
            return Auth.auth().currentUser?.uid ?? ""
        }
        return ""
    }
    
    //current user email
    public var email: String {
        if Auth.auth().currentUser != nil {
            return Auth.auth().currentUser?.email ?? ""
        }
        return ""
    }
    
    //current user object, should never return nil b/c of pseudo guard statment
    public var metadata: UserMetadata? {
        if Auth.auth().currentUser != nil {
            return Auth.auth().currentUser!.metadata
        }
        return nil
    }
    
    //check if user is Signed In With Apple or is using Firebase email login
    public var isSignedInWithApple: Bool {
        if let providerId = Auth.auth().currentUser?.providerData.first?.providerID, providerId == "apple.com" {
            return true
        }
        return false
    }
    
    //signs user out of firebase
    static func signOut() {
        //check if user is signed in with Apple
        if let providerId = Auth.auth().currentUser?.providerData.first?.providerID, providerId == "apple.com" {
            // Clear saved user ID from Sign In with Apple
            UserDefaults.standard.set(nil, forKey: "appleAuthorizedUserIdKey")
        }
        do {
            try Auth.auth().signOut()
            //remove biometrics
            UserDefaults.standard.set(false, forKey: "useBiometrics")
            //reset app notification badge since no account is logged in
            UIApplication.shared.applicationIconBadgeNumber = 0
            //remove all pending reminders, when user logs out
            UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        }
        catch { print("User already logged out") }
    }
    
    //tells firebase to send password recovery message to given email
    static func forgotPassword(email: String, completionHandler: @escaping (Bool?, String?) -> Void) {
        Auth.auth().sendPasswordReset(withEmail: email) { (error) in
            if let error = error {
                completionHandler(false, error.localizedDescription)
            } else {
                completionHandler(true, "")
            }
        }
    }
    
    //create user in database with given email and password
    static func createUser(email: String, password: String, completionHandler: @escaping (Bool?, String) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { (authResult, error) in
            if let error = error {
                print("User registration failed")
                completionHandler(false, error.localizedDescription)
            } else {
                print("User created successfully")
                completionHandler(true, "")
            }
        }
        
    }
    
    //logs user in if account already exists
    static func login(email: String, pass: String, completionHandler: @escaping (Bool?, String?) -> Void) {
        Auth.auth().signIn(withEmail: email, password: pass) { (result, error) in
            if let error = error, let _ = AuthErrorCode(rawValue: error._code) {
                print("Sign in failed: \(error.localizedDescription)")
                completionHandler(false, error.localizedDescription)
            } else {
                print("User signed in successfully")
                completionHandler(true, "")
            }
        }
    }
    
    //changes firebase email tied to account
    static func changeEmail(email: String, completionHandler: @escaping (Bool?, String?) -> Void) {
        //check if user is signed in with Apple
        if let providerId = Auth.auth().currentUser?.providerData.first?.providerID, providerId == "apple.com" {
            // Clear saved user ID from Sign In with Apple
            UserDefaults.standard.set(nil, forKey: "appleAuthorizedUserIdKey")
            completionHandler(false, "Your account is connected to Sign In with Apple, so there is no email to be changed. Jotify does not have access to a real email address.")
        } else {
            Auth.auth().currentUser?.updateEmail(to: email) { error in
                if let error = error, let _ = AuthErrorCode(rawValue: error._code) {
                    print("Email change failed: \(error.localizedDescription)")
                    completionHandler(false, error.localizedDescription)
                } else {
                    print("Email address successfully changed")
                    completionHandler(true, "Email address successfully changed")
                }
            }
        }
    }
    
    //delete a user account + all notes and settings tied to account
    static func deleteUser(completionHandler: @escaping (Bool?, String?) -> Void) {
        let user = Auth.auth().currentUser
        user?.delete { error in
          if let error = error {
            // An error happened.
            completionHandler(false, error.localizedDescription)
          } else {
            completionHandler(true, "Account successfully deleted.")
          }
        }
    }
    
}
