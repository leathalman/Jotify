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
    
    //put error in completion block instead of bool
    func createUser(email: String, password: String, completionBlock: @escaping (_ success: Bool) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) {(authResult, error) in
            if error != nil {
                print("User creation failed: \(error!.localizedDescription)")
                completionBlock(false)
            } else {
                print("User created successfully")
                completionBlock(true)
            }
        }
    }
    
    func login(email: String, pass: String, completionBlock: @escaping (_ success: Bool) -> Void) {
        Auth.auth().signIn(withEmail: email, password: pass) { (result, error) in
            if let error = error, let _ = AuthErrorCode(rawValue: error._code) {
                print("Sign in failed: \(error.localizedDescription)")
                completionBlock(false)
            } else {
                print("User signed in successfully")
                completionBlock(true)
            }
        }
    }
}
