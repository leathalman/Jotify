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
    
    override func viewDidLoad() {
        setupView()
        
    }
    
    func setupView() {
        title = "Settings"
        
        view.backgroundColor = Colors.lightGray
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationController?.navigationBar.tintColor = Colors.sunrise
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 40
        
        tableView.register(SettingsCell.self, forCellReuseIdentifier: "SettingsCell")
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
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = UIColor.init(red: 250, green: 77, blue: 77, alpha: 1)
        
        let title = UILabel()
        title.text = "HEllO"
        title.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        title.textColor = .white
        view.addSubview(title)
        title.translatesAutoresizingMaskIntoConstraints = false
        
        title.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        title.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16).isActive = true
        
        return view
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsCell", for: indexPath) as! SettingsCell
        
        switch indexPath.section {
        case 0:
            cell.backgroundColor = .red
        case 1:
            cell.backgroundColor = .blue
        default:
            break
        }
        
        return cell
    }
    
}
