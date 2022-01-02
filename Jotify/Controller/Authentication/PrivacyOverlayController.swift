//
//  PrivacyOverlayController.swift
//  Jotify
//
//  Created by Harrison Leath on 1/2/22.
//

import SwiftUI
import UIKit
import LocalAuthentication

class PrivacyOverlayController: UIViewController {
    
    var jotifyIconView = UIImageView()
    
    override func viewDidLoad() {
        setupView()
        authenticate()
    }
    
    func setupView() {
        view.backgroundColor = .jotifyGray
        
        jotifyIconView = UIImageView(image: UIImage(named: "icon"))
        jotifyIconView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(jotifyIconView)
        
        jotifyIconView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        jotifyIconView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -175).isActive = true
        jotifyIconView.widthAnchor.constraint(equalToConstant: 100).isActive = true
        jotifyIconView.heightAnchor.constraint(equalToConstant: 100).isActive = true
    }
    
    func authenticate() {
        let context = LAContext()
        let reason = "Unlock Jotify to access your notes."
        
        context.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: reason) { success, _ in
            DispatchQueue.main.async {
                if success {
                    print("successful auth")
                    self.dismiss(animated: true, completion: nil)
                } else {
                    print("error auth")
                    //add unlock and log out buttons for classic PIN / alphanumeric auth
                    self.addOptionalButtons()
                }
            }
        }
    }
    
    //add buttons to view when user authenication fails the first time
    func addOptionalButtons() {
        let unlockButton = UIButton()
        unlockButton.setTitle("Unlock", for: .normal)
        unlockButton.setTitleColor(.white, for: .normal)
        unlockButton.addTarget(self, action: #selector(unlock), for: .touchUpInside)
        unlockButton.translatesAutoresizingMaskIntoConstraints = false
        unlockButton.backgroundColor = UIColor.jotifyBlue
        unlockButton.layer.cornerRadius = 10
        unlockButton.alpha = 0
        
        let logoutLabel = UIButton()
        logoutLabel.setTitle("Log Out", for: .normal)
        logoutLabel.setTitleColor(.jotifyBlue, for: .normal)
        logoutLabel.addTarget(self, action: #selector(logout), for: .touchUpInside)
        logoutLabel.translatesAutoresizingMaskIntoConstraints = false
        logoutLabel.backgroundColor = .clear
        logoutLabel.alpha = 0
        
        view.addSubview(unlockButton)
        view.addSubview(logoutLabel)
        
        UIView.animate(withDuration: 0.4, animations: {
            unlockButton.alpha = 1
            logoutLabel.alpha = 1
        })

        unlockButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        unlockButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -125).isActive = true
        unlockButton.widthAnchor.constraint(equalToConstant: 250).isActive = true
        unlockButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        logoutLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        logoutLabel.bottomAnchor.constraint(equalTo: unlockButton.bottomAnchor, constant: 50).isActive = true
        logoutLabel.widthAnchor.constraint(equalToConstant: 250).isActive = true
        logoutLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    @objc func unlock() {
        let context = LAContext()
        let reason = "Unlock Jotify to access your notes."
        
        //unlock with PIN / alphanumeric
        context.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: reason) { success, _ in
            DispatchQueue.main.async {
                if success {
                    print("successful auth")
                    self.dismiss(animated: true, completion: nil)
                } else {
                    print("error auth")
                }
            }
        }
    }
    
    @objc func logout() {
        AuthManager.signOut()
        setRootViewController(duration: 0.4, vc: UIHostingController(rootView: LogInView()))
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .darkContent
    }
}
