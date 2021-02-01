//
//  AuthenticationController.swift
//  Jotify
//
//  Created by Harrison Leath on 1/31/21.
//

import UIKit

//super class for authentication workflow
class AuthenticationController: UIViewController {
    
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
        text.placeholder = "Example@me.com"
        text.textColor = .white
        text.font = .boldSystemFont(ofSize: 25)
        text.borderStyle = .roundedRect
        return text
    }()
    
    let passwordField: UITextField = {
        let text = UITextField()
        text.translatesAutoresizingMaskIntoConstraints = false
        text.placeholder = "Password"
        text.textColor = .white
        text.font = .boldSystemFont(ofSize: 25)
        text.borderStyle = .roundedRect
        text.isSecureTextEntry = true
        return text
    }()
    
    let submitButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .clear
        button.layer.cornerRadius = 5
        button.layer.borderWidth = 5
        button.layer.borderColor = UIColor.systemBlue.cgColor
        return button
    }()
    
    let changeVCButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .clear
        button.layer.cornerRadius = 5
        button.layer.borderWidth = 5
        button.layer.borderColor = UIColor.systemBlue.cgColor
        return button
    }()
    
    override func viewDidLoad() {
        view.addSubview(textView)
        view.addSubview(usernameField)
        view.addSubview(passwordField)
        view.addSubview(submitButton)
        view.addSubview(changeVCButton)
        setupConstraints()
        self.hideKeyboardWhenTappedAround()
        changeColorOfTextView()
    }
    
    //objc function for switching between login and signup
    @objc func changeVC() {
        self.dismiss(animated: true, completion: nil)
        let keyWindow = UIApplication.shared.connectedScenes
                .filter({$0.activationState == .foregroundActive})
                .map({$0 as? UIWindowScene})
                .compactMap({$0})
                .first?.windows
                .filter({$0.isKeyWindow}).first
        switch submitButton.titleLabel?.text {
        case "Sign Up":
            let lg = LoginController()
            lg.modalPresentationStyle = .fullScreen
            keyWindow?.rootViewController?.present(lg, animated: true, completion: nil)
        case "Log In":
            let sn = SignUpController()
            sn.modalPresentationStyle = .fullScreen
            keyWindow?.rootViewController?.present(sn, animated: true, completion: nil)
        default:
            print("failed to present authentication controller")
        }
    }
    
    //add attributes to string
    func changeColorOfTextView() {
        let firstAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 60)]
        let secondAttributes = [NSAttributedString.Key.foregroundColor: UIColor.systemBlue, NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 60)]
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 3
        
        let firstString = NSMutableAttributedString(string: "Welcome to ", attributes: firstAttributes)
        let secondString = NSAttributedString(string: "Jotify", attributes: secondAttributes)
        let thirdString = NSAttributedString(string: ".", attributes: firstAttributes)
        
        firstString.append(secondString)
        firstString.append(thirdString)
        
        firstString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, firstString.length))
        
        textView.attributedText = firstString
    }
    
    func setupConstraints() {
        //constraints for title textview
        textView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 25).isActive = true
        textView.topAnchor.constraint(equalTo: view.topAnchor, constant: 130).isActive = true
        textView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -40).isActive = true
        textView.heightAnchor.constraint(equalToConstant: 150).isActive = true
        
        //constraints for the username textfield
        usernameField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        usernameField.topAnchor.constraint(equalTo: textView.bottomAnchor, constant: 60).isActive = true
        usernameField.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -40).isActive = true
        usernameField.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        //constraints for the password textfield
        passwordField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        passwordField.topAnchor.constraint(equalTo: usernameField.bottomAnchor, constant: 30).isActive = true
        passwordField.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -40).isActive = true
        passwordField.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        //constraints for the signup button
        submitButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        submitButton.topAnchor.constraint(equalTo: passwordField.bottomAnchor, constant: 45).isActive = true
        submitButton.widthAnchor.constraint(equalTo: passwordField.widthAnchor, multiplier: 0.5).isActive = true
        submitButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        //constraints for change VC button
        changeVCButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        changeVCButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -80).isActive = true
        changeVCButton.widthAnchor.constraint(equalToConstant: 360).isActive = true
        changeVCButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
}
