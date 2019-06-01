//
//  SettingsController.swift
//  Sticky Notes
//
//  Created by Harrison Leath on 5/12/19.
//  Copyright © 2019 Harrison Leath. All rights reserved.
//

import UIKit

class SettingsController: UITableViewController {
    
    var userInfoHeader: UserInfoHeader!
    var darkModeEnabled = Bool()
//    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        setupView()
        
//        self.tableView.backgroundColor = UIColor.flatBlue
//        view.backgroundColor = UIColor.flatRedDark
        navigationController?.navigationBar.isTranslucent = false
//        navigationController?.navigationBar.tintColor = UIColor.flatBlue
//        navigationController?.navigationBar.backgroundColor = UIColor.flatBlue
    }
    
    func setupView() {
        title = "Settings"
        
//        darkModeEnabled = defaults.bool(forKey: "DarkDefault")
//        print(darkModeEnabled)
        
        self.navigationController?.navigationBar.prefersLargeTitles = true
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 80
        
        tableView.register(SettingsCell.self, forCellReuseIdentifier: "SettingsCell")
        tableView.register(SettingsSwitchCell.self, forCellReuseIdentifier: "SettingsSwitchCell")
        tableView.frame = view.frame
        
        let frame = CGRect(x: 0, y: 88, width: view.frame.width, height: 100)
        userInfoHeader = UserInfoHeader(frame: frame)
        tableView.tableHeaderView = userInfoHeader
        tableView.tableFooterView = UIView()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch section {
        case 0:
            //number of cells in 1st section
            return 2
        case 1:
            return 3
        default:
            return 0
        }
        
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            //number of cells in 1st section
            return "General"
        case 1:
            return "Theme"
        default:
            return "Other"
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell()
        let section1 = ["Dark Mode", "Setting 2"]
        let section2 = ["Setting 3", "Setting 4", "Setting 5"]
        
        switch indexPath.section {
            
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsSwitchCell", for: indexPath) as! SettingsSwitchCell
            cell.backgroundColor = .white
            cell.labelText.text = section1[indexPath.row]
            cell.selectionStyle = .none
            
            if indexPath.row == 0 {
                cell.switchButton.addTarget(self, action: #selector(self.darkModeSwitchClicked(_:)), for: .valueChanged)
            } else if indexPath.row == 1 {
//                cell.switchButton.addTarget(self, action: #selector(self.switchChanged2(_:)), for: .valueChanged)
            } else {
                print("out of bounds")
            }
            
            return cell
            
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsCell", for: indexPath) as! SettingsCell
            cell.backgroundColor = .white
            cell.textLabel?.text = section2[indexPath.row]
            return cell
            
        default:
            break
        }
        return cell
    }
    
    @objc func darkModeSwitchClicked (_ sender : UISwitch!){
//        Theme.darkTheme()
//        let indexPath = tableView.indexPathsForVisibleRows
//        tableView.reloadRows(at: indexPath!, with: .fade)
        print("Switch flipped")
    }
    
    @objc func switchChanged2 (_ sender : UISwitch!){
        print("switch clicked2")
    }
    
}
