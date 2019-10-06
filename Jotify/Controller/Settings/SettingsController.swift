//
//  SettingsController.swift
//  Sticky Notes
//
//  Created by Harrison Leath on 5/12/19.
//  Copyright © 2019 Harrison Leath. All rights reserved.
//

import UIKit
import CoreData

class SettingsController: UITableViewController {
    
    let sections: Array = ["General", "Advanced"]
    let general: Array = ["About", "Appearance", "Privacy", "Alerts"]
    let advanced: Array = ["Show Tutorial", "Reset Settings to Default", "Delete All Data"]
    
    let themes = Themes()
    
    let defaults = UserDefaults.standard
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        setupDynamicViewElements()
        removeExtraHeaderView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.contentInset = .zero
        
        navigationItem.title = "Settings"
        
        tableView.register(SettingsCell.self, forCellReuseIdentifier: "SettingsCell")
        tableView.register(SettingsSwitchCell.self, forCellReuseIdentifier: "SettingsSwitchCell")
    }
    
    func setupDynamicViewElements() {
        if darkModeEnabled() == true {
            if UserDefaults.standard.bool(forKey: "vibrantDarkModeEnabled") {
                themes.setupVibrantDarkMode()
                
                view.backgroundColor = InterfaceColors.viewBackgroundColor
                
                tableView.separatorColor = InterfaceColors.separatorColor
                
                self.tableView.reloadData()
                
                setupDarkPersistentNavigationBar()
            } else if UserDefaults.standard.bool(forKey: "pureDarkModeEnabled") == true {
                themes.setupPureDarkMode()
                
                view.backgroundColor = InterfaceColors.viewBackgroundColor
                
                tableView.separatorColor = InterfaceColors.separatorColor
                
                self.tableView.reloadData()
                
                setupDarkPersistentNavigationBar()
            }
            
            
        } else if darkModeEnabled() == false {
            view.backgroundColor = InterfaceColors.viewBackgroundColor
            
            tableView.separatorColor = nil
            
            themes.setupDefaultMode()
            self.tableView.reloadData()
            
            setupDefaultPersistentNavigationBar()
        }
    }
    
    func removeExtraHeaderView() {
        var frame = CGRect.zero
        frame.size.height = .leastNormalMagnitude
        tableView.tableHeaderView = UIView(frame: frame)
    }
    
    func setupDefaultPersistentNavigationBar() {
        navigationController?.navigationBar.backgroundColor = InterfaceColors.navigationBarColor
        navigationController?.navigationBar.barTintColor = InterfaceColors.navigationBarColor
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
        navigationController?.navigationBar.barStyle = .default
        navigationController?.navigationBar.isTranslucent = false
    }
    
    func setupDarkPersistentNavigationBar() {
        navigationController?.navigationBar.backgroundColor = InterfaceColors.navigationBarColor
        navigationController?.navigationBar.barTintColor = InterfaceColors.navigationBarColor
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navigationController?.navigationBar.barStyle = .black
        navigationController?.navigationBar.isTranslucent = false
    }
    
    func deleteAllNotes(entity: String) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        CoreDataManager.shared.enqueue { (context) in
            do {
                try context.execute(batchDeleteRequest)
                try context.save()
                
            } catch let error as NSError {
                print("Could not save. \(error), \(error.userInfo)")
            }
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int{
        return sections.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section]
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            
            switch indexPath.row {
            case 0:
                navigationController?.pushViewController(AboutSettingsController(), animated: true)
            case 1:
                navigationController?.pushViewController(AppearanceSettingsController(style: .insetGrouped), animated: true)
            case 2:
                navigationController?.pushViewController(PrivacySettingsController(style: .insetGrouped), animated: true)
            case 3:
                navigationController?.pushViewController(SortSettingsController(style: .insetGrouped), animated: true)
            default:
                return
            }
            
        } else if indexPath.section == 1 {
            switch indexPath.row {
            case 0:
                let writeNoteController = WriteNoteController()
                writeNoteController.presentFirstLaunchOnboarding(viewController: self, tintColor: StoredColors.noteColor)
                
                let cell = tableView.cellForRow(at: indexPath)
                cell?.isSelected = false
                
            case 1:
                let alert = UIAlertController(title: "Are you sure?", message: "This will reset all settings to default.", preferredStyle: .alert)
                
                let cell = tableView.cellForRow(at: indexPath)
                cell?.isSelected = false
                
                alert.addAction(UIAlertAction(title: "Reset", style: .destructive, handler: { (UIAlertAction) in
                    
                    self.defaults.set("default", forKey: "noteColorTheme")
                    let appearanceSettingsController = AppearanceSettingsController()
                    appearanceSettingsController.fetchData()
                    appearanceSettingsController.setNewColorsForExistingNotes()
                    
                    self.defaults.set(true, forKey: "useRandomColor")
                    self.defaults.set("date", forKey: "sortBy")
                    self.defaults.set(true, forKey: "showAlertOnDelete")
                    self.defaults.set(true, forKey: "showAlertOnSort")
                    self.defaults.set(false, forKey: "darkModeEnabled")
                    self.defaults.set(false, forKey: "vibrantDarkModeEnabled")
                    self.defaults.set(false, forKey: "pureDarkModeEnabled")
                    self.defaults.set(true, forKey: "isFirstLaunch")
                    self.defaults.set(false, forKey: "useBiometrics")
                    self.defaults.set("Start typing or swipe left for saved notes...", forKey: "writeNotePlaceholder")
                }))
                
                alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                present(alert, animated: true)
                
            case 2:
                print("Delete all data")
                let cell = tableView.cellForRow(at: indexPath)
                cell?.isSelected = false
                
                let alert = UIAlertController(title: "Are you sure?", message: "This will permanently delete all data saved in both iCloud and saved locally on this device.", preferredStyle: .alert)
                
                alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { (UIAlertAction) in
                    self.deleteAllNotes(entity: "Note")
                }))
                
                alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                present(alert, animated: true)
                
            default:
                print("default")
            }
            
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return general.count
        } else if section == 1 {
            return advanced.count
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
                cell.backgroundColor = InterfaceColors.cellColor
                
                setupDynamicCells(cell: cell, enableArrow: true)
                
                cell.accessoryType = .disclosureIndicator
                
                return cell
                
            case 1:
                let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsCell", for: indexPath) as! SettingsCell
                
                cell.textLabel?.text = "\(general[indexPath.row])"
                
                setupDynamicCells(cell: cell, enableArrow: true)
                
                cell.accessoryType = .disclosureIndicator
                
                return cell
                
            case 2:
                let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsCell", for: indexPath) as! SettingsCell
                
                cell.textLabel?.text = "\(general[indexPath.row])"
                
                setupDynamicCells(cell: cell, enableArrow: true)
                
                cell.accessoryType = .disclosureIndicator
                
                return cell
                
            case 3:
                let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsCell", for: indexPath) as! SettingsCell
                
                cell.textLabel?.text = "\(general[indexPath.row])"
                
                setupDynamicCells(cell: cell, enableArrow: true)
                
                cell.accessoryType = .disclosureIndicator
                
                return cell
                
            default:
                let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsCell", for: indexPath) as! SettingsCell
                
                cell.textLabel?.text = "\(general[indexPath.row])"
                
                setupDynamicCells(cell: cell, enableArrow: true)
                
                cell.accessoryType = .disclosureIndicator
                
                return cell
            }
            
        } else if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsCell", for: indexPath) as! SettingsCell
            cell.textLabel?.text = "\(advanced[indexPath.row])"
            
            switch indexPath.row {
            case 0:
                cell.backgroundColor = UIColor.white
                cell.backgroundColor = InterfaceColors.cellColor
                cell.textLabel?.textColor = UIColor.lightBlue
                
            case 1:
                cell.backgroundColor = UIColor.white
                cell.backgroundColor = InterfaceColors.cellColor
                cell.textLabel?.textColor = UIColor.lightBlue
                
            case 2:
                cell.backgroundColor = UIColor.white
                cell.backgroundColor = InterfaceColors.cellColor
                cell.textLabel?.textColor = UIColor.red
                
            default:
                return cell
                
            }
            
            return cell
            
        } else {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsCell", for: indexPath) as! SettingsCell
            
            cell.backgroundColor = UIColor.white
            cell.textLabel?.textColor = UIColor.black
            return cell
        }
    }
    
    func setupDynamicCells(cell: UITableViewCell, enableArrow: Bool) {
        cell.backgroundColor = UIColor.white
        cell.backgroundColor = InterfaceColors.cellColor
        
        cell.textLabel?.textColor = UIColor.black
        cell.textLabel?.textColor = InterfaceColors.fontColor
        
        if enableArrow == true {
            if darkModeEnabled() == true {
                cell.accessoryView = UIImageView(image: UIImage(systemName: "chevron.right.circle"))
                
            } else {
                cell.accessoryView = UIImageView(image: UIImage(systemName: "chevron.right.circle.fill"))
            }
        }
    }
    
    func darkModeEnabled() -> Bool {
        if defaults.bool(forKey: "darkModeEnabled") == true {
            return true
        } else {
            return false
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
}
