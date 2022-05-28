//
//  GeneralSettingsController.swift
//  Jotify
//
//  Created by Harrison Leath on 7/8/21.
//

import UIKit
import MessageUI

class GeneralSettingsController: SettingsController, MFMailComposeViewControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        super.sections = ["About", "Actions"]
        super.section1 = ["Version: \(Bundle.main.infoDictionary?["CFBundleShortVersionString"] as! String)", "Build: \(Bundle.main.infoDictionary?["CFBundleVersion"] as! String)", "Total Notes: \(noteCollection?.FBNotes.count ?? 0)"]
        super.section2 = ["Jotify Support", "Restore Purchases"]
        navigationItem.title = "General"
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 1:
            if indexPath.row == 0 {
                let alertController = UIAlertController(title: "Support", message: "If you have any frustrations or feedback, email us here.", preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
                alertController.addAction(UIAlertAction(title: "Email", style: .default, handler: { (action) in
                    self.openSupportEmail()
                }))
                tableView.deselectRow(at: indexPath, animated: true)
                self.present(alertController, animated: true, completion: nil)
            } else if indexPath.row == 1 {
                tableView.deselectRow(at: indexPath, animated: true)
                IAPManager.shared.restorePurchases { (result) in
                    //                    DispatchQueue.main.async {
                    switch result {
                    case .success(let success):
                        if success {
                            //unlock premium
                            DataManager.updateUserSettings(setting: "hasPremium", value: true) { success in
                                if !success! {
                                    print("Error granting premium from restore")
                                }
                                print("Premium unlocked")
                                //force this value and on the next restart, Jotify will
                                //get the new value from updateSettings()
                                User.settings?.hasPremium = true
                                
                                let alertController = UIAlertController(title: "Success!", message: "Jotify successfully restored your purchase! Thank you so much for your support :)", preferredStyle: .alert)
                                alertController.addAction(UIAlertAction(title: "Yay!", style: .default, handler: nil))
                                self.present(alertController, animated: true)
                            }
                        } else {
                            //no products were found
                            print("Nothing to restore...")
                            tableView.deselectRow(at: indexPath, animated: true)
                            let alertController = UIAlertController(title: "Failure?", message: "Jotify didn't find any purchases to restore. If you believe this is an error, contact us using the \"Email\" button below!", preferredStyle: .alert)
                            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                            alertController.addAction(UIAlertAction(title: "Email", style: .default, handler: { (action) in
                                self.openSupportEmail()
                            }))
                            self.present(alertController, animated: true)
                        }
                        
                    case .failure(let error):
                        //there was an error
                        print("\(error) restoring IAP")
                        let alertController = UIAlertController(title: "Failure?", message: "\(error) If you continue to experience this issue, contact us below.", preferredStyle: .alert)
                        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                        alertController.addAction(UIAlertAction(title: "Email", style: .default, handler: { (action) in
                            self.openSupportEmail()
                        }))
                        tableView.deselectRow(at: indexPath, animated: true)
                        self.present(alertController, animated: true, completion: nil)
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
            return genericCell
        case 1:
            let genericCell = tableView.dequeueReusableCell(withIdentifier: "SettingsCell", for: indexPath) as! SettingsCell
            genericCell.textLabel?.text = "\(super.section2[indexPath.row])"
            genericCell.textLabel?.textColor = .systemBlue
            return genericCell
        default:
            let genericCell = tableView.dequeueReusableCell(withIdentifier: "SettingsCell", for: indexPath) as! SettingsCell
            return genericCell
        }
    }
    
    func openSupportEmail() {
        let composeVC = MFMailComposeViewController()
        composeVC.mailComposeDelegate = self
        composeVC.setToRecipients(["hello@leathalenterprises.com"])
        composeVC.setSubject("Jotify Support")
        composeVC.setMessageBody("The following information is required for the best support experience. Please do not delete this. User ID: \(AuthManager().uid) \n", isHTML: false)
        self.present(composeVC, animated: true, completion: nil)
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        // Check the result or perform other tasks.
        controller.dismiss(animated: true, completion: nil)
    }
}

