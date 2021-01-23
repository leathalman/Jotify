//
//  ViewController.swift
//  Zurich
//
//  Created by Harrison Leath on 1/11/21.
//

import UIKit

class SignUpController: UIViewController {
    
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
        button.setTitle("Sign Up", for: .normal)
        button.addTarget(self, action: #selector(didSubmitSignUp), for: .touchUpInside)
        return button
    }()
    
    lazy var loginInButton: UIButton = {
        let frame = CGRect(x: 20, y: 500, width: 200, height: 100)
        let button = UIButton(frame: frame)
        button.backgroundColor = .purple
        button.setTitle("Login instead", for: .normal)
        button.addTarget(self, action: #selector(didPresentLogin), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .blue
        view.addSubview(usernameField)
        view.addSubview(passwordField)
        view.addSubview(submitButton)
        view.addSubview(loginInButton)
    }
    
    @objc func didSubmitSignUp() {
        let authManager = AuthManager()
        if let email = usernameField.text, let password = passwordField.text {
            authManager.createUser(email: email, password: password) {[weak self] (success) in
                guard let `self` = self else { return }
                var message: String = ""
                if (success) {
                    message = "User was sucessfully created."
                } else {
                    message = "There was an error."
                }
                let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                self.present(alertController, animated: true, completion: nil)
            }
        }
    }
    
    @objc func didPresentLogin() {
        let loginController = LoginController()
        loginController.modalPresentationStyle = .fullScreen
        present(loginController, animated: false)
    }
}
