//
//  ReminderController.swift
//  Jotify
//
//  Created by Harrison Leath on 7/10/21.
//

import UIKit

class ReminderController: UITableViewController {
    
    var sections: [String] = ["Select Date And Time"]
    var section1: [String] = ["Date", "Time"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = ColorManager.bgColor
        tableView.separatorStyle = .none
        tableView.register(SettingsSwitchCell.self, forCellReuseIdentifier: "ReminderSwitchCell")
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReminderSwitchCell", for: indexPath) as! SettingsSwitchCell
        cell.selectionStyle = .none
        
        switch indexPath.section {
        case 0:
            cell.textLabel?.text = section1[indexPath.row]
        default:
            cell.textLabel?.text = "Example Text"
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return section1.count
        default:
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section]
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}
