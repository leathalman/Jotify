//
//  GeneralSettingsController.swift
//  Jotify
//
//  Created by Harrison Leath on 7/8/21.
//

import UIKit

class GeneralSettingsController: SettingsController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        super.sections = ["About", "Miscellaneous"]
        super.section1 = ["Version: \(Bundle.main.infoDictionary?["CFBundleShortVersionString"] as! String)", "Build: \(Bundle.main.infoDictionary?["CFBundleVersion"] as! String)", "Number of Notes: \(noteCollection?.FBNotes.count ?? 0)", "Need Support?"]
        super.section2 = ["Use Haptics", "Automatically Delete Old Notes"]
        navigationItem.title = "General"
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            if indexPath.row == 3 {
                let alertController = UIAlertController(title: "Support", message: "If you have any frustrations or concerns, email me here.", preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
                alertController.addAction(UIAlertAction(title: "Email", style: .default, handler: { (action) in
                    let email = "jotifysupport@leathalenterprises.com"
                    let url = URL(string: "mailto:\(email)")!
                    UIApplication.shared.open(url)
                }))
                self.present(alertController, animated: true, completion: nil)
            }
        default:
            print("default")
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let genericCell = tableView.dequeueReusableCell(withIdentifier: "SettingsCell", for: indexPath) as! SettingsCell
            genericCell.textLabel?.text = "\(super.section1[indexPath.row])"
            genericCell.selectionStyle = .none
            return genericCell
        case 1:
            let switchCell = tableView.dequeueReusableCell(withIdentifier: "SettingsSwitchCell", for: indexPath) as! SettingsSwitchCell
            switchCell.textLabel?.text = "\(super.section2[indexPath.row])"
            switchCell.selectionStyle = .none
            
            switch indexPath.row {
            case 0:
                switchCell.switchButton.addTarget(self, action: #selector(useHapticsSwitchPressed(sender:)), for: .valueChanged)
                if UserDefaults.standard.bool(forKey: "useHaptics") {
                    switchCell.switchButton.isOn = true
                } else {
                    switchCell.switchButton.isOn = false
                }
                return switchCell
            case 1:
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
    
    @objc func useHapticsSwitchPressed(sender: UISwitch) {
        if sender.isOn {
            print("useHaptics enabled")
            UserDefaults.standard.set(true, forKey: "useHaptics")
            
        } else {
            print("useHaptics disabled")
            UserDefaults.standard.set(false, forKey: "useHaptics")
        }
    }
    
    @objc func deleteOldNotesPressed(sender: UISwitch) {
        if sender.isOn {
            print("deleteOldNotes enabled")
            UserDefaults.standard.set(true, forKey: "deleteOldNotes")
            
        } else {
            print("deleteOldNotes disabled")
            UserDefaults.standard.set(false, forKey: "deleteOldNotes")
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        switch section {
        case 1:
            return "If enabled, Jotify will automatically delete notes which are older than 30 days. Changing this setting will take effect on next restart."
        default:
            return ""
        }
    }
    
}

