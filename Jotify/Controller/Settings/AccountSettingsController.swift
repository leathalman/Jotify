//
//  UserSettingsController.swift
//  Jotify
//
//  Created by Harrison Leath on 2/1/21.
//

import UIKit
import UserNotifications
import SwiftUI

class AccountSettingsController: SettingsController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        super.sections = [AuthManager().email, "Data"]
        super.section1 = ["Reset Password", "Change Email", "Logout"]
        super.section2 = ["Migrate Data from Old Versions", "Reset Settings", "Delete All Notes", "Delete Jotify Account"]
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
                alertController.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
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
                self.present(alertController, animated: true, completion: nil)
            case 1:
                let alertController = UIAlertController(title: "Change Email", message: "Enter your new email address below.", preferredStyle: .alert)
                alertController.addTextField { textField in
                    let placeholder = "Enter an email address."
                    textField.placeholder = placeholder
                    textField.keyboardType = .emailAddress
                    textField.textContentType = .emailAddress
                    textField.autocorrectionType = .no
                    textField.autocapitalizationType = .none
                }
                alertController.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
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
                self.present(alertController, animated: true, completion: nil)
            case 2:
                let alertController = UIAlertController(title: "Logout", message: "Are you sure you want to logout?", preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
                alertController.addAction(UIAlertAction(title: "Logout", style: .destructive, handler: {(action) in
                    //sign out user and set the rootViewController back to loginController
                    AuthManager.signOut()
                    let alertController = UIAlertController(title: nil, message: "User successfully logged out.", preferredStyle: .alert)
                    alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
                        self.setRootViewController(duration: 0.4, vc: UIHostingController(rootView: LogInView()))
                    }))
                    self.present(alertController, animated: true, completion: nil)
                }))
                self.present(alertController, animated: true, completion: nil)
            default:
                print("")
            }
        case 1:
            switch indexPath.row {
            case 0:
                let alertController = UIAlertController(title: "Migrate Notes", message: "If you have notes from a previous version of Jotify, you can import them here! Would you like to begin the transfer process? You can continue to use Jotify, and you will be prompted to restore your notes the next time you launch the app.", preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "No", style: .default, handler: nil))
                alertController.addAction(UIAlertAction(title: "Yes", style: .default, handler: {(action) in
                    DataManager.updateUserSettings(setting: "hasMigrated", value: false) { success in
                        //
                    }
                }))
                self.present(alertController, animated: true, completion: nil)
            case 1:
                let alertController = UIAlertController(title: "Reset User Settings", message: "Are you sure? This will reset settings to default.", preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
                alertController.addAction(UIAlertAction(title: "Reset", style: .destructive, handler: {(action) in
                    DataManager.deleteUserSettings { success in
                        if success! {
                            DataManager.createUserSettings { success in
                                if success! {
                                    let alertController = UIAlertController(title: "Success", message: "Settings reset successfully.", preferredStyle: .alert)
                                    alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                                    self.present(alertController, animated: true, completion: nil)
                                } else {
                                    let alertController = UIAlertController(title: "Error", message: "There was an error resetting settings. Please try again later.", preferredStyle: .alert)
                                    alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                                    self.present(alertController, animated: true, completion: nil)
                                }
                                User.updateSettings()
                            }
                        } else {
                            let alertController = UIAlertController(title: "Error", message: "There was an error resetting settings. Please try again later.", preferredStyle: .alert)
                            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                            self.present(alertController, animated: true, completion: nil)
                        }
                    }
                }))
                self.present(alertController, animated: true, completion: nil)
            case 2:
                let alertController = UIAlertController(title: "Delete All Notes", message: "Do you really want to delete ALL of your notes? This action CANNOT be undone.", preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
                alertController.addAction(UIAlertAction(title: "Yes", style: .destructive, handler: {(action) in
                    let alertController = UIAlertController(title: "Final Confirmation", message: "Are you sure? This is the last check.", preferredStyle: .alert)
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
                self.present(alertController, animated: true, completion: nil)
            case 3:
                let alertController = UIAlertController(title: "Delete Jotify Account", message: "Do you really want to delete your Jotify account? This action cannot be undone under any circumstance.", preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
                alertController.addAction(UIAlertAction(title: "Yes", style: .destructive, handler: {(action) in
                    let alertController = UIAlertController(title: nil, message: "This action will remove your account, all notes, and settings current saved in Jotify's servers. This is the FINAL check.", preferredStyle: .alert)
                    alertController.addAction(UIAlertAction(title: "Delete My Account", style: .destructive, handler: { (action) in
                        self.deleteAccountAndData()
                    }))
                    alertController.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
                    self.present(alertController, animated: true, completion: nil)
                }))
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
            let color: UIColor = indexPath.row == 2 ? .systemRed : .systemBlue
            cell.setTitle(super.section1[indexPath.row], color: color)
        case 1:
            let color: UIColor = indexPath.row == 0 ? .systemBlue : .systemRed
            cell.setTitle(super.section2[indexPath.row], color: color)
        default:
            break
        }
        return cell
    }
    
    //deletes every note on the server and calls back once, after it's done
    func deleteAllNotes(completionHandler: @escaping (Bool?) -> Void) {
        DataManager.deleteAllNotes { success in
            if success {
                //notes are gone, so are their reminders
                UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
                UIApplication.shared.applicationIconBadgeNumber = 0
            }
            completionHandler(success)
        }
    }

    /// Deletes the user's notes and settings *while still signed in*, then
    /// the Firebase Auth account. The old order deleted the account first,
    /// after which every DataManager call bailed out on the empty uid, so all
    /// notes and settings stayed on the server despite the "deleted" message.
    func deleteAccountAndData() {
        let showError: (String) -> Void = { message in
            let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }

        // Firebase only lets an account be deleted shortly after signing in.
        // Check that up front so we never wipe the data and then fail to
        // delete the account itself.
        guard AuthManager.hasRecentLogin else {
            showError("For your security, please log out and sign back in, then delete your account.")
            return
        }

        deleteAllNotes { notesDeleted in
            guard notesDeleted == true else {
                showError("There was an error deleting your notes, so your account was not deleted. Please try again later.")
                return
            }
            DataManager.deleteUserSettings { settingsDeleted in
                guard settingsDeleted == true else {
                    showError("There was an error deleting your settings, so your account was not deleted. Please try again later.")
                    return
                }
                AuthManager.deleteUser { success, message in
                    guard success == true else {
                        showError(message ?? "There was an error deleting your account.")
                        return
                    }
                    AuthManager.signOut()
                    let alert = UIAlertController(title: "Success", message: "User account and relevant data deleted.", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
                        self.setRootViewController(duration: 0.4, vc: UIHostingController(rootView: LogInView()))
                    }))
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Changing account credentials may require you to logout and sign back into Jotify for security purposes."
        case 1:
            return "Delete all data from Jotify's servers. Your notes are permanently deleted, so they cannot be recovered under any circumstance."
        default:
            return ""
        }
    }
}
