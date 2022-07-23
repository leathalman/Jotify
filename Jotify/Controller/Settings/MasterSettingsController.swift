//
//  GeneralSettingsController.swift
//  Jotify
//
//  Created by Harrison Leath on 2/1/21.
//

import UIKit

class MasterSettingsController: SettingsController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        super.sections = ["General"]
        super.section1 = ["General", "Customization", "Account", "Referrals"]
        navigationItem.title = "Settings"
        
        NotificationCenter.default.addObserver(self, selector: #selector(pureDarkModeChanged(notification:)), name:NSNotification.Name(rawValue: "updatePureDarkMode"), object: nil)
    }
    
    //tableView logic
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        switch indexPath.row {
        case 0:
            let vc = GeneralSettingsController(style: .insetGrouped)
            vc.noteCollection = self.noteCollection
            if UIDevice.current.userInterfaceIdiom == .pad {
                vc.modalPresentationStyle = .formSheet
                present(vc, animated: true, completion: nil)
            } else if UIDevice.current.userInterfaceIdiom == .phone {
                navigationController?.pushViewController(vc, animated: true)
            }
        case 1:
            let vc = CustomizationSettingsController(style: .insetGrouped)
            if UIDevice.current.userInterfaceIdiom == .pad {
                vc.modalPresentationStyle = .formSheet
                present(vc, animated: true, completion: nil)
            } else if UIDevice.current.userInterfaceIdiom == .phone {
                navigationController?.pushViewController(vc, animated: true)
            }
        case 2:
            let vc = AccountSettingsController(style: .insetGrouped)
            vc.noteCollection = self.noteCollection
            if UIDevice.current.userInterfaceIdiom == .pad {
                vc.modalPresentationStyle = .formSheet
                present(vc, animated: true, completion: nil)
            } else if UIDevice.current.userInterfaceIdiom == .phone {
                navigationController?.pushViewController(vc, animated: true)
            }
        case 3:
            let vc = ReferralSettingsController()
            if UIDevice.current.userInterfaceIdiom == .pad {
                vc.modalPresentationStyle = .formSheet
                present(vc, animated: true, completion: nil)
            } else if UIDevice.current.userInterfaceIdiom == .phone {
                navigationController?.pushViewController(vc, animated: true)
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
    
    @objc func pureDarkModeChanged(notification: Notification) {
        print("Pure dark mode changed.")
        view.backgroundColor = ColorManager.bgColor
    }
}
