//
//  Login.swift
//  Jotify
//
//  Created by Harrison Leath on 1/25/21.
//

import UIKit

class LoginController: AuthenticationController {
        
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    //customize generic view from AuthenticationController for login
    func setupView() {
        view.backgroundColor = .mineShaft
        submitButton.setTitle("Log In", for: .normal)
        submitButton.addTarget(self, action: #selector(didSubmitLogin), for: .touchUpInside)
        changeColorOfVCButton()
    }
    
    //objc function for signing a user in when button is pressed
    @objc func didSubmitLogin() {
        guard let email = usernameField.text, let password = passwordField.text else { return }
        AuthManager.login(email: email, pass: password) { (success, message) in
            if !success! {
                let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                self.present(alertController, animated: true, completion: nil)
            } else {
                //change rootViewController to PageViewController w/ animation
                self.setRootViewController(vc: PageViewController())
            }
        }
    }
}
