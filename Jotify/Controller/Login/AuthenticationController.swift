//
//  AuthenticationController.swift
//  Jotify
//
//  Created by Harrison Leath on 1/31/21.
//

import UIKit

//superclass for authentication workflow
class AuthenticationController: UIViewController {
    
    //view elements
    let textView: UITextView = {
        let view = UITextView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isUserInteractionEnabled = false
        view.layer.masksToBounds = true
        view.backgroundColor = .clear
        return view
    }()
    
    let usernameField: UITextField = {
        let text = UITextField()
        text.translatesAutoresizingMaskIntoConstraints = false
        text.backgroundColor = UIColor.mineShaft.adjust(by: -2)
        text.layer.cornerRadius = 10
        text.textColor = .white
        text.attributedPlaceholder = NSAttributedString(string: "Email", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white.adjust(by: -40) as Any])
        text.font = .boldSystemFont(ofSize: 25)
        text.borderStyle = .none
        text.autocapitalizationType = .none
        text.autocorrectionType = .no
        return text
    }()
    
    let passwordField: UITextField = {
        let text = UITextField()
        text.translatesAutoresizingMaskIntoConstraints = false
        text.backgroundColor = UIColor.mineShaft.adjust(by: -2)
        text.layer.cornerRadius = 10
        text.textColor = .white
        text.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white.adjust(by: -40) as Any])
        text.font = .boldSystemFont(ofSize: 25)
        text.borderStyle = .none
        text.isSecureTextEntry = true
        return text
    }()
    
    let submitButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 10
        button.titleLabel?.font = .boldSystemFont(ofSize: 20)
        return button
    }()
    
    let changeVCButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 10
        button.titleLabel?.font = .boldSystemFont(ofSize: 20)
        button.addTarget(self, action: #selector(changeVC), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        view.addSubview(textView)
        view.addSubview(usernameField)
        view.addSubview(passwordField)
        view.addSubview(submitButton)
        view.addSubview(changeVCButton)
        setupConstraints()
        changeColorOfTextView()
        self.hideKeyboardWhenTappedAround()
    }
    
    //objc function for switching between login and signup
    @objc func changeVC() {
        //change rootViewController based on requested controller
        switch submitButton.titleLabel?.text {
        case "Sign Up":
            self.setRootViewController(vc: LoginController())
        case "Log In":
            self.setRootViewController(vc: SignUpController())
        default:
            print("failed to present authentication controller")
        }
    }
    
    //create string with attributes for title textView
    func changeColorOfTextView() {
        let firstAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 60)]
        let secondAttributes = [NSAttributedString.Key.foregroundColor: UIColor.systemBlue, NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 60)]
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 3
        
        let firstString = NSMutableAttributedString(string: "Welcome to ", attributes: firstAttributes)
        let secondString = NSAttributedString(string: "Jotify.", attributes: secondAttributes)
        
        firstString.append(secondString)
        firstString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, firstString.length))
        
        textView.attributedText = firstString
    }
    
    //change title of VC button based on current VC presented
    func changeColorOfVCButton() {
        var title = ""
        switch submitButton.titleLabel?.text {
        case "Sign Up":
            title = "Already have an account?"
        case "Log In":
            title = "Need to create an account?"
        default:
            print("failed to present authentication controller")
        }
        changeVCButton.setTitle(title, for: .normal)
    }
    
    func setupConstraints() {
        //constraints for title textview
        textView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        textView.topAnchor.constraint(equalTo: view.topAnchor, constant: 130).isActive = true
        textView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8).isActive = true
        textView.heightAnchor.constraint(equalToConstant: 150).isActive = true
        
        //constraints for the username textfield
        usernameField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        usernameField.topAnchor.constraint(equalTo: textView.bottomAnchor, constant: 60).isActive = true
        usernameField.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8).isActive = true
        usernameField.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        //constraints for the password textfield
        passwordField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        passwordField.topAnchor.constraint(equalTo: usernameField.bottomAnchor, constant: 18).isActive = true
        passwordField.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8).isActive = true
        passwordField.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        //constraints for the signup button
        submitButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        submitButton.topAnchor.constraint(equalTo: passwordField.bottomAnchor, constant: 45).isActive = true
        submitButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8).isActive = true
        submitButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        //constraints for change VC button
        changeVCButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        changeVCButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -80).isActive = true
        changeVCButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8).isActive = true
        changeVCButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        usernameField.setLeftPadding(12)
        passwordField.setLeftPadding(12)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
}
