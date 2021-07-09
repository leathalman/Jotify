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
        super.sections = ["About", "Miscellaneous", "Beta"]
        super.section1 = ["Version: \(Bundle.main.infoDictionary?["CFBundleShortVersionString"] as! String)", "Build: \(Bundle.main.infoDictionary?["CFBundleVersion"] as! String)", "Number of Notes: \(noteCollection?.FBNotes.count ?? 0)", "Jotify Support"]
        super.section2 = ["Use Haptics", "Automatically Delete Old Notes"]
        super.section3 = ["Reset Note Colors"]
        navigationItem.title = "General"
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            if indexPath.row == 3 {
                let alertController = UIAlertController(title: "Support", message: "If you have any frustrations or concerns, email me here.", preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "Email", style: .default, handler: { (action) in
                    let email = "jotifysupport@leathalenterprises.com"
                    let url = URL(string: "mailto:\(email)")!
                    UIApplication.shared.open(url)
                }))
                alertController.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
                self.present(alertController, animated: true, completion: nil)
            }
        case 2:
            for note in self.noteCollection!.FBNotes {
                DataManager.updateNoteColor(color: ColorManager.noteColor.getString(), uid: note.id) { success in }
                ColorManager.setNoteColor()
            }
            
            let alertController = UIAlertController(title: "Sucesss!", message: "The color of your notes has been reset.", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alertController, animated: true, completion: nil)
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
            if indexPath.row == 3 {
                genericCell.textLabel?.textColor = .systemBlue
            }
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
        case 2:
            let genericCell = tableView.dequeueReusableCell(withIdentifier: "SettingsCell", for: indexPath) as! SettingsCell
            genericCell.textLabel?.text = "\(super.section3[indexPath.row])"
            genericCell.selectionStyle = .none
            if indexPath.row == 0 {
                genericCell.textLabel?.textColor = .systemBlue
            }
            return genericCell
        default:
            let genericCell = tableView.dequeueReusableCell(withIdentifier: "SettingsCell", for: indexPath) as! SettingsCell
            return genericCell
        }
    }
    
    @objc func useHapticsSwitchPressed(sender: UISwitch) {
        if sender.isOn {
            print("useHaptics enabled")
            UserDefaults.standard.set(true, forKey: "useHaptics")
            DataManager.updateUserSettings(setting: "useHaptics", value: true) { (success) in }
        } else {
            print("useHaptics disabled")
            UserDefaults.standard.set(false, forKey: "useHaptics")
            DataManager.updateUserSettings(setting: "useHaptics", value: false) { (success) in }
        }
    }
    
    @objc func deleteOldNotesPressed(sender: UISwitch) {
        if sender.isOn {
            print("deleteOldNotes enabled")
            UserDefaults.standard.set(true, forKey: "deleteOldNotes")
            DataManager.updateUserSettings(setting: "deleteOldNotes", value: true) { (success) in }
        } else {
            print("deleteOldNotes disabled")
            UserDefaults.standard.set(false, forKey: "deleteOldNotes")
            DataManager.updateUserSettings(setting: "deleteOldNotes", value: false) { (success) in }
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

