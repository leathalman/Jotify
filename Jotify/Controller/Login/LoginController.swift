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
        changeColorOfVCButton()
        submitButton.setTitle("Log In", for: .normal)
        submitButton.addTarget(self, action: #selector(didSubmitLogin), for: .touchUpInside)
        changeVCButton.addTarget(self, action: #selector(changeVC), for: .touchUpInside)
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
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    func changeColorOfVCButton() {
        let firstAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 20)]
        let secondAttributes = [NSAttributedString.Key.foregroundColor: UIColor.systemBlue, NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 20)]
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 3
        
        let firstString = NSMutableAttributedString(string: "Need to sign up? ", attributes: firstAttributes)
        let secondString = NSAttributedString(string: "Press here.", attributes: secondAttributes)
        
        firstString.append(secondString)
        firstString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, firstString.length))
        
        changeVCButton.setAttributedTitle(firstString, for: .normal)
    }
}
