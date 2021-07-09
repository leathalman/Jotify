//
//  UserSettingsController.swift
//  Jotify
//
//  Created by Harrison Leath on 2/1/21.
//

import UIKit
import SwiftUI

class AccountSettingsController: SettingsController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        super.sections = [AuthManager().email, "Data"]
        super.section1 = ["Reset Password", "Change Email", "Logout"]
        super.section2 = ["Delete All Notes", "Delete Jotify Account"]
        navigationItem.title = "Account"
    }
    
    //tableView logic
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch indexPath.section {
        case 0:
            switch indexPath.row {
            case 0:
                let alertController = UIAlertController(title: "Reset Password", message: "Are you sure you want to reset your password?", preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "Yes", style: .destructive, handler: {(action) in
                    //ask firebase to send password recovery email and alert user if successful or error
                    //deselect row once action is completed
                    AuthManager.forgotPassword(email: AuthManager().email) { (success, message) in
                        if success! {
                            print("recovery email sent")
                            let alertController = UIAlertController(title: nil, message: "Password recovery email successfully sent to \(AuthManager().email)", preferredStyle: .alert)
                            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                            self.present(alertController, animated: true, completion: nil)
                        } else {
                            print("recovery email was unable to be sent")
                            let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
                            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                            self.present(alertController, animated: true, completion: nil)
                        }
                    }
                }))
                alertController.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
                self.present(alertController, animated: true, completion: nil)
            case 1:
                let alertController = UIAlertController(title: "Change Email", message: "Enter your new email address below.", preferredStyle: .alert)
                alertController.addTextField { textField in
                    let placeholder = "Enter an email address."
                    textField.placeholder = placeholder
                    textField.autocorrectionType = .no
                    textField.autocapitalizationType = .sentences
                }
                alertController.addAction(UIAlertAction(title: "Submit", style: .default, handler: { [weak alertController] _ in
                    let textField = alertController?.textFields![0]
                    let email = textField?.text
                    
                    if email?.isEmpty ?? false {
                    } else {
                        AuthManager.changeEmail(email: email ?? "email not entered correctly") { success, message in
                            let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
                            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                            self.present(alertController, animated: true, completion: nil)
                        }
                    }
                }))
                alertController.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
                self.present(alertController, animated: true, completion: nil)
            case 2:
                let alertController = UIAlertController(title: "Logout", message: "Are you sure you want to logout?", preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "Logout", style: .destructive, handler: {(action) in
                    //sign out user and set the rootViewController back to loginController
                    AuthManager.signOut()
                    let alertController = UIAlertController(title: nil, message: "User successfully logged out.", preferredStyle: .alert)
                    alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
                        self.setRootViewController(duration: 0.4, vc: UIHostingController(rootView: LogInView()))
                    }))
                    self.present(alertController, animated: true, completion: nil)
                }))
                alertController.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
                self.present(alertController, animated: true, completion: nil)
            default:
                print("")
            }
        case 1:
            switch indexPath.row {
            case 0:
                let alertController = UIAlertController(title: "Delete All Notes", message: "Do you really want to delete ALL of your notes? This action CANNOT be undone.", preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "Yes", style: .destructive, handler: {(action) in
                    let alertController = UIAlertController(title: nil, message: "Are you sure? This is the final check.", preferredStyle: .alert)
                    alertController.addAction(UIAlertAction(title: "Delete My Notes", style: .destructive, handler: { (action) in
                        self.deleteAllNotes { success in
                            if success! {
                                let alertController = UIAlertController(title: "Success", message: "All notes successfully deleted.", preferredStyle: .alert)
                                alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                                self.present(alertController, animated: true, completion: nil)
                            } else {
                                let alertController = UIAlertController(title: "Error", message: "There was an error deleting your notes. Please try again later.", preferredStyle: .alert)
                                alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                                self.present(alertController, animated: true, completion: nil)
                            }
                        }
                    }))
                    alertController.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
                    self.present(alertController, animated: true, completion: nil)
                }))
                alertController.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
                self.present(alertController, animated: true, completion: nil)
            case 1:
                let alertController = UIAlertController(title: "Delete Jotify Account", message: "Do you really want to delete your Jotify account? This action cannot be undone under any circumstance.", preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "Yes", style: .destructive, handler: {(action) in
                    let alertController = UIAlertController(title: nil, message: "This action will remove your account, all notes, and settings current saved in Jotify's servers. This is the FINAL check.", preferredStyle: .alert)
                    alertController.addAction(UIAlertAction(title: "Delete My Account", style: .destructive, handler: { (action) in
                        AuthManager.deleteUser { success, message in
                            if success! {
                                self.deleteAllNotes { success in
                                    print("All notes deleted: \(String(describing: success))")
                                }
                                
                                DataManager.deleteUserSettings { success in
                                    print("Settings deleted: \(String(describing: success))")
                                }
                                
                                let alertController = UIAlertController(title: "Success", message: "User account and relevant data deleted.", preferredStyle: .alert)
                                alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
                                    self.setRootViewController(duration: 0.4, vc: UIHostingController(rootView: LogInView()))
                                }))
                                self.present(alertController, animated: true, completion: nil)
                            } else {
                                let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
                                alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                                self.present(alertController, animated: true, completion: nil)
                            }
                        }
                    }))
                    alertController.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
                    self.present(alertController, animated: true, completion: nil)
                }))
                alertController.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
                self.present(alertController, animated: true, completion: nil)
            default:
                break
            }
            
        default:
            print("")
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsCell", for: indexPath) as! SettingsCell
        
        switch indexPath.section {
        case 0:
            cell.textLabel?.text = "\(super.section1[indexPath.row])"
            cell.textLabel?.textColor = .systemBlue
            if indexPath.row == 2 {
                cell.textLabel?.textColor = .systemRed
            }
        case 1:
            cell.textLabel?.text = "\(super.section2[indexPath.row])"
            cell.textLabel?.textColor = .systemRed
        default:
            return cell
        }
        return cell
    }
    
    func deleteAllNotes(completionHandler: @escaping (Bool?) -> Void) {
        if self.noteCollection?.FBNotes.count ?? 0 < 1 {
            completionHandler(false)
            return
        }
        
        for note in self.noteCollection!.FBNotes {
            DataManager.deleteNote(docID: note.id) { success in
                if !success! {
                    print("Failed to delete note: \(note.id)")
                    completionHandler(false)
                }
            }
            completionHandler(true)
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Changing account credentials maybe require you to logout and sign back into Jotify for security purposes."
        case 1:
            return "Delete all data from Jotify's servers. Your notes are permanently deleted, so they cannot be recovered under any circumstance."
        default:
            return ""
        }
    }
    
}
