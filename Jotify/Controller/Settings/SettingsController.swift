//
//  SettingsController.swift
//  Jotify
//
//  Created by Harrison Leath on 2/1/21.
//

import UIKit

//superclass for all settings controllers
class SettingsController: UITableViewController {
    //number of sections found in each VC
    var sections: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        removeExtraHeaderView()
        tableView.contentInset = .zero
        tableView.isUserInteractionEnabled = true
        tableView.isScrollEnabled = true
        tableView.register(SettingsCell.self, forCellReuseIdentifier: "SettingsCell")
        tableView.register(SettingsSwitchCell.self, forCellReuseIdentifier: "SettingsSwitchCell")
        
        navigationController?.enablePersistence()
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "disableSwipe"), object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "enableSwipe"), object: nil)
    }
    
    func removeExtraHeaderView() {
        var frame = CGRect.zero
        frame.size.height = .leastNormalMagnitude
        tableView.tableHeaderView = UIView(frame: frame)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section]
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}
