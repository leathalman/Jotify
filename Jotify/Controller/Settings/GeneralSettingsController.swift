//
//  GeneralSettingsController.swift
//  Jotify
//
//  Created by Harrison Leath on 2/1/21.
//

import UIKit

class GeneralSettingsController: SettingsController {
        
    override func viewDidLoad() {
        super.viewDidLoad()
        super.sections = ["General"]
        super.section1Content = ["Account", "Appearance"]
        navigationItem.title = "Settings"
    }
    
    //tableView logic
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            navigationController?.pushViewController(AccountSettingsController(style: .insetGrouped), animated: true)
        case 1:
            navigationController?.pushViewController(AppearanceSettingsController(style: .insetGrouped), animated: true)
        default:
            print("default")
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsCell", for: indexPath) as! SettingsCell
        cell.textLabel?.text = "\(super.section1Content[indexPath.row])"
        cell.accessoryType = .disclosureIndicator
        cell.accessoryView = UIImageView(image: UIImage(systemName: "chevron.right.circle.fill"))
        return cell
    }
}
