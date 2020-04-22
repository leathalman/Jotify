//
//  AppearanceSettingsController.swift
//  Jotify
//
//  Created by Harrison Leath on 8/4/19.
//  Copyright © 2019 Harrison Leath. All rights reserved.
//

import CoreData
import Pageboy
import UIKit

class AppearanceSettingsController: UITableViewController {
    var notes: [Note] = []
        
    let sections: Array = ["Dark Mode", "Themes", "Text", "Other"]
    let darks: Array = ["Use System Light/Dark Mode"]
    let darks2: Array = ["Use System Light/Dark Mode", "Vibrant Dark Mode", "Pure Dark Mode"]
    let text: Array = ["Custom Placeholder", "Enable Multiline Input"]
    let other: Array = ["Random Colors"]
    
    let settingsController = SettingsController()
    
    var lastIndexPath: NSIndexPath = NSIndexPath(row: 0, section: 0)
    
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchData()
        
        navigationItem.title = "Appearance"
        
        UIApplication.shared.windows.first?.backgroundColor = UIColor.grayBackground
        
        tableView.register(SettingsCell.self, forCellReuseIdentifier: "SettingsCell")
        tableView.register(SettingsSwitchCell.self, forCellReuseIdentifier: "SettingsSwitchCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        setupDynamicElements()
    }
    
    func setupDynamicElements() {
        if !settingsController.darkModeEnabled() {
            view.backgroundColor = InterfaceColors.viewBackgroundColor
            tableView.separatorColor = nil
            setupDefaultPersistentNavigationBar()
            
        } else if settingsController.darkModeEnabled() {
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
        switch indexPath.section {
        case 0:
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        case 1:
            navigationController?.pushViewController(ThemeSelectionController(style: .insetGrouped), animated: true)
        case 2:
            switch indexPath.row {
            case 0:
                let alert = UIAlertController(title: "Placeholder", message: "Input a custom message for the placeholder.", preferredStyle: .alert)
                
                let cell = tableView.cellForRow(at: indexPath)
                cell?.isSelected = false
                
                alert.addTextField { textField in
                    let placeholder = UserDefaults.standard.string(forKey: "writeNotePlaceholder")
                    textField.placeholder = placeholder
                    textField.autocorrectionType = .yes
                    textField.autocapitalizationType = .sentences
                }
                
                alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { [weak alert] _ in
                    print(alert?.message ?? "cancel")
                    print("cancel")
                }))
                
                alert.addAction(UIAlertAction(title: "Done", style: .default, handler: { [weak alert] _ in
                    let textField = alert?.textFields![0]
                    let text = textField?.text
                    
                    if text?.isEmpty ?? false {
                    } else {
                        UserDefaults.standard.set(text, forKey: "writeNotePlaceholder")
                    }
                }))
                
                present(alert, animated: true, completion: nil)
            case 1:
                print("Tapped")
            default:
                print("Tapped")
            }
        default:
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsCell") as! SettingsCell
        
        if indexPath.section == 0 && !UserDefaults.standard.bool(forKey: "useSystemMode") {
            // when user decides to not use System Light or Dark mode
            // show 3 cells
            // allow for bottom two to have independent functions
            switch indexPath.row {
            case 0:
                let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsSwitchCell", for: indexPath) as! SettingsSwitchCell
                
                settingsController.setupDynamicCells(cell: cell, enableArrow: false)
                
                cell.textLabel?.text = "\(darks2[indexPath.row])"
                cell.selectionStyle = .none
                cell.switchButton.addTarget(self, action: #selector(useSystemMode(sender:)), for: .valueChanged)

                if defaults.bool(forKey: "useSystemMode") {
                    cell.switchButton.isOn = true
                } else {
                    cell.switchButton.isOn = false
                }
                
                return cell
            case 1:
                let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsSwitchCell", for: indexPath) as! SettingsSwitchCell
                
                settingsController.setupDynamicCells(cell: cell, enableArrow: false)
                
                cell.textLabel?.text = "\(darks2[indexPath.row])"
                cell.selectionStyle = .none
                cell.switchButton.addTarget(self, action: #selector(vibrantDarkModeSwitchPressed(sender:)), for: .valueChanged)
                if defaults.bool(forKey: "vibrantDarkModeEnabled") {
                    cell.switchButton.isOn = true
                } else {
                    cell.switchButton.isOn = false
                }
                
                return cell
                
            case 2:
                let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsSwitchCell", for: indexPath) as! SettingsSwitchCell
                
                settingsController.setupDynamicCells(cell: cell, enableArrow: false)
                
                cell.textLabel?.text = "\(darks2[indexPath.row])"
                cell.selectionStyle = .none
                cell.switchButton.addTarget(self, action: #selector(pureDarkModeSwitchPressed(sender:)), for: .valueChanged)
                
                if defaults.bool(forKey: "pureDarkModeEnabled") {
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
            
        } else if indexPath.section == 0 && UserDefaults.standard.bool(forKey: "useSystemMode") {
            // when the user decided to use System Light or Dark Mode
            // toggle on means only show 1 cell
            switch indexPath.row {
            case 0:
                let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsSwitchCell", for: indexPath) as! SettingsSwitchCell
                
                settingsController.setupDynamicCells(cell: cell, enableArrow: false)
                
                cell.textLabel?.text = "\(darks[indexPath.row])"
                cell.selectionStyle = .none
                cell.switchButton.addTarget(self, action: #selector(useSystemMode(sender:)), for: .valueChanged)

                if defaults.bool(forKey: "useSystemMode") {
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
            switch indexPath.row {
            case 0:
                let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsCell", for: indexPath) as! SettingsCell
                
                settingsController.setupDynamicCells(cell: cell, enableArrow: true)
                
                cell.accessoryType = .disclosureIndicator
                cell.textLabel?.text = "\(text[indexPath.row])"
                
                return cell
                
            case 1:
                let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsSwitchCell", for: indexPath) as! SettingsSwitchCell
                
                settingsController.setupDynamicCells(cell: cell, enableArrow: false)
                
                cell.textLabel?.text = "\(text[indexPath.row])"
                cell.selectionStyle = .none
                cell.switchButton.addTarget(self, action: #selector(enableMultilineInputSwitchPressed(sender:)), for: .valueChanged)
                
                if defaults.bool(forKey: "useMultilineInput") {
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
            
        } else if indexPath.section == 3 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsSwitchCell", for: indexPath) as! SettingsSwitchCell
            
            settingsController.setupDynamicCells(cell: cell, enableArrow: false)
            
            cell.textLabel?.text = "\(other[indexPath.row])"
            cell.selectionStyle = .none
            cell.switchButton.addTarget(self, action: #selector(randomColorSwitchPressed), for: .valueChanged)
            
            if defaults.bool(forKey: "useRandomColor") {
                cell.switchButton.isOn = true
            } else {
                cell.switchButton.isOn = false
            }
            
            return cell
        }
        return cell
    }
    
    func setNewColorsForExistingNotes() {
        let writeNoteView = WriteNoteView()
        var newBackgroundColor = UIColor.white
        
        for note in notes {
            var newColor = String()
            let colorTheme = defaults.string(forKey: "noteColorTheme")
            
            switch colorTheme {
            case "default":
                newColor = UIColor.defaultColorsStrings.randomElement() ?? "white"
                newBackgroundColor = UIColor.defaultColors.randomElement() ?? UIColor.white
            case "sunset":
                newColor = UIColor.sunsetColorsStrings.randomElement() ?? "white"
                newBackgroundColor = UIColor.sunsetColors.randomElement() ?? UIColor.white
            case "kypool":
                newColor = UIColor.kypoolColorsStrings.randomElement() ?? "white"
                newBackgroundColor = UIColor.kypoolColors.randomElement() ?? UIColor.white
            case "celestial":
                newColor = UIColor.celestialColorsStrings.randomElement() ?? "white"
                newBackgroundColor = UIColor.celestialColors.randomElement() ?? UIColor.white
            case "appleVibrant":
                newColor = UIColor.appleVibrantColorsStrings.randomElement() ?? "white"
                newBackgroundColor = UIColor.appleVibrantColors.randomElement() ?? UIColor.white
            case "scarletAzure":
                newColor = UIColor.scarletAzureColorsString.randomElement() ?? "white"
                newBackgroundColor = UIColor.scarletAzureColors.randomElement() ?? UIColor.white
            default:
                newColor = UIColor.defaultColorsStrings.randomElement() ?? "white"
                newBackgroundColor = UIColor.defaultColors.randomElement() ?? UIColor.white
            }
            
            note.color = newColor
        }
        
        writeNoteView.backgroundColor = newBackgroundColor
        
        CoreDataManager.shared.enqueue { context in
            do {
                try context.save()
                
            } catch let error as NSError {
                print("Could not save. \(error), \(error.userInfo)")
            }
        }
    }
    
    @objc func useSystemMode(sender: UISwitch) {
        if !defaults.bool(forKey: "com.austinleath.Jotify.Premium") {
            PremiumView.shared.presentPremiumView(viewController: self)
            sender.isOn = false
            
        } else {
            if sender.isOn {
                print("use system mode enabled")
                defaults.set(true, forKey: "useSystemMode")
                
                Themes().triggerSystemMode(mode: self.traitCollection)
                
                viewWillAppear(true)
                self.tableView.reloadData()
                
            } else {
                print("use system mode disabled")
                defaults.set(false, forKey: "useSystemMode")
                
                viewWillAppear(true)
                self.tableView.reloadData()
            }
        }
    }
    
    @objc func vibrantDarkModeSwitchPressed(sender: UISwitch) {
        if !defaults.bool(forKey: "com.austinleath.Jotify.Premium") {
            PremiumView.shared.presentPremiumView(viewController: self)
            sender.isOn = false
            
        } else {
            if sender.isOn {
                print("vibrant dark mode enabled")
                defaults.set(true, forKey: "vibrantDarkModeEnabled")
                defaults.set(false, forKey: "pureDarkModeEnabled")
                defaults.set(true, forKey: "darkModeEnabled")
                Themes().setupVibrantDarkMode()
                
                viewWillAppear(true)
                self.tableView.reloadData()
                
            } else {
                print("vibrant dark mode disabled")
                defaults.set(false, forKey: "vibrantDarkModeEnabled")
                defaults.set(false, forKey: "darkModeEnabled")
                Themes().setupDefaultMode()
                
                viewWillAppear(true)
                self.tableView.reloadData()
            }
        }
    }
    
    @objc func pureDarkModeSwitchPressed(sender: UISwitch) {
        if !defaults.bool(forKey: "com.austinleath.Jotify.Premium") {
            PremiumView.shared.presentPremiumView(viewController: self)
            sender.isOn = false
            
        } else {
            if sender.isOn {
                print("pure dark mode enabled")
                defaults.set(true, forKey: "pureDarkModeEnabled")
                defaults.set(false, forKey: "vibrantDarkModeEnabled")
                defaults.set(true, forKey: "darkModeEnabled")
                Themes().setupPureDarkMode()
                
                viewWillAppear(true)
                self.tableView.reloadData()
                
            } else {
                print("pure dark mode disabled")
                defaults.set(false, forKey: "pureDarkModeEnabled")
                defaults.set(false, forKey: "darkModeEnabled")
                Themes().setupDefaultMode()
                
                viewWillAppear(true)
                self.tableView.reloadData()
            }
        }
    }
    
    @objc func enableMultilineInputSwitchPressed(sender: UISwitch) {
        if !defaults.bool(forKey: "com.austinleath.Jotify.Premium") {
            PremiumView.shared.presentPremiumView(viewController: self)
            sender.isOn = false
            
        } else {
            if sender.isOn {
                print("Multiline input enabled")
                defaults.set(true, forKey: "useMultilineInput")
                
                let alert = UIAlertController(title: "Mutliline Input", message: "You have enabled multiline input! Now when you press return while writing a note, it will create a new line instead of saving. To save a note, simply swipe left. Tapping return WILL NOT save notes with this enabled.", preferredStyle: .alert)
                
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] _ in
                    print(alert?.message ?? "cancel")
                }))
                
                present(alert, animated: true, completion: nil)
                
            } else {
                print("Multiline input disabled")
                defaults.set(false, forKey: "useMultilineInput")
            }
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
            if !defaults.bool(forKey: "useSystemMode") {
                return "Vibrant dark mode retains the color of your notes while pure dark mode replaces these colors with black."
            } else {
                return "Jotify can automatically match your system's preference, or you can chose to toggle light/dark mode manually."
            }
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
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section]
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            if defaults.bool(forKey: "useSystemMode") {
                return darks.count
            } else {
                return darks2.count
            }
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
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {        
        Themes().triggerSystemMode(mode: traitCollection)
        setupDynamicElements()
        tableView.reloadData()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        if !UserDefaults.standard.bool(forKey: "useSystemMode") && !UserDefaults.standard.bool(forKey: "darkModeEnabled") {
            return .darkContent
        } else if !UserDefaults.standard.bool(forKey: "useSystemMode") && UserDefaults.standard.bool(forKey: "darkModeEnabled") {
            return .lightContent
        } else if UserDefaults.standard.bool(forKey: "useSystemMode") && traitCollection.userInterfaceStyle == .light {
            return .darkContent
        } else {
            return .lightContent
        }
    }
}
