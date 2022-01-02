//
//  PrivacySettingsController.swift
//  Jotify
//
//  Created by Harrison Leath on 12/31/21.
//

import UIKit
import LocalAuthentication
import SwiftUI

class PrivacySettingsController: SettingsController {
    
    var window: UIWindow = UIWindow()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        super.sections = ["General"]
        super.section1 = ["Use Biometric Unlock"]
        navigationItem.title = "Privacy"
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let switchCell = tableView.dequeueReusableCell(withIdentifier: "SettingsSwitchCell", for: indexPath) as! SettingsSwitchCell
        
        switch indexPath.row {
        case 0:
            switchCell.textLabel?.text = "\(super.section1[indexPath.row])"
            switchCell.selectionStyle = .none
            
            switchCell.switchButton.addTarget(self, action: #selector(useBiometricsSwitchPressed(sender:)), for: .valueChanged)
            if UserDefaults.standard.bool(forKey: "useBiometrics") {
                switchCell.switchButton.isOn = true
            } else {
                switchCell.switchButton.isOn = false
            }
            return switchCell
        default:
            let genericCell = tableView.dequeueReusableCell(withIdentifier: "SettingsCell", for: indexPath) as! SettingsCell
            return genericCell
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
    
    @objc func useBiometricsSwitchPressed(sender: UISwitch) {
        if sender.isOn {
            //enable biometrics
            let context = LAContext()
            var error: NSError?
            
            if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
                //Permission granted for biometrics
                UserDefaults.standard.set(true, forKey: "useBiometrics")
                DataManager.updateUserSettings(setting: "useBiometrics", value: true) { (success) in }
                AnalyticsManager.logEvent(named: "useBiometrics_enabled", description: "useBiometrics_enabled")
            } else {
                //No biometrics avaliable
                print("Biometrics may not be enabled")
                DataManager.updateUserSettings(setting: "useBiometrics", value: false) { (success) in }
                AnalyticsManager.logEvent(named: "useBiometrics_disabled", description: "useBiometrics_disabled")
                
                let alertController = UIAlertController(title: "Error Enabling Biometrics", message: "Face ID or Touch ID are not available. Please enable biometrics in Settings for Jotify.", preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
                    sender.setOn(false, animated: true)
                }))
                self.present(alertController, animated: true, completion: nil)
            }
        } else {
            print("useBiometrics disabled")
            UserDefaults.standard.set(false, forKey: "useBiometrics")
            DataManager.updateUserSettings(setting: "useBiometrics", value: false) { (success) in }
            AnalyticsManager.logEvent(named: "useBiometrics_disabled", description: "useBiometrics_disabled")
        }
    }
}
