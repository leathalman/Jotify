//
//  PrivacySettingsController.swift
//  Jotify
//
//  Created by Harrison Leath on 8/4/19.
//  Copyright © 2019 Harrison Leath. All rights reserved.
//

import LocalAuthentication
import UIKit

class PrivacySettingsController: UITableViewController {
    let sections: Array = ["Biometrics"]
    let biometrics: Array = ["Use Touch ID or Face ID"]
    
    let settingsController = SettingsController()
    let blurEffectView = UIVisualEffectView()
    
    let defaults = UserDefaults.standard
    
    let unlockButton: UIButton = {
        let button = UIButton()
        button.frame = CGRect(x: 0, y: 0, width: 150, height: 50)
        button.setTitle("Unlock Jotify", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.isUserInteractionEnabled = true
        button.layer.cornerRadius = 5
        button.tag = 101
        
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Privacy"
        
        setupDynamicElements()
        
        UIApplication.shared.windows.first?.backgroundColor = UIColor.grayBackground
        
        tableView.register(SettingsSwitchCell.self, forCellReuseIdentifier: "SettingsSwitchCell")
    }
    
    func setupDynamicElements() {
        if settingsController.darkModeEnabled() {
            view.backgroundColor = InterfaceColors.viewBackgroundColor
            tableView.separatorColor = InterfaceColors.separatorColor
            
        } else {
            view.backgroundColor = InterfaceColors.viewBackgroundColor
            tableView.separatorColor = nil
        }
    }
    
    func setupBiometricsView(window: UIWindow) {
        let blurEffect = UIBlurEffect(style: .dark)
        blurEffectView.effect = blurEffect
        blurEffectView.frame = window.frame
        blurEffectView.alpha = 1
                
        unlockButton.center = window.center
        
        if !defaults.bool(forKey: "useRandomColor")  {
            unlockButton.backgroundColor = defaults.color(forKey: "staticNoteColor") ?? UIColor.white
            
        } else {
            if isSelectedColorFromDefaults(key: "default") {
                unlockButton.backgroundColor = UIColor.defaultColors.randomElement() ?? UIColor.blue2
                
            } else if isSelectedColorFromDefaults(key: "sunset") {
                unlockButton.backgroundColor = UIColor.sunsetColors.randomElement() ?? UIColor.blue2
                
            } else if isSelectedColorFromDefaults(key: "kypool") {
                unlockButton.backgroundColor = UIColor.kypoolColors.randomElement() ?? UIColor.blue2
                
            } else if isSelectedColorFromDefaults(key: "celestial") {
                unlockButton.backgroundColor = UIColor.celestialColors.randomElement() ?? UIColor.blue2
                
            } else if isSelectedColorFromDefaults(key: "appleVibrant") {
                unlockButton.backgroundColor = UIColor.appleVibrantColors.randomElement() ?? UIColor.blue2
                
            } else if isSelectedColorFromDefaults(key: "scarletAzure") {
                unlockButton.backgroundColor = UIColor.scarletAzureColors.randomElement() ?? UIColor.blue2
            }
        }
        
        blurEffectView.tag = 100
        unlockButton.alpha = 0
        
        window.addSubview(blurEffectView)
        window.addSubview(unlockButton)
    }
    
    func authenticateUserWithBioMetrics(window: UIWindow) {
        let context = LAContext()
        var error: NSError?
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "Unlock Jotify to access your notes."
            
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, _ in
                
                DispatchQueue.main.async {
                    if success {
                        print("success with biometrics")
                        window.viewWithTag(101)?.removeFromSuperview()
                        
                        UIView.animate(withDuration: 0.2, animations: {
                            window.viewWithTag(100)?.alpha = 0
                        }) { _ in
                            self.blurEffectView.removeFromSuperview()
                        }
                        
                    } else {
                        print("error with biometrics")
                        UIView.animate(withDuration: 0.2, animations: {
                            self.unlockButton.alpha = 1
                        }) { _ in
                        }
                    }
                }
            }
        } else {
            // no biometrics
        }
    }
    
    func removeBlurView(window: UIWindow) {
        window.viewWithTag(100)?.removeFromSuperview()
        window.viewWithTag(101)?.removeFromSuperview()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsSwitchCell", for: indexPath) as! SettingsSwitchCell
            cell.textLabel?.text = "\(biometrics[indexPath.row])"
            
            settingsController.setupDynamicCells(cell: cell, enableArrow: false)
            
            cell.selectionStyle = .none
            cell.switchButton.addTarget(self, action: #selector(useBiometricsSwitchPressed(sender:)), for: .valueChanged)
            
            if defaults.bool(forKey: "useBiometrics") {
                cell.switchButton.isOn = true
            } else {
                cell.switchButton.isOn = false
            }
            
            return cell
            
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsCell", for: indexPath) as! SettingsCell
            
            cell.backgroundColor = UIColor.white
            cell.textLabel?.textColor = UIColor.black
            return cell
        }
    }
    
    @objc func useBiometricsSwitchPressed(sender: UISwitch) {
        if !defaults.bool(forKey: "com.austinleath.Jotify.Premium") {
            PremiumView.shared.presentPremiumView(viewController: self)
            sender.isOn = false
            
        } else {
            if sender.isOn {
                print("useBiometrics enabled")
                defaults.set(true, forKey: "useBiometrics")
                
            } else {
                print("useBiometrics disabled")
                defaults.set(false, forKey: "useBiometrics")
            }
        }
    }
    
    func isSelectedColorFromDefaults(key: String) -> Bool {
        let colorTheme = defaults.string(forKey: "noteColorTheme")
        
        if colorTheme == key {
            return true
        } else {
            return false
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Use Touch ID or Face ID to authenticate Jotify and keep your notes private."
        default:
            return ""
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section]
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return biometrics.count
        } else {
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        Themes().triggerSystemMode(mode: traitCollection)
        setupDynamicElements()
        tableView.reloadData()
        
        Themes().setupPersistentNavigationBar(navController: navigationController ?? UINavigationController())
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        if !UserDefaults.standard.bool(forKey: "useSystemMode") && !UserDefaults.standard.bool(forKey: "darkModeEnabled") {
            return .darkContent
        } else if !UserDefaults.standard.bool(forKey: "useSystemMode") && UserDefaults.standard.bool(forKey: "darkModeEnabled") {
            return .lightContent
        } else if UserDefaults.standard.bool(forKey: "useSystemMode") && traitCollection.userInterfaceStyle == .light {
            return .darkContent
        } else {
            return .lightContent
        }
    }
}
