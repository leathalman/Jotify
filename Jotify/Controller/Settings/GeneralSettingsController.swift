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
        super.section1 = ["Account", "Appearance"]
        navigationItem.title = "Settings"
//        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "disableSwipe"), object: nil)
    }
    
    //tableView logic
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch indexPath.row {
        case 0:
            if UIDevice.current.userInterfaceIdiom == .pad {
                let vc = AccountSettingsController(style: .insetGrouped)
                vc.modalPresentationStyle = .formSheet
                present(vc, animated: true, completion: nil)
            } else if UIDevice.current.userInterfaceIdiom == .phone {
                navigationController?.pushViewController(AccountSettingsController(style: .insetGrouped), animated: true)
            }
        case 1:
            if UIDevice.current.userInterfaceIdiom == .pad {
                let vc = AppearanceSettingsController(style: .insetGrouped)
                vc.modalPresentationStyle = .formSheet
                present(vc, animated: true, completion: nil)
            } else if UIDevice.current.userInterfaceIdiom == .phone {
                navigationController?.pushViewController(AppearanceSettingsController(style: .insetGrouped), animated: true)
            }
        default:
            print("")
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsCell", for: indexPath) as! SettingsCell
        cell.textLabel?.text = "\(super.section1[indexPath.row])"
        cell.accessoryType = .disclosureIndicator
        cell.accessoryView = UIImageView(image: UIImage(systemName: "chevron.right.circle.fill"))
        return cell
    }
}
