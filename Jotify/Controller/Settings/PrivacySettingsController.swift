//
//  PrivacySettingsController.swift
//  Jotify
//
//  Created by Harrison Leath on 8/4/19.
//  Copyright © 2019 Harrison Leath. All rights reserved.
//

import UIKit
import LocalAuthentication

class PrivacySettingsController: UITableViewController {
    
    let sections: Array = ["Delete", "Biometrics"]
    let delete: Array = ["Show Alert on Delete"]
    let biometrics: Array = ["Use Touch ID or Face ID"]
    
    let settingsController = SettingsController()
    
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Privacy"
        
        setupDynamicElements()
        
        tableView.register(SettingsSwitchCell.self, forCellReuseIdentifier: "SettingsSwitchCell")
    }
    
    func setupDynamicElements() {
        if settingsController.darkModeEnabled() == false {
            view.backgroundColor = InterfaceColors.viewBackgroundColor
            
            tableView.separatorColor = nil
            
        } else if settingsController.darkModeEnabled() == true {
            view.backgroundColor = InterfaceColors.viewBackgroundColor
            
            tableView.separatorColor = InterfaceColors.separatorColor
        }
    }
    
    func authenticateUserWithBioMetrics(window: UIWindow) {
        
        let blurEffect = UIBlurEffect(style: .dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = window.frame
        blurEffectView.tag = 9065
        blurEffectView.alpha = 0.875
        
        window.addSubview(blurEffectView)
        
        let context = LAContext()
        var error: NSError?
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "Unlock Jotify to access your notes."
            
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, authenticationError in
                
                DispatchQueue.main.async {
                    if success {
                        print("success")
                        
                        UIView.animate(withDuration: 0.2, animations: {
                            window.viewWithTag(9065)?.alpha = 0
                        }) { _ in
                            window.viewWithTag(9065)?.removeFromSuperview()
                        }
                        
                    } else {
                        print("error")
                    }
                }
            }
        } else {
            // no biometrics
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsSwitchCell", for: indexPath) as! SettingsSwitchCell
            cell.textLabel?.text = "\(delete[indexPath.row])"
            
            settingsController.setupDynamicCells(cell: cell, enableArrow: false)
            
            cell.selectionStyle = .none
            cell.switchButton.addTarget(self, action: #selector(showAlertOnDeleteSwitchPressed), for: .valueChanged)
            
            if defaults.bool(forKey: "showAlertOnDelete") == true {
                cell.switchButton.isOn = true
            } else {
                cell.switchButton.isOn = false
            }
            
            return cell
            
        } else if indexPath.section == 1 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsSwitchCell", for: indexPath) as! SettingsSwitchCell
            cell.textLabel?.text = "\(biometrics[indexPath.row])"
            
            settingsController.setupDynamicCells(cell: cell, enableArrow: false)
            
            cell.selectionStyle = .none
            cell.switchButton.addTarget(self, action: #selector(useBiometricsSwitchPressed(sender:)), for: .valueChanged)
            
            if defaults.bool(forKey: "useBiometrics") == true {
                cell.switchButton.isOn = true
            } else {
                cell.switchButton.isOn = false
            }
            
            return cell
            
            
        } else {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsCell", for: indexPath) as! SettingsCell
            
            cell.backgroundColor = UIColor.white
            cell.textLabel?.textColor = UIColor.black
            return cell
        }
    }
    
    @objc func showAlertOnDeleteSwitchPressed(sender: UISwitch) {
        if sender.isOn {
            print("showAlertOnDelete enabled")
            defaults.set(true, forKey: "showAlertOnDelete")
            
        } else {
            print("showAlertOnDelete disabled")
            defaults.set(false, forKey: "showAlertOnDelete")
            
        }
    }
    
    @objc func useBiometricsSwitchPressed (sender: UISwitch) {
        
        if defaults.bool(forKey: "premium") == true {
            if sender.isOn {
                print("useBiometrics enabled")
                defaults.set(true, forKey: "useBiometrics")
                
            } else {
                print("useBiometrics disabled")
                defaults.set(false, forKey: "useBiometrics")
                
            }
            
        } else {
            present(GetPremiumController(), animated: true, completion: nil)
            sender.setOn(false, animated: true)
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        switch section {
        case 0:
            return "By default Jotify displays a confirmation alert when you delete a note. To remove this confirmation, toggle the above setting."
        case 1:
            return "Use Touch ID or Face ID to authenticate Jotify and keep your notes private."
            
        default:
            return ""
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int{
        return sections.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section]
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return delete.count
        } else if section == 1 {
            return biometrics.count
        } else {
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
}

