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
    var section3: [String] = []
    
    var noteCollection: NoteCollection?
    
    override func viewWillAppear(_ animated: Bool) {
        enableAutomaticStatusBarStyle()
        configureNavigationBar(bgColor: ColorManager.bgColor)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //fixes issue where tableview becomes unresponsive when disabling swipe
        tableView.contentInset = .zero
        tableView.isUserInteractionEnabled = true
        tableView.isScrollEnabled = true
        
        view.backgroundColor = ColorManager.bgColor
                
        tableView.register(SettingsCell.self, forCellReuseIdentifier: "SettingsCell")
        tableView.register(SettingsSwitchCell.self, forCellReuseIdentifier: "SettingsSwitchCell")
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return section1.count
        case 1:
            return section2.count
        case 2:
            return section3.count
        default:
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let title = sections[section]
        return title.isEmpty ? nil : title
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        enableAutomaticStatusBarStyle()
        view.backgroundColor = ColorManager.bgColor
        configureNavigationBar(bgColor: ColorManager.bgColor)
    }
}
