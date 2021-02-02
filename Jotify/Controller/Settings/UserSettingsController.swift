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
        super.section1Content = ["Logout"]
        navigationItem.title = "User Settings"
    }
    
    //tableView logic
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            //sign out user and set the rootViewController back to loginController
            AuthManager.signOut()
            let alertController = UIAlertController(title: nil, message: "User successfully logged out.", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
                print("do something here")
                self.setRootViewController(vc: LoginController())
            }))
            self.present(alertController, animated: true, completion: nil)
        default:
            print("inwdoa")
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsCell", for: indexPath) as! SettingsCell
        cell.textLabel?.text = "\(super.section1Content[indexPath.row])"
        cell.textLabel?.textColor = .systemRed
        return cell
    }
}
