//
//  UserSettingsController.swift
//  Jotify
//
//  Created by Harrison Leath on 2/1/21.
//

import UIKit

class UserSettingsController: SettingsController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        super.sections = ["Account"]
        super.section1Content = ["Reset Password", "Logout"]
        navigationItem.title = "User Settings"
    }
    
    //tableView logic
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
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
                tableView.deselectRow(at: indexPath, animated: true)
            }
        case 1:
            //sign out user and set the rootViewController back to loginController
            AuthManager.signOut()
            let alertController = UIAlertController(title: nil, message: "User successfully logged out.", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
                print("do something here")
                self.setRootViewController(vc: LoginController())
            }))
            self.present(alertController, animated: true, completion: nil)
            tableView.deselectRow(at: indexPath, animated: true)
        default:
            print("default")
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsCell", for: indexPath) as! SettingsCell
        cell.textLabel?.text = "\(super.section1Content[indexPath.row])"
        
        switch indexPath.row {
        case 1:
            cell.textLabel?.textColor = .systemRed
            return cell
        default:
            return cell
        }
    }
}
