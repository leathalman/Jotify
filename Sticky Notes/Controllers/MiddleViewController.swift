//
//  MiddleViewController.swift
//  Sticky Notes
//
//  Created by Harrison Leath on 5/8/19.
//  Copyright © 2019 Harrison Leath. All rights reserved.
//

import UIKit
import Firebase

class MiddleViewController: UIViewController, UITextFieldDelegate {
    
    lazy var inputTextField: UITextField = {
        let textField =  UITextField(frame: CGRect(x: 20, y: 100, width: 300, height: 40))
        textField.placeholder = "Enter text here"
        textField.font = UIFont.systemFont(ofSize: 15)
        textField.borderStyle = UITextField.BorderStyle.roundedRect
        textField.autocorrectionType = UITextAutocorrectionType.no
        textField.keyboardType = UIKeyboardType.default
        textField.clearButtonMode = UITextField.ViewMode.whileEditing
        textField.contentVerticalAlignment = UIControl.ContentVerticalAlignment.center
        return textField
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print ("Middle View Loaded")
        
        self.inputTextField.delegate = self
        
        let button = UIButton()
        button.addTarget(self, action: #selector(logoutTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(button)
        button.setTitle("Logout", for: .normal)
        button.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        button.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        let button2 = UIButton()
        button2.addTarget(self, action: #selector(sendTapped), for: .touchUpInside)
        button2.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(button2)
        button2.setTitle("Send", for: .normal)
        button2.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        button2.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -100).isActive = true
        
        let button3 = UIButton()
        button3.addTarget(self, action: #selector(removeTapped), for: .touchUpInside)
        button3.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(button3)
        button3.setTitle("Remove ALL", for: .normal)
        button3.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        button3.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 100).isActive = true
        
        
        self.view.addSubview(inputTextField)
        checkIfUserIsLoggedIn()
    }
    
    @objc func handleSend() {
        let properties = ["text": inputTextField.text!]
        saveNote(properties: properties)
    }
    
    private func saveNote(properties: [String: Any]) {
        let ref = Database.database().reference().child("notes")
        let childRef = ref.childByAutoId()
        let userId = Auth.auth().currentUser!.uid
        let timestamp = (NSDate().timeIntervalSince1970)
        
        var values: [String: Any] = ["userId": userId, "timestamp": timestamp] as [String : Any]
        
        properties.forEach({values[$0.0] = $0.1})
        
        childRef.updateChildValues(values) { (error, ref ) in
            if error != nil {
                print(error ?? "error updating child values")
                return
            }
            
            self.inputTextField.text = nil
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        handleSend()
        return true
    }
    
    
    @objc private func logoutTapped() {
        handleLogout()
    }
    
    @objc private func sendTapped() {
        handleSend()
    }
    
    @objc private func removeTapped() {
        let ref = Database.database().reference().child("notes")
        ref.removeValue()
    }
    
    func checkIfUserIsLoggedIn() {
        //user is not logged in
        if Auth.auth().currentUser?.uid == nil {
            perform(#selector(handleLogout), with: nil, afterDelay: 0)
            handleLogout()
            
        } else {
            print("Logged in")
        }
    }
    
    @objc func handleLogout() {
        
        do {
            try Auth.auth().signOut()
        } catch _ {
            print("Logout Error!")
            
        }
        
        let loginController = LoginController()
        loginController.middleViewController = self
        present(loginController, animated: true, completion: nil)
    }
}
