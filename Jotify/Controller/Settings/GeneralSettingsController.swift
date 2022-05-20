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
        super.sections = ["About"]
        super.section1 = ["Version: \(Bundle.main.infoDictionary?["CFBundleShortVersionString"] as! String)", "Build: \(Bundle.main.infoDictionary?["CFBundleVersion"] as! String)", "Number of Notes: \(noteCollection?.FBNotes.count ?? 0)", "Jotify Support"]
        navigationItem.title = "General"
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            if indexPath.row == 3 {
                let alertController = UIAlertController(title: "Support", message: "If you have any frustrations or feedback, email me here.", preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
                alertController.addAction(UIAlertAction(title: "Email", style: .default, handler: { (action) in
                    let email = "hello@leathalenterprises.com"
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
            if indexPath.row == 3 {
                genericCell.textLabel?.textColor = .systemBlue
            }
            return genericCell
        default:
            let genericCell = tableView.dequeueReusableCell(withIdentifier: "SettingsCell", for: indexPath) as! SettingsCell
            return genericCell
        }
    }
}

