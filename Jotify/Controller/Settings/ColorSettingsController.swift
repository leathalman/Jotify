//
//  ColorSettingsController.swift
//  Jotify
//
//  Created by Harrison Leath on 7/7/19.
//  Copyright © 2019 Harrison Leath. All rights reserved.
//

import UIKit
import CoreData

class ColorSettingsController: UITableViewController {
    
    var notes: [Note] = []
    
    let sections: Array = ["Palettes"]
    let general: Array = ["Default", "Sunset", "Kypool", "Celestial"]
    
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchData()
        
        view.backgroundColor = UIColor.white
        
        navigationItem.title = "Note Color Themes"
        
        tableView.register(SettingsCell.self, forCellReuseIdentifier: "SettingsCell")
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        
        switch indexPath.row {
        case 0:
            defaults.set("default", forKey: "noteColorTheme")
            setNewColorsForExistingNotes()
            
        case 1:
            defaults.set("sunset", forKey: "noteColorTheme")
            setNewColorsForExistingNotes()

        case 2:
            defaults.set("kypool", forKey: "noteColorTheme")
            setNewColorsForExistingNotes()

        case 3:
            defaults.set("celestial", forKey: "noteColorTheme")
            setNewColorsForExistingNotes()

        default:
            print("Setting not implemented")
        }
    }
    
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.accessoryType = .none
    }
    
    public override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsCell", for: indexPath) as! SettingsCell
        
        cell.textLabel?.text = "\(general[indexPath.row])"
        cell.backgroundColor = UIColor.white
        cell.textLabel?.textColor = UIColor.black
        
        if indexPath.section == 0 {
            
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
            default:
                cell.accessoryType = .none
            }
            
            return cell
            
        } else if indexPath.section == 1 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsCell", for: indexPath) as! SettingsCell
            
            cell.textLabel?.text = "Dark Mode"
            
            return cell
            
        } else {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsCell", for: indexPath) as! SettingsCell
            
            
            cell.backgroundColor = UIColor.white
            cell.textLabel?.textColor = UIColor.black
            return cell
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
    
    func setNewColorsForExistingNotes() {
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        
        for note in notes {
            var newColor = String()
            let colorTheme = UserDefaults.standard.string(forKey: "noteColorTheme")
            
            if colorTheme == "default" {
                newColor = Colors.defaultColorsStrings.randomElement() ?? "white"
                
            } else if colorTheme == "sunset" {
                newColor = Colors.sunsetColorsStrings.randomElement() ?? "white"
                
            } else if colorTheme == "kypool" {
                newColor = Colors.kypoolColorsStrings.randomElement() ?? "white"
                
            } else if colorTheme == "celestial" {
                newColor = Colors.celestialColorsStrings.randomElement() ?? "white"
                
            }
            note.color = newColor
        }
        
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
    
    override func numberOfSections(in tableView: UITableView) -> Int{
        return sections.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section]
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return general.count
        } else {
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
}
