//
//  SettingsController.swift
//  Sticky Notes
//
//  Created by Harrison Leath on 5/12/19.
//  Copyright © 2019 Harrison Leath. All rights reserved.
//

import UIKit
import Firebase

class SettingsController: UIViewController {
    
    override func viewDidLoad() {
        title = "Settings"
        
        view.backgroundColor = .white
        
        let button = UIButton()
        button.addTarget(self, action: #selector(logoutTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(button)
        button.setTitle("Logout", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        button.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        let button2 = UIButton()
        button2.addTarget(self, action: #selector(sendTapped), for: .touchUpInside)
        button2.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(button2)
        button2.setTitle("Back", for: .normal)
        button2.setTitleColor(.black, for: .normal)
        button2.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        button2.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -100).isActive = true
        
        let button3 = UIButton()
        button3.addTarget(self, action: #selector(removeTapped), for: .touchUpInside)
        button3.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(button3)
        button3.setTitle("Remove ALL", for: .normal)
        button3.setTitleColor(.black, for: .normal)
        button3.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        button3.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 100).isActive = true
        
    }
    
    @objc private func logoutTapped() {
        handleLogout()
    }
    
    @objc private func sendTapped() {
        handleSend()
    }
    
    @objc func handleSend() {
        dismiss(animated: false, completion: nil)
    }
    
    @objc private func removeTapped() {
        //test removing messages from Firestore database
    }
    
    @objc func handleLogout() {
        
        do {
            try Auth.auth().signOut()
        } catch _ {
            print("Logout Error!")
            
        }
        
        let loginController = LoginController()
        present(loginController, animated: true, completion: nil)
    }
    
}
