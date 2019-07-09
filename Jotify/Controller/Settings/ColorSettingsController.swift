//
//  ColorSettingsController.swift
//  Jotify
//
//  Created by Harrison Leath on 7/7/19.
//  Copyright © 2019 Harrison Leath. All rights reserved.
//

import UIKit
import Pageboy
import CoreData

class ColorSettingsController: UITableViewController {
    
    var notes: [Note] = []
    
    let sections: Array = ["Palettes", "Other"]
    let palettes: Array = ["Default", "Sunset", "Kypool", "Celestial", "Apple Vibrant"]
    let other: Array = ["Random Colors"]
    
    var lastIndexPath:NSIndexPath = NSIndexPath(row: 0, section: 0)
    
    let defaults = UserDefaults.standard
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        setupPersistentNavigationBar()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchData()
        
        view.backgroundColor = UIColor.white
        
        navigationItem.title = "Note Palettes"
        
        tableView.register(SettingsCell.self, forCellReuseIdentifier: "SettingsCell")
        tableView.register(SettingsSwitchCell.self, forCellReuseIdentifier: "SettingsSwitchCell")
    }
    
    func setupPersistentNavigationBar() {
        self.navigationController?.navigationBar.backgroundColor = .white
        self.navigationController?.navigationBar.barTintColor = .white
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let newRow = indexPath.row
        let oldRow = lastIndexPath.row
        
        if oldRow != newRow {
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
            tableView.cellForRow(at: lastIndexPath as IndexPath)?.accessoryType = .none
            
            lastIndexPath = indexPath as NSIndexPath
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.section == 0 {
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
            
            switch indexPath.row {
            case 0:
                defaults.set("default", forKey: "noteColorTheme")
                setNewColorsForExistingNotesIfNotStatic()
                
            case 1:
                defaults.set("sunset", forKey: "noteColorTheme")
                setNewColorsForExistingNotesIfNotStatic()

            case 2:
                defaults.set("kypool", forKey: "noteColorTheme")
                setNewColorsForExistingNotesIfNotStatic()
                
            case 3:
                defaults.set("celestial", forKey: "noteColorTheme")
                setNewColorsForExistingNotesIfNotStatic()

            case 4:
                defaults.set("appleVibrant", forKey: "noteColorTheme")
                setNewColorsForExistingNotesIfNotStatic()

            default:
                print("Setting not implemented")
            }
        } else if indexPath.section == 1 {

        }
        
    }
    
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.accessoryType = .none
    }
    
    public override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 && UserDefaults.standard.bool(forKey: "useRandomColor") == false {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsCell", for: indexPath) as! SettingsCell
            
            cell.textLabel?.text = "\(palettes[indexPath.row])"
            cell.textLabel?.textColor = UIColor.black
            
            cell.isUserInteractionEnabled = false
            cell.selectionStyle = .none
            cell.backgroundColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.15)
            
            return cell
            
        } else if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsCell", for: indexPath) as! SettingsCell
            
            cell.textLabel?.text = "\(palettes[indexPath.row])"
            cell.backgroundColor = UIColor.white
            cell.isUserInteractionEnabled = true
            cell.selectionStyle = .none
            cell.textLabel?.textColor = UIColor.black
            
            switch indexPath.row {
            case 0:
                if isSelectedColorFromDefaults(key: "default", indexPath: indexPath) == true {
                    cell.accessoryType = .checkmark
                }
            case 1:
                if isSelectedColorFromDefaults(key: "sunset", indexPath: indexPath) == true {
                    cell.accessoryType = .checkmark
                }
            case 2:
                if isSelectedColorFromDefaults(key: "kypool", indexPath: indexPath) == true {
                    cell.accessoryType = .checkmark
                }
            case 3:
                if isSelectedColorFromDefaults(key: "celestial", indexPath: indexPath) == true {
                    cell.accessoryType = .checkmark
                }
            case 4:
                if isSelectedColorFromDefaults(key: "appleVibrant", indexPath: indexPath) == true {
                    cell.accessoryType = .checkmark
                }
            default:
                cell.accessoryType = .none
            }
            
            return cell
            
        }  else if indexPath.section == 1 {
            
            switch indexPath.row {
            case 0:
                let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsSwitchCell", for: indexPath) as! SettingsSwitchCell
                cell.textLabel?.text = "\(other[indexPath.row])"
                cell.selectionStyle = .none
                cell.switchButton.addTarget(self, action: #selector(randomColorSwitchPressed), for: .valueChanged)
                
                if UserDefaults.standard.bool(forKey: "useRandomColor") == true {
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
            
        } else {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsCell", for: indexPath) as! SettingsCell
            
            
            cell.backgroundColor = UIColor.white
            cell.textLabel?.textColor = UIColor.black
            return cell
        }
    }
    
    @objc func randomColorSwitchPressed(sender: UISwitch) {
        if sender.isOn {
            print("random colors enabled")
            UserDefaults.standard.set(true, forKey: "useRandomColor")
            setNewColorsForExistingNotes()
            tableView.reloadData()
            
        } else {
            print("random colors disabled")
            UserDefaults.standard.set(false, forKey: "useRandomColor")

            let colorPickerController = ColorPickerController()
            
            navigationController?.pushViewController(colorPickerController, animated: true)
            tableView.reloadData()
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
    
    func setNewColorsForExistingNotesIfNotStatic() {
        if UserDefaults.standard.bool(forKey: "useRandomColor") == true {
            setNewColorsForExistingNotes()
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
            let colorTheme = UserDefaults.standard.string(forKey: "noteColorTheme")
            
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
    
    func isSelectedColorFromDefaults(key: String, indexPath: IndexPath) -> Bool {
        let colorTheme = UserDefaults.standard.string(forKey: "noteColorTheme")
        if colorTheme == key {
            tableView.selectRow(at: indexPath, animated: false, scrollPosition: .bottom)
            return true
        } else {
            return false
        }
        
    }
    
    override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Pick the color theme for your saved notes. Each theme has at least 8 colors which will be selected at random when you open the app."
        case 1:
            return "By default Jotify uses random color generation for all of your saved notes. Turing this off will require you to select a new default color for all notes."
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
            return palettes.count
        case 1:
            return other.count
        default:
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
}
