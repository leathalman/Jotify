//
//  AboutSettingsController.swift
//  Jotify
//
//  Created by Harrison Leath on 7/13/19.
//  Copyright © 2019 Harrison Leath. All rights reserved.
//

import UIKit

class AboutSettingsController: UIViewController {
    let aboutSettingsView = AboutSettingsView()

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "About"

        view = aboutSettingsView
        aboutSettingsView.versionLabel.textColor = InterfaceColors.fontColor
        aboutSettingsView.backgroundColor = InterfaceColors.viewBackgroundColor

        setupGestures()
    }

    func setupGestures() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(changeIcon))
        aboutSettingsView.icon.isUserInteractionEnabled = true
        aboutSettingsView.icon.addGestureRecognizer(tapGestureRecognizer)
    }

    @objc func changeIcon() {
        if UserDefaults.standard.bool(forKey: "com.austinleath.Jotify.Premium") == true {

            let iconName = UIApplication.shared.alternateIconName
            if UIApplication.shared.supportsAlternateIcons {
                if iconName == "Golden2" {
                    print("current icon is \(String(describing: iconName)), change to primary icon")
                    UIApplication.shared.setAlternateIconName("Default") { error in
                        if let error = error {
                            print(error.localizedDescription)
                        } else {
                            UIView.transition(with: self.aboutSettingsView.icon,
                                              duration: 0.25,
                                              options: .transitionCrossDissolve,
                                              animations: { self.aboutSettingsView.icon.image = UIImage(named: "defaultLarge") },
                                              completion: nil)
                            UIView.transition(with: self.aboutSettingsView.iconText,
                                              duration: 0.25,
                                              options: .transitionCrossDissolve,
                                              animations: { self.aboutSettingsView.iconText.image = UIImage(named: "defaultText") },
                                              completion: nil)
                        }
                    }

                } else {
                    print("current icon is primary icon, change to alternative icon")
                    UIApplication.shared.setAlternateIconName("Golden2") { error in
                        if let error = error {
                            print(error.localizedDescription)
                        } else {
                            UIView.transition(with: self.aboutSettingsView.icon,
                                              duration: 0.25,
                                              options: .transitionCrossDissolve,
                                              animations: { self.aboutSettingsView.icon.image = UIImage(named: "goldLarge") },
                                              completion: nil)
                            
                            if UserDefaults.standard.bool(forKey: "darkModeEnabled") == true {
                                UIView.transition(with: self.aboutSettingsView.iconText,
                                                  duration: 0.25,
                                                  options: .transitionCrossDissolve,
                                                  animations: { self.aboutSettingsView.iconText.image = UIImage(named: "goldTextAlt") },
                                                  completion: nil)
                            } else {
                                UIView.transition(with: self.aboutSettingsView.iconText,
                                                  duration: 0.25,
                                                  options: .transitionCrossDissolve,
                                                  animations: { self.aboutSettingsView.iconText.image = UIImage(named: "goldText") },
                                                  completion: nil)
                            }

                        }
                    }
                }
            }
        } else {
            print("Premium not enabled")
        }
    }
    
    func setupDefaultPersistentNavigationBar() {
        navigationController?.navigationBar.backgroundColor = InterfaceColors.navigationBarColor
        navigationController?.navigationBar.barTintColor = InterfaceColors.navigationBarColor
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
        navigationController?.navigationBar.barStyle = .default
        navigationController?.navigationBar.isTranslucent = false
    }
    
    func setupDarkPersistentNavigationBar() {
        navigationController?.navigationBar.backgroundColor = InterfaceColors.navigationBarColor
        navigationController?.navigationBar.barTintColor = InterfaceColors.navigationBarColor
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navigationController?.navigationBar.barStyle = .black
        navigationController?.navigationBar.isTranslucent = false
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        let themes = Themes()
        themes.triggerSystemMode(mode: traitCollection)
        aboutSettingsView.versionLabel.textColor = InterfaceColors.fontColor
        aboutSettingsView.backgroundColor = InterfaceColors.viewBackgroundColor
        
        let iconName = UIApplication.shared.alternateIconName
        if UIApplication.shared.supportsAlternateIcons {
            if iconName == "Golden2", UserDefaults.standard.bool(forKey: "darkModeEnabled") == true {
                aboutSettingsView.iconText.image = UIImage(named: "goldTextAlt")
                
            } else if iconName == "Golden2", UserDefaults.standard.bool(forKey: "darkModeEnabled") == false {
                aboutSettingsView.iconText.image = UIImage(named: "goldText")
                
            } else {
                aboutSettingsView.iconText.image = UIImage(named: "defaultText")
            }
        }
        
        if UserDefaults.standard.bool(forKey: "useSystemMode") {
            if UserDefaults.standard.bool(forKey: "darkModeEnabled") {
                setupDarkPersistentNavigationBar()
            } else if UserDefaults.standard.bool(forKey: "darkModeEnabled") == false {
                setupDefaultPersistentNavigationBar()
            }
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        if UserDefaults.standard.bool(forKey: "useSystemMode") == false && UserDefaults.standard.bool(forKey: "darkModeEnabled") == false {
            return .darkContent
        } else if UserDefaults.standard.bool(forKey: "useSystemMode") == false && UserDefaults.standard.bool(forKey: "darkModeEnabled") == true {
            return .lightContent
        } else if UserDefaults.standard.bool(forKey: "useSystemMode") && traitCollection.userInterfaceStyle == .light {
            return .darkContent
        } else {
            return .lightContent
        }
    }
}
