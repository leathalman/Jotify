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
    
    //signs user out of firebase
    static func signOut() {
        do { try Auth.auth().signOut() }
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
}
