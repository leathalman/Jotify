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
    var section1: [String] = []
    var section2: [String] = []
    
    var noteCollection: NoteCollection?
    
    override func viewWillAppear(_ animated: Bool) {
        handleStatusBarStyle(style: .darkContent)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //fixes issue where tableview becomes unresponsive when disabling swipe
        tableView.contentInset = .zero
        tableView.isUserInteractionEnabled = true
        tableView.isScrollEnabled = true
        
        view.backgroundColor = ColorManager.bgColor
        
        navigationController?.setColor(color: ColorManager.bgColor)
        navigationController?.enablePersistence()
        
        tableView.register(SettingsCell.self, forCellReuseIdentifier: "SettingsCell")
        tableView.register(SettingsSwitchCell.self, forCellReuseIdentifier: "SettingsSwitchCell")
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return section1.count
        } else if section == 1 {
            return section2.count
        }
        return 0
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section]
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        handleStatusBarStyle(style: .darkContent)
        view.backgroundColor = ColorManager.bgColor
        navigationController?.setColor(color: ColorManager.bgColor)
    }
}
