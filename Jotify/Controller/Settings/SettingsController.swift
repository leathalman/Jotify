//
//  SettingsController.swift
//  Sticky Notes
//
//  Created by Harrison Leath on 5/12/19.
//  Copyright © 2019 Harrison Leath. All rights reserved.
//

import UIKit

class SettingsController: UITableViewController {
    
    let sections: Array = ["Appearance", "Other"]
    let general: Array = ["App Icon", "Note Color Themes", "Setting 3", "Setting 4", "Setting 5"]
    let other: Array = ["Dark Mode"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.white
        
        navigationItem.title = "Settings"
        
        tableView.contentInset = UIEdgeInsets(top: -36, left: 0, bottom: 0, right: 0)
        
//        tableView.tableHeaderView = UserInfoHeader()
        
        tableView.register(SettingsCell.self, forCellReuseIdentifier: "SettingsCell")
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int{
        return sections.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section]
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Num: \(indexPath.row)")
        
        if indexPath.section == 0 {
            
            switch indexPath.row {
            case 0:
                print("0")
            case 1:
                navigationController?.pushViewController(ColorSettingsController(style: .grouped), animated: true)
            case 2:
                print("2")
            default:
                print("default")
            }
            
        } else if indexPath.section == 1 {
            
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return general.count
        } else if section == 1 {
            return other.count
        } else {
            return 0
        }
    }
    
    public override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsCell", for: indexPath) as! SettingsCell
            
            cell.textLabel?.text = "\(general[indexPath.row])"
            cell.backgroundColor = UIColor.white
            cell.textLabel?.textColor = UIColor.black
            cell.accessoryType = .disclosureIndicator
            
            return cell
            
        } else if indexPath.section == 1 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsCell", for: indexPath) as! SettingsCell
            
            cell.textLabel?.text = "Dark Mode"
            
            return cell
            
        } else {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsCell", for: indexPath) as! SettingsCell
            

                cell.backgroundColor = UIColor.white
                cell.textLabel?.textColor = UIColor.black
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
}
