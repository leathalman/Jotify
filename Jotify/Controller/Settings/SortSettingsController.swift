//
//  SortSettingsController.swift
//  Jotify
//
//  Created by Harrison Leath on 7/9/19.
//  Copyright © 2019 Harrison Leath. All rights reserved.
//

import UIKit

class SortSettingsController: UITableViewController {
    
    let sections: Array = ["Sort"]
    let general: Array = ["Show Alert on Sort"]
    
    let settingsController = SettingsController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Sort"
        
        setupDynamicElements()
        
        tableView.register(SettingsSwitchCell.self, forCellReuseIdentifier: "SettingsSwitchCell")
    }
    
    func setupDynamicElements() {
        if settingsController.darkModeEnabled() == false {
            view.backgroundColor = InterfaceColors.viewBackgroundColor
            
            tableView.separatorColor = nil
            
        } else if settingsController.darkModeEnabled() == true {
            view.backgroundColor = InterfaceColors.viewBackgroundColor
            
            tableView.separatorColor = InterfaceColors.separatorColor
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsSwitchCell", for: indexPath) as! SettingsSwitchCell
            
            settingsController.setupDynamicCells(cell: cell, enableArrow: false)
            
            cell.textLabel?.text = "\(general[indexPath.row])"
            cell.selectionStyle = .none
            cell.switchButton.addTarget(self, action: #selector(showAlertOnDeleteSwitchPressed), for: .valueChanged)
            
            if UserDefaults.standard.bool(forKey: "showAlertOnSort") == true {
                cell.switchButton.isOn = true
            } else {
                cell.switchButton.isOn = false
            }
            
            return cell
            
        } else {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsCell", for: indexPath) as! SettingsCell
            
            
            cell.backgroundColor = UIColor.white
            cell.textLabel?.textColor = UIColor.black
            return cell
        }
    }
    
    @objc func showAlertOnDeleteSwitchPressed(sender: UISwitch) {
        if sender.isOn {
            print("showAlertOnSort enabled")
            UserDefaults.standard.set(true, forKey: "showAlertOnSort")
            
        } else {
            print("showAlertOnSort disabled")
            UserDefaults.standard.set(false, forKey: "showAlertOnSort")
            
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        switch section {
        case 0:
            return "By default Jotify displays an alert to select which criteria you would like to sort by. To remove this alert, toggle the above setting."
            
        default:
            return ""
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int{
        return sections.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section]
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return general.count
        } else {
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
}


