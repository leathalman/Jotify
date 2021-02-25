//
//  UserSettingsController.swift
//  Jotify
//
//  Created by Harrison Leath on 2/1/21.
//

import UIKit

class AccountSettingsController: SettingsController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        super.sections = [AuthManager().email]
        super.section1 = ["Reset Password", "Logout"]
        navigationItem.title = "Account"
    }
    
    //tableView logic
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch indexPath.section {
        case 0:
            switch indexPath.row {
            case 0:
                let alertController = UIAlertController(title: nil, message: "Are you sure you want to reset your password?", preferredStyle: .alert)
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
                let alertController = UIAlertController(title: nil, message: "Are you sure you want to log out?", preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "Yes", style: .destructive, handler: {(action) in
                    //sign out user and set the rootViewController back to loginController
                    AuthManager.signOut()
                    let alertController = UIAlertController(title: nil, message: "User successfully logged out.", preferredStyle: .alert)
                    alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
                        self.setRootViewController(vc: LoginController())
                    }))
                    self.present(alertController, animated: true, completion: nil)
                }))
                alertController.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
                self.present(alertController, animated: true, completion: nil)
            default:
                print("")
            }
        default:
            print("")
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsCell", for: indexPath) as! SettingsCell
        cell.textLabel?.text = "\(super.section1[indexPath.row])"

        if indexPath.row == 1 {
            cell.textLabel?.textColor = .systemRed
        }
        
        return cell
    }
}
