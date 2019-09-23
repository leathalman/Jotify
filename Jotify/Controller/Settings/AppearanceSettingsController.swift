//
//  AppearanceSettingsController.swift
//  Jotify
//
//  Created by Harrison Leath on 8/4/19.
//  Copyright © 2019 Harrison Leath. All rights reserved.
//

import UIKit
import Pageboy
import CoreData

class AppearanceSettingsController: UITableViewController {
    
    var notes: [Note] = []
    
    let themes = Themes()
    
    let sections: Array = ["Dark Mode", "Themes", "Text", "Other"]
    let darks: Array = ["Vibrant Dark Mode", "Pure Dark Mode" ]
    let text: Array = ["Placeholder"]
    let other: Array = ["Random Colors"]
    
    let settingsController = SettingsController()
    
    var lastIndexPath:NSIndexPath = NSIndexPath(row: 0, section: 0)
    
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchData()
        
        navigationItem.title = "Appearance"
        
        tableView.register(SettingsCell.self, forCellReuseIdentifier: "SettingsCell")
        tableView.register(SettingsSwitchCell.self, forCellReuseIdentifier: "SettingsSwitchCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        setupDynamicElements()
    }
    
    func setupDynamicElements() {
        if settingsController.darkModeEnabled() == false {
            view.backgroundColor = InterfaceColors.viewBackgroundColor
            tableView.separatorColor = nil
            setupDefaultPersistentNavigationBar()
            
        } else if settingsController.darkModeEnabled() == true {
            view.backgroundColor = InterfaceColors.viewBackgroundColor
            tableView.separatorColor = .white
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
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.section == 0 {
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
            
        } else if indexPath.section == 1 {
            navigationController?.pushViewController(ThemeSelectionController(style: .grouped), animated: true)
            
        } else if indexPath.section == 2 {
            let alert = UIAlertController(title: "Placeholder", message: "Input a custom message for the placeholder.", preferredStyle: .alert)
            
            let cell = tableView.cellForRow(at: indexPath)
            cell?.isSelected = false
            
            alert.addTextField { (textField) in
                let placeholder = UserDefaults.standard.string(forKey: "writeNotePlaceholder")
                textField.placeholder = placeholder
                textField.autocorrectionType = .yes
                textField.autocapitalizationType = .sentences
            }
            
            alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { [weak alert] (_) in
                print(alert?.message ?? "cancel")
                print("cancel")
            }))
            
            alert.addAction(UIAlertAction(title: "Done", style: .default, handler: { [weak alert] (_) in
                let textField = alert?.textFields![0]
                let text = textField?.text
                
                if text?.isEmpty ?? false {
                    //                    UserDefaults.standard.set(text, forKey: "writeNotePlaceholder")
                } else {
                    UserDefaults.standard.set(text, forKey: "writeNotePlaceholder")
                }
            }))
            
            self.present(alert, animated: true, completion: nil)
        }
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            switch indexPath.row {
            case 0:
                let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsSwitchCell", for: indexPath) as! SettingsSwitchCell
                
                settingsController.setupDynamicCells(cell: cell, enableArrow: false)
                
                cell.textLabel?.text = "\(darks[indexPath.row])"
                cell.selectionStyle = .none
                cell.switchButton.addTarget(self, action: #selector(vibrantDarkModeSwitchPressed(sender:)), for: .valueChanged)
                
                if defaults.bool(forKey: "vibrantDarkModeEnabled") == true {
                    cell.switchButton.isOn = true
                } else {
                    cell.switchButton.isOn = false
                }
                
                return cell
                
            case 1:
                let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsSwitchCell", for: indexPath) as! SettingsSwitchCell
                
                settingsController.setupDynamicCells(cell: cell, enableArrow: false)
                
                cell.textLabel?.text = "\(darks[indexPath.row])"
                cell.selectionStyle = .none
                cell.switchButton.addTarget(self, action: #selector(pureDarkModeSwitchPressed(sender:)), for: .valueChanged)
                
                if defaults.bool(forKey: "pureDarkModeEnabled") == true {
                    cell.switchButton.isOn = true
                } else {
                    cell.switchButton.isOn = false
                }
                
                return cell
                
            default:
                let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsCell", for: indexPath) as! SettingsCell
                print("cell outside of bounds")
                return cell
            }
            
        } else if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsCell", for: indexPath) as! SettingsCell
            
            settingsController.setupDynamicCells(cell: cell, enableArrow: true)
            
            cell.accessoryType = .disclosureIndicator
            cell.textLabel?.text = "Themes"
            
            return cell
            
        } else if indexPath.section == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsCell", for: indexPath) as! SettingsCell
            
            settingsController.setupDynamicCells(cell: cell, enableArrow: true)
            
            cell.accessoryType = .disclosureIndicator
            cell.textLabel?.text = "\(text[indexPath.row])"
            
            return cell
            
        } else if indexPath.section == 3 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsSwitchCell", for: indexPath) as! SettingsSwitchCell
            
            settingsController.setupDynamicCells(cell: cell, enableArrow: false)
            
            cell.textLabel?.text = "\(other[indexPath.row])"
            cell.selectionStyle = .none
            cell.switchButton.addTarget(self, action: #selector(randomColorSwitchPressed), for: .valueChanged)
            
            if defaults.bool(forKey: "useRandomColor") == true {
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
    
    func setNewColorsForExistingNotes() {
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        
        let writeNoteView = WriteNoteView()
        var newBackgroundColor = UIColor.white
        
        for note in notes {
            var newColor = String()
            let colorTheme = defaults.string(forKey: "noteColorTheme")
            
            if colorTheme == "default" {
                newColor = Colors.defaultColorsStrings.randomElement() ?? "white"
                newBackgroundColor = Colors.defaultColors.randomElement() ?? UIColor.white
                
            } else if colorTheme == "sunset" {
                newColor = Colors.sunsetColorsStrings.randomElement() ?? "white"
                newBackgroundColor = Colors.sunsetColors.randomElement() ?? UIColor.white
                
            } else if colorTheme == "kypool" {
                newColor = Colors.kypoolColorsStrings.randomElement() ?? "white"
                newBackgroundColor = Colors.kypoolColors.randomElement() ?? UIColor.white
                
            } else if colorTheme == "celestial" {
                newColor = Colors.celestialColorsStrings.randomElement() ?? "white"
                newBackgroundColor = Colors.celestialColors.randomElement() ?? UIColor.white
                
            } else if colorTheme == "appleVibrant" {
                newColor = Colors.appleVibrantColorsStrings.randomElement() ?? "white"
                newBackgroundColor = Colors.appleVibrantColors.randomElement() ?? UIColor.white
            }
            
            note.color = newColor
        }
        
        writeNoteView.colorView.backgroundColor = newBackgroundColor
        
        appDelegate.saveContext()
    }
    
    @objc func vibrantDarkModeSwitchPressed(sender: UISwitch) {
        if sender.isOn {
            print("vibrant dark mode enabled")
            defaults.set(true, forKey: "vibrantDarkModeEnabled")
            defaults.set(false, forKey: "pureDarkModeEnabled")
            defaults.set(true, forKey: "darkModeEnabled")
            themes.setupDarkMode()
            
            self.viewWillAppear(true)
            self.tableView.reloadData()
            
        } else {
            print("vibrant dark mode disabled")
            defaults.set(false, forKey: "vibrantDarkModeEnabled")
            defaults.set(false, forKey: "darkModeEnabled")
            themes.setupDefaultMode()
            
            self.viewWillAppear(true)
            self.tableView.reloadData()
        }
        
    }
    
    @objc func pureDarkModeSwitchPressed(sender: UISwitch) {
        if sender.isOn {
            print("pure dark mode enabled")
            defaults.set(true, forKey: "pureDarkModeEnabled")
            defaults.set(false, forKey: "vibrantDarkModeEnabled")
            defaults.set(true, forKey: "darkModeEnabled")
            themes.setupPureDarkMode()
            
            self.viewWillAppear(true)
            self.tableView.reloadData()
            
        } else {
            print("pure dark mode disabled")
            defaults.set(false, forKey: "pureDarkModeEnabled")
            defaults.set(false, forKey: "darkModeEnabled")
            themes.setupDefaultMode()
            
            self.viewWillAppear(true)
            self.tableView.reloadData()
        }
    }
    
    @objc func randomColorSwitchPressed(sender: UISwitch) {
        if sender.isOn {
            print("random colors enabled")
            defaults.set(true, forKey: "useRandomColor")
            setNewColorsForExistingNotes()
            
        } else {
            print("random colors disabled")
            defaults.set(false, forKey: "useRandomColor")
            
            let colorPickerController = ColorPickerController()
            
            navigationController?.pushViewController(colorPickerController, animated: true)
        }
    }
    
    
    func fetchData() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Note")
        fetchRequest.returnsObjectsAsFaults = false
        
        let sortDescriptor = NSSortDescriptor(key: "date", ascending: false)
        
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        do {
            notes = try managedContext.fetch(fetchRequest) as! [Note]
            
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Vibrant dark mode retains the color of your notes while pure dark mode replaces these colors with black."
        case 1:
            return "Pick the color theme for your notes."
        case 2:
            return "Customize the message on the screen where you create notes."
        case 3:
            return "Turing this off will require you to select a new default color for all notes."
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
        switch section {
        case 0:
            return darks.count
        case 1:
            return 1
        case 2:
            return text.count
        case 3:
            return other.count
        default:
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
}
