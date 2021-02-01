//
//  AuthManager.swift
//  Zurich
//
//  Created by Harrison Leath on 1/11/21.
//

import FirebaseAuth

class AuthManager {
    
    public var uid: String {
        if Auth.auth().currentUser != nil {
            return Auth.auth().currentUser?.uid ?? ""
        }
        return ""
    }
    
    static func signOut() {
        do { try Auth.auth().signOut() }
        catch { print("User already logged out") }
    }
    
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
}
