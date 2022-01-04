//
//  CustomizationSettingsController.swift
//  Jotify
//
//  Created by Harrison Leath on 1/3/22.
//

import UIKit
import LocalAuthentication

class CustomizationSettingsController: SettingsController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        super.sections = ["Privacy", "Visual", "Miscellaneous"]
        super.section1 = ["Use Biometric Unlock"]
        super.section2 = ["Custom Placeholder", "App Icon"]
        super.section3 = ["View on Launch", "Use Haptics", "Delete Expired Notes"]
        navigationItem.title = "Customization"
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let switchCell = tableView.dequeueReusableCell(withIdentifier: "SettingsSwitchCell", for: indexPath) as! SettingsSwitchCell
            switchCell.textLabel?.text = "\(super.section1[indexPath.row])"
            switchCell.selectionStyle = .none
            switch indexPath.row {
            case 0:
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
        case 1:
            let genericCell = tableView.dequeueReusableCell(withIdentifier: "SettingsCell", for: indexPath) as! SettingsCell
            genericCell.textLabel?.text = "\(super.section2[indexPath.row])"
            genericCell.accessoryType = .disclosureIndicator
            genericCell.accessoryView = UIImageView(image: UIImage(systemName: "chevron.right.circle.fill"))
            return genericCell
        case 2:
            switch indexPath.row {
            case 0:
                let genericCell = tableView.dequeueReusableCell(withIdentifier: "SettingsCell", for: indexPath) as! SettingsCell
                genericCell.textLabel?.text = "\(super.section3[indexPath.row])"
                genericCell.accessoryType = .disclosureIndicator
                genericCell.accessoryView = UIImageView(image: UIImage(systemName: "chevron.right.circle.fill"))
                return genericCell
            case 1:
                let switchCell = tableView.dequeueReusableCell(withIdentifier: "SettingsSwitchCell", for: indexPath) as! SettingsSwitchCell
                switchCell.textLabel?.text = "\(super.section3[indexPath.row])"
                switchCell.selectionStyle = .none
                switchCell.switchButton.addTarget(self, action: #selector(useHapticsSwitchPressed(sender:)), for: .valueChanged)
                if UserDefaults.standard.bool(forKey: "useHaptics") {
                    switchCell.switchButton.isOn = true
                } else {
                    switchCell.switchButton.isOn = false
                }
                return switchCell
            case 2:
                let switchCell = tableView.dequeueReusableCell(withIdentifier: "SettingsSwitchCell", for: indexPath) as! SettingsSwitchCell
                switchCell.textLabel?.text = "\(super.section3[indexPath.row])"
                switchCell.selectionStyle = .none
                switchCell.switchButton.addTarget(self, action: #selector(deleteOldNotesPressed(sender:)), for: .valueChanged)
                if UserDefaults.standard.bool(forKey: "deleteOldNotes") {
                    switchCell.switchButton.isOn = true
                } else {
                    switchCell.switchButton.isOn = false
                }
                return switchCell
            default:
                let genericCell = tableView.dequeueReusableCell(withIdentifier: "SettingsCell", for: indexPath) as! SettingsCell
                return genericCell
            }
        default:
            let genericCell = tableView.dequeueReusableCell(withIdentifier: "SettingsCell", for: indexPath) as! SettingsCell
            return genericCell
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Use Touch ID or Face ID to authenticate Jotify and keep your notes private."
        case 2:
            return "If enabled, Jotify will automatically delete notes which are older than 30 days. Changing this setting will take effect on next restart."
        default:
            return ""
        }
    }
    
    //can change for PIN to work and not just biometric
    //change "deviceOwnerAuthenticationWithBiometrics" to "deviceOwnerAuthentication"
    @objc func useBiometricsSwitchPressed(sender: UISwitch) {
        if sender.isOn {
            //enable biometrics
            let context = LAContext()
            var error: NSError?
            
            if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
                //Permission granted for biometrics
                UserDefaults.standard.set(true, forKey: "useBiometrics")
                DataManager.updateUserSettings(setting: "useBiometrics", value: true) { (success) in }
                print("useBiometrics enabled")
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
    
    @objc func useHapticsSwitchPressed(sender: UISwitch) {
        if sender.isOn {
            print("useHaptics enabled")
            UserDefaults.standard.set(true, forKey: "useHaptics")
            DataManager.updateUserSettings(setting: "useHaptics", value: true) { (success) in }
            AnalyticsManager.logEvent(named: "useHaptics_enabled", description: "useHaptics_enabled")
        } else {
            print("useHaptics disabled")
            UserDefaults.standard.set(false, forKey: "useHaptics")
            DataManager.updateUserSettings(setting: "useHaptics", value: false) { (success) in }
            AnalyticsManager.logEvent(named: "useHaptics_disabled", description: "useHaptics_disabled")
        }
    }
    
    @objc func deleteOldNotesPressed(sender: UISwitch) {
        if sender.isOn {
            print("deleteOldNotes enabled")
            UserDefaults.standard.set(true, forKey: "deleteOldNotes")
            DataManager.updateUserSettings(setting: "deleteOldNotes", value: true) { (success) in }
            AnalyticsManager.logEvent(named: "deleteOldNotes_enabled", description: "deleteOldNotes_enabled")

        } else {
            print("deleteOldNotes disabled")
            UserDefaults.standard.set(false, forKey: "deleteOldNotes")
            DataManager.updateUserSettings(setting: "deleteOldNotes", value: false) { (success) in }
            AnalyticsManager.logEvent(named: "deleteOldNotes_disabled", description: "deleteOldNotes_disabled")
        }
    }
}
