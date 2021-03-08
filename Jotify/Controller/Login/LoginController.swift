//
//  Login.swift
//  Jotify
//
//  Created by Harrison Leath on 1/25/21.
//

import UIKit

class LoginController: AuthenticationController {
    
    //view elements
    let forgotPasswordButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = ColorManager.noteColor
        button.layer.cornerRadius = 10
        button.titleLabel?.font = .boldSystemFont(ofSize: 20)
        button.setTitle("Forgot Password?", for: .normal)
        button.addTarget(self, action: #selector(handleForgotPassword), for: .touchUpInside)
        return button
    }()
    
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
        
        view.addSubview(forgotPasswordButton)
        setupForgotPasswordButtonConstraints()
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
                User.retrieveSettingsFromFirebase()
                //change rootViewController to PageViewController w/ animation
                self.setRootViewController(vc: PageViewController())
            }
        }
    }
    
    //handles the workflow involved with resetting a user's password
    //asks for an email from the user, then talks to AuthManager to connect with FirebaseAuth
    //if email is sent, confirmation message is shown, otherwise error message is shown
    @objc func handleForgotPassword() {
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
                    self.present(alertController, animated: true, completion: nil)
                } else {
                    print("recovery email was unable to be sent")
                    let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
                    alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(alertController, animated: true, completion: nil)
                }
            }
        }))
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    
    func setupForgotPasswordButtonConstraints() {
        //constraints only used in LoginController
        forgotPasswordButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        forgotPasswordButton.bottomAnchor.constraint(equalTo: changeVCButton.topAnchor, constant: -18).isActive = true
        forgotPasswordButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8).isActive = true
        forgotPasswordButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
}
