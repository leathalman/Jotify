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
}
