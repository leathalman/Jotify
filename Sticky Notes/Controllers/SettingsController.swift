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
        view.backgroundColor = .red
        
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
        button2.setTitle("Back", for: .normal)
        button2.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        button2.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -100).isActive = true
        
        let button3 = UIButton()
        button3.addTarget(self, action: #selector(removeTapped), for: .touchUpInside)
        button3.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(button3)
        button3.setTitle("Remove ALL", for: .normal)
        button3.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        button3.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 100).isActive = true
        
//        setupSwiftDown()
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
//        let ref = Database.database().reference().child("notes")
//        ref.removeValue()
    }
    
    func setupSwiftDown() {
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(self.handleSwipeDown(_:)))
        swipeDown.direction = .down
        view.addGestureRecognizer(swipeDown)
        view.isUserInteractionEnabled = true
    }
    
    @objc func handleSwipeDown(_ sender: UITapGestureRecognizer) {
        dismiss(animated: false, completion: nil)
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
