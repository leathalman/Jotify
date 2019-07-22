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
    let general: Array = ["About", "Note Palettes", "Data", "Sort", "Dark Mode"]
    let advanced: Array = ["Show Tutorial","Reset Settings to Default", "Delete All Data"]
    
    let themes = Themes()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Settings"
        
        tableView.contentInset = UIEdgeInsets(top: -36, left: 0, bottom: 0, right: 0)
                
        tableView.register(SettingsCell.self, forCellReuseIdentifier: "SettingsCell")
        tableView.register(SettingsSwitchCell.self, forCellReuseIdentifier: "SettingsSwitchCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        setupDynamicViewElements()
    }
    
    func setupDynamicViewElements() {
        if darkModeEnabled() == false {
            view.backgroundColor = InterfaceColors.viewBackgroundColor
            
            tableView.separatorColor = nil
            
            setupDefaultPersistentNavigationBar()
            
        } else if darkModeEnabled() == true {
            view.backgroundColor = InterfaceColors.viewBackgroundColor

            tableView.separatorColor = InterfaceColors.separatorColor
            
            setupDarkPersistentNavigationBar()
        }
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
        
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try managedContext.execute(batchDeleteRequest)
            try managedContext.save()
            
        } catch {
            print("Error batch deleting data of entity: \(entity)")
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
                navigationController?.pushViewController(ColorSettingsController(style: .grouped), animated: true)
            case 2:
                navigationController?.pushViewController(DataSettingsController(style: .grouped), animated: true)
            case 3:
                navigationController?.pushViewController(SortSettingsController(style: .grouped), animated: true)
            default:
                return
            }
            
        } else if indexPath.section == 1 {
            switch indexPath.row {
            case 0:
                let writeNoteController = WriteNoteController()
                writeNoteController.presentOnboarding(viewController: self, tintColor: StoredColors.noteColor)
               
            case 1:
                let alert = UIAlertController(title: "Are you sure?", message: "This will reset all settings to default.", preferredStyle: .alert)
                
                alert.addAction(UIAlertAction(title: "Reset", style: .destructive, handler: { (UIAlertAction) in
                    let standard = UserDefaults.standard
                    
                    standard.set("default", forKey: "noteColorTheme")
                    let colorSettingsController = ColorSettingsController()
                    colorSettingsController.fetchData()
                    colorSettingsController.setNewColorsForExistingNotes()
                    
                    standard.set(true, forKey: "useRandomColor")
                    standard.set("date", forKey: "sortBy")
                    standard.set(true, forKey: "showAlertOnDelete")
                    standard.set(true, forKey: "showAlertOnSort")
                }))
                
                alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                present(alert, animated: true)
                
                
            case 2:
                print("Delete all data")
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
            case 4:
                let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsSwitchCell", for: indexPath) as! SettingsSwitchCell
                
                cell.textLabel?.text = "\(general[indexPath.row])"
                
                setupDynamicCells(cell: cell, enableArrow: false)
                
                cell.selectionStyle = .none
                
                cell.switchButton.addTarget(self, action: #selector(darkModePressed), for: .valueChanged)
                
                if UserDefaults.standard.bool(forKey: "darkModeEnabled") == true {
                    cell.switchButton.isOn = true
                } else {
                    cell.switchButton.isOn = false
                }
                
                return cell
            default:
                let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsCell", for: indexPath) as! SettingsCell
                
                cell.textLabel?.text = "\(general[indexPath.row])"
                
                setupDynamicCells(cell: cell, enableArrow: false)
                
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
    
    @objc func darkModePressed(sender: UISwitch) {
        if sender.isOn {
            print("darkModeEnabled")
            UserDefaults.standard.set(true, forKey: "darkModeEnabled")
            themes.setupDarkMode()
        
            self.viewWillAppear(true)
            self.tableView.reloadData()
            
        } else {
            print("darkModeDisabled")
            UserDefaults.standard.set(false, forKey: "darkModeEnabled")
            themes.setupDefaultMode()
            
            self.viewWillAppear(true)
            self.tableView.reloadData()
        }
    }
    
    func darkModeEnabled() -> Bool {
        if UserDefaults.standard.bool(forKey: "darkModeEnabled") == true {
            return true
        } else {
            return false
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
}
