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
        super.section1 = ["Version: \(Bundle.main.infoDictionary?["CFBundleShortVersionString"] as! String)", "Build: \(Bundle.main.infoDictionary?["CFBundleVersion"] as! String)", "Number of Notes: \(noteCollection?.FBNotes.count ?? 0)", "Jotify Support", "Restore Purchases"]
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
                tableView.deselectRow(at: indexPath, animated: true)
                self.present(alertController, animated: true, completion: nil)
            } else if indexPath.row == 4 {
                //TODO: Add UI for these interactions
                IAPManager.shared.restorePurchases { (result) in
                    DispatchQueue.main.async {
                        switch result {
                        case .success(let success):
                            if success {
                                let alertController = UIAlertController(title: "Success!", message: "Your purchase was restored. Thank you so much for supporting Jotify!", preferredStyle: .alert)
                                alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                                tableView.deselectRow(at: indexPath, animated: true)
                                self.present(alertController, animated: true, completion: nil)
                            
                                DataManager.updateUserSettings(setting: "hasPremium", value: true) { success in
                                    if !success! {
                                        print("Error updating hasPremium setting from IAPManager")
                                    }
                                }
                            }
                        case .failure(let error):
                            print("Error restoring purchase: \(error)")
                            let alertController = UIAlertController(title: "Failure?", message: "Jotify couldn't find any purchases to restore. If you believe this is an error, contact us using the button above.", preferredStyle: .alert)
                            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                            tableView.deselectRow(at: indexPath, animated: true)
                            self.present(alertController, animated: true, completion: nil)
                            print("Restore found no eligible products")
                        }
                    }
                }
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
            if indexPath.row == 3 || indexPath.row == 4 {
                genericCell.textLabel?.textColor = .systemBlue
                genericCell.selectionStyle = .default
            }
            return genericCell
        default:
            let genericCell = tableView.dequeueReusableCell(withIdentifier: "SettingsCell", for: indexPath) as! SettingsCell
            return genericCell
        }
    }
}

