//
//  AlertSettingsController.swift
//  Jotify
//
//  Created by Harrison Leath on 7/9/19.
//  Copyright © 2019 Harrison Leath. All rights reserved.
//

import UIKit

class AlertSettingsController: UITableViewController {
    let sections: Array = ["Delete", "Sort", "Rating"]
    let delete: Array = ["Show Alert on Delete"]
    let sort: Array = ["Show Alert on Sort"]
    let rating: Array = ["Show Rating Prompt"]
    
    let settingsController = SettingsController()
    
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Alerts"
        
        setupDynamicElements()
        
        tableView.register(SettingsSwitchCell.self, forCellReuseIdentifier: "SettingsSwitchCell")
    }
    
    func setupDynamicElements() {
        if settingsController.darkModeEnabled() {
            view.backgroundColor = InterfaceColors.viewBackgroundColor
            tableView.separatorColor = InterfaceColors.separatorColor
            
        } else {
            view.backgroundColor = InterfaceColors.viewBackgroundColor
            tableView.separatorColor = nil
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsSwitchCell", for: indexPath) as! SettingsSwitchCell
            cell.textLabel?.text = "\(delete[indexPath.row])"
            
            settingsController.setupDynamicCells(cell: cell, enableArrow: false)
            
            cell.selectionStyle = .none
            cell.switchButton.addTarget(self, action: #selector(showAlertOnDeleteSwitchPressed), for: .valueChanged)
            
            if defaults.bool(forKey: "showAlertOnDelete") == true {
                cell.switchButton.isOn = true
            } else {
                cell.switchButton.isOn = false
            }
            
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsSwitchCell", for: indexPath) as! SettingsSwitchCell
            
            settingsController.setupDynamicCells(cell: cell, enableArrow: false)
            
            cell.textLabel?.text = "\(sort[indexPath.row])"
            cell.selectionStyle = .none
            cell.switchButton.addTarget(self, action: #selector(showAlertOnSortSwitchPressed), for: .valueChanged)
            
            if defaults.bool(forKey: "showAlertOnSort") == true {
                cell.switchButton.isOn = true
            } else {
                cell.switchButton.isOn = false
            }
            
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsSwitchCell", for: indexPath) as! SettingsSwitchCell
            
            settingsController.setupDynamicCells(cell: cell, enableArrow: false)
            
            cell.textLabel?.text = "\(rating[indexPath.row])"
            cell.selectionStyle = .none
            cell.switchButton.addTarget(self, action: #selector(showRatingPrompt), for: .valueChanged)
            
            if defaults.bool(forKey: "showRatingPrompt") == true {
                cell.switchButton.isOn = true
            } else {
                cell.switchButton.isOn = false
            }
            
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsCell", for: indexPath) as! SettingsCell
            
            cell.backgroundColor = UIColor.white
            cell.textLabel?.textColor = UIColor.black
            return cell
        }
    }
    
    @objc func showAlertOnDeleteSwitchPressed(sender: UISwitch) {
        if sender.isOn {
            print("showAlertOnDelete enabled")
            defaults.set(true, forKey: "showAlertOnDelete")
            
        } else {
            print("showAlertOnDelete disabled")
            defaults.set(false, forKey: "showAlertOnDelete")
        }
    }
    
    @objc func showAlertOnSortSwitchPressed(sender: UISwitch) {
        if sender.isOn {
            print("showAlertOnSort enabled")
            defaults.set(true, forKey: "showAlertOnSort")
            
        } else {
            print("showAlertOnSort disabled")
            defaults.set(false, forKey: "showAlertOnSort")
        }
    }
    
    @objc func showRatingPrompt(sender: UISwitch) {
        if sender.isOn {
            print("showRatingPrompt enabled")
            defaults.set(true, forKey: "showRatingPrompt")
            
        } else {
            print("showRatingPrompt disabled")
            defaults.set(false, forKey: "showRatingPrompt")
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        switch section {
        case 0:
            return "By default Jotify displays an alert when you delete a note. To remove this confirmation, toggle the above setting."
        case 1:
            return "By default Jotify displays an alert to select which criteria you would like to sort by. To remove this alert, toggle the above setting."
        case 2:
            return "By default Jotify displays a review prompt once every update if the user has more than 15 notes. To remove this prompt, toggle the above setting."
        default:
            return ""
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section]
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else if section == 1 {
            return 1
        } else if section == 2 {
            return 1
        } else {
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        Themes().triggerSystemMode(mode: traitCollection)
        setupDynamicElements()
        tableView.reloadData()
        
        Themes().setupPersistentNavigationBar(navController: navigationController ?? UINavigationController())
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return Themes().setStatusBar(traitCollection: traitCollection)
    }
}
