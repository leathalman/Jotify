//
//  GeneralSettingsController.swift
//  Jotify
//
//  Created by Harrison Leath on 2/1/21.
//

import UIKit

class GeneralSettingsController: SettingsController {
    
    let general: Array = ["About", "Appearance", "Privacy", "Alerts"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        super.sections = ["General", "Advanced"]
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return general.count
        } else if section == 1 {
            return general.count
        } else {
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            switch indexPath.row {
            case 0:
                let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsCell", for: indexPath) as! SettingsCell
                cell.textLabel?.text = "\(general[indexPath.row])"
                cell.backgroundColor = UIColor.white
                cell.backgroundColor = .blue
                cell.accessoryType = .disclosureIndicator
                
//                setupDynamicCells(cell: cell, enableArrow: true)
                
                return cell
                
            case 1, 2, 3:
                let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsCell", for: indexPath) as! SettingsCell
                cell.textLabel?.text = "\(general[indexPath.row])"
                cell.accessoryType = .disclosureIndicator
                
//                setupDynamicCells(cell: cell, enableArrow: true)
                
                return cell
                
            default:
                let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsCell", for: indexPath) as! SettingsCell
                cell.textLabel?.text = "\(general[indexPath.row])"
                cell.accessoryType = .disclosureIndicator
                
//                setupDynamicCells(cell: cell, enableArrow: true)
                
                return cell
            }
            
        } else {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsCell", for: indexPath) as! SettingsCell
            return cell
        }
    }
    
    
//    func setupDynamicCells(cell: UITableViewCell, enableArrow: Bool) {
//        cell.backgroundColor = UIColor.white
//        cell.backgroundColor = .blue
//        
//        cell.textLabel?.textColor = UIColor.black
//        cell.textLabel?.textColor = .blue
//        
//        setupHighlightCorrection(cell: cell)
//        
//        if enableArrow {
//            if darkModeEnabled() {
//                cell.accessoryView = UIImageView(image: UIImage(systemName: "chevron.right.circle"))
//                
//            } else {
//                cell.accessoryView = UIImageView(image: UIImage(systemName: "chevron.right.circle.fill"))
//            }
//        }
//    }
    
//    func setupHighlightCorrection(cell: UITableViewCell) {
//        if !defaults.bool(forKey: "useSystemMode") && !defaults.bool(forKey: "darkModeEnabled") {
//            let backgroundView = UIView()
//            backgroundView.backgroundColor = UIColor.cellHighlightDefault
//            cell.selectedBackgroundView = backgroundView
//
//        } else if !defaults.bool(forKey: "useSystemMode") && defaults.bool(forKey: "darkModeEnabled") {
//            let backgroundView = UIView()
//            backgroundView.backgroundColor = UIColor.cellHighlightDark
//            cell.selectedBackgroundView = backgroundView
//
//        } else {
//            cell.selectedBackgroundView = nil
//        }
//    }
    
//    func notifyUserOfRestore() {
//        // setups observer for IAPHandler
//        NotificationCenter.default.addObserver(self, selector: #selector(self.handleIAPNotification(notification:)), name: .IAPHelperPurchaseNotification, object: nil)
//    }
    
//    @objc func handleIAPNotification(notification: Notification) {
//        // will not account for receipt validator
//        if notification.object as! String == "com.austinleath.Jotify.Premium" || notification.object as! String == "com.austinleath.Jotify.premium" {
//            // if purchased
//            let alert = UIAlertController(title: "Congratulations!", message: "You successfully restored your purchase! Enjoy Jotify premium!", preferredStyle: .alert)
//
//            alert.addAction(UIAlertAction(title: "Yay!", style: .cancel, handler: { _ in
//
//            }))
//            present(alert, animated: true)
//            self.tableView.reloadData()
//
//        } else {
//            // if not purchased
//            // TODO: make sure this correctly triggers
//            let alert = UIAlertController(title: "Not quite.", message: "It looks like you have not bought premium yet. Please consider supporting Jotify!", preferredStyle: .alert)
//
//            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { _ in
//
//            }))
//            present(alert, animated: true)
//        }
//    }
    
//    func darkModeEnabled() -> Bool {
//        return defaults.bool(forKey: "darkModeEnabled")
//    }
}
