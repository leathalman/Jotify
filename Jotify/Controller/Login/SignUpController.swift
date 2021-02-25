//
//  ViewController.swift
//  Zurich
//
//  Created by Harrison Leath on 1/11/21.
//

import UIKit

class SignUpController: AuthenticationController {
        
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    //customize generic view from AuthenticationController for sign up
    func setupView() {
        view.backgroundColor = .mineShaft
        submitButton.setTitle("Sign Up", for: .normal)
        submitButton.addTarget(self, action: #selector(didSubmitSignUp), for: .touchUpInside)
        changeColorOfVCButton()
    }
    
    //objc function for signing a user in when button is pressed
    @objc func didSubmitSignUp() {
        guard let email = usernameField.text, let password = passwordField.text else { return }
        AuthManager.createUser(email: email, password: password) { (success, message) in
            if !success! {
                let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                self.present(alertController, animated: true, completion: nil)
            } else {
                DataManager.createUserSettings { (success) in }
                //change rootViewController to PageViewController w/ animation
                self.setRootViewController(vc: PageViewController())
            }
        }
    }
}
