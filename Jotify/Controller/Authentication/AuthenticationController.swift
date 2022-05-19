//
//  AuthenticationController.swift
//  Jotify
//
//  Created by Harrison Leath on 1/31/21.
//

import UIKit
import SwiftUI

//superclass for authentication workflow
class AuthenticationController: UIViewController {
    
    var currentNonce: String?

    let signUp = UIHostingController(rootView: SignUpView())
    let logIn = UIHostingController(rootView: LogInView())
    let noteCollectionController = UINavigationController(rootViewController: NoteCollectionController(collectionViewLayout: UICollectionViewFlowLayout()))
    
    func userDidSubmitSignUp(email: String, password: String) {
        AuthManager.createUser(email: email, password: password) { (success, message) in
            if !success! {
                let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                self.rootViewController.present(alertController, animated: true, completion: nil)
            } else {
                AnalyticsManager.logEvent(named: "sign_up", description: "sign_up")
                DataManager.createUserSettings { (success) in }
                //change rootViewController to PageViewController w/ animation
                self.setRootViewController(duration: 0.2, vc: PageBoyController())
            }
        }
    }
    
    func userDidSubmitLogIn(email: String, password: String) {
        AuthManager.login(email: email, pass: password) { (success, message) in
            if !success! {
                let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                self.rootViewController.present(alertController, animated: true, completion: nil)
            } else {
                AnalyticsManager.logEvent(named: "log_in", description: "log_in")
                User.updateSettings()
                //change rootViewController to PageViewController w/ animation
                self.setRootViewController(duration: 0.2, vc: PageBoyController())
            }
        }
    }
    
    func userDidForgetPassword() {
        let alertController = UIAlertController(title: nil, message: "What email is your account under?", preferredStyle: .alert)
        alertController.addTextField { (textField) in
            textField.placeholder = "Enter an email."
        }
        alertController.addAction(UIAlertAction(title: "Send", style: .default, handler: { (action) in
            AuthManager.forgotPassword(email: (alertController.textFields?.first?.text)!) { (success, message) in
                if success! {
                    print("recovery email sent")
                    let alertController = UIAlertController(title: nil, message: "Password recovery email successfully sent to \(alertController.textFields?.first?.text ?? "")", preferredStyle: .alert)
                    alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    AnalyticsManager.logEvent(named: "password_reset", description: "password_reset")
                    self.rootViewController.present(alertController, animated: true, completion: nil)
                } else {
                    print("recovery email was unable to be sent")
                    let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
                    alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.rootViewController.present(alertController, animated: true, completion: nil)
                }
            }
        }))
        alertController.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
        self.rootViewController.present(alertController, animated: true, completion: nil)
    }
    
    func presentSignUp() {
        self.setRootViewController(duration: 0.2, vc: signUp)
    }
    
    func presentLogIn() {
        self.setRootViewController(duration: 0.2, vc: logIn)
    }
    
}
