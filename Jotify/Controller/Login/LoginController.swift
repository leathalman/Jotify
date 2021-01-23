//
//  LoginController.swift
//  Zurich
//
//  Created by Harrison Leath on 1/11/21.
//

import UIKit

class LoginController: UIViewController {
    
    lazy var usernameField: UITextField = {
        let frame = CGRect(x: 20, y: 100, width: UIScreen.main.bounds.width / 1.4, height: 100)
        let textField = UITextField(frame: frame)
        textField.backgroundColor = .red
        textField.textColor = .white
        textField.font = UIFont.boldSystemFont(ofSize: 32)
        textField.placeholder = "Username"
        textField.autocapitalizationType = .none
        return textField
    }()
    
    lazy var passwordField: UITextField = {
        let frame = CGRect(x: 20, y: 225, width: UIScreen.main.bounds.width / 1.4, height: 100)
        let textField = UITextField(frame: frame)
        textField.backgroundColor = .red
        textField.textColor = .white
        textField.font = UIFont.boldSystemFont(ofSize: 32)
        textField.placeholder = "Password"
        textField.autocapitalizationType = .none
        return textField
    }()
    
    lazy var submitButton: UIButton = {
        let frame = CGRect(x: 20, y: 300, width: 200, height: 100)
        let button = UIButton(frame: frame)
        button.backgroundColor = .purple
        button.setTitle("Login", for: .normal)
        button.addTarget(self, action: #selector(didSubmitLogin), for: .touchUpInside)
        return button
    }()
    
    lazy var loginInButton: UIButton = {
        let frame = CGRect(x: 20, y: 425, width: 200, height: 100)
        let button = UIButton(frame: frame)
        button.backgroundColor = .purple
        button.setTitle("Sign Up Instead", for: .normal)
        button.addTarget(self, action: #selector(didPresentSignUp), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .green
        view.addSubview(usernameField)
        view.addSubview(passwordField)
        view.addSubview(submitButton)
        view.addSubview(loginInButton)
    }
    
    @objc func didSubmitLogin() {
        let authManager = AuthManager()
        guard let email = usernameField.text, let password = passwordField.text else { return }
        authManager.login(email: email, pass: password) {[weak self] (success) in
            guard let `self` = self else { return }
            var message: String = ""
            if (success) {
                message = "User was sucessfully logged in."
            } else {
                message = "There was an error."
            }
            let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    @objc func didPresentSignUp() {
        present(SignUpController(), animated: true)
    }
    
}
