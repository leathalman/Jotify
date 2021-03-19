//
//  Appearance.swift
//  Jotify
//
//  Created by Harrison Leath on 2/6/21.
//

import UIKit

class AppearanceSettingsController: SettingsController {
    
    var lastIndexPath: NSIndexPath = NSIndexPath(row: 0, section: 0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        super.sections = ["Themes"]
        super.section1 = ["Default", "Kypool"]
        navigationItem.title = "Appearance"
    }
    
    //tableView logic
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let newRow = indexPath.row
        let oldRow = lastIndexPath.row
        
        //remove checkmark on last selected cell at lastIndexPath
        //add checkmark to selected cell
        if oldRow != newRow {
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
            tableView.cellForRow(at: lastIndexPath as IndexPath)?.accessoryType = .none
            //update lastIndexPath to selected cell
            lastIndexPath = indexPath as NSIndexPath
        }
        
        DataManager.updateUserSettings(setting: "theme", value: section1[indexPath.row]) { (success) in
            if success! {
                User.retrieveSettingsFromFirebase()
                UserDefaults.standard.setValue(self.section1[indexPath.row], forKey: "theme")
                ColorManager.setNoteColor(theme: self.section1[indexPath.row].getColorArray())
            }
        }
                
        //empty index array since not all color themes have the same number of colors
        //prevents outOfBounds error
        ColorManager.indexes.removeAll()
        //update mostRecentColor variable with new themne
        ColorManager.setNoteColor(theme: ColorManager.theme)
        AnalyticsManager.logEvent(named: "theme_changed", description: "theme_changed")
        
        //ask user if they want to recolor all of their notes
        changeColorOfExistingNotes(theme: section1[indexPath.row])
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsCell", for: indexPath) as! SettingsCell
        
        cell.textLabel?.text = "\(super.section1[indexPath.row])"
        cell.selectionStyle = .none
        
        if User.settings?.theme == section1[indexPath.row] {
            cell.accessoryType = .checkmark
            lastIndexPath = indexPath as NSIndexPath
        }
        
        return cell
    }
    
    func changeColorOfExistingNotes(theme: String) {
        let alertController = UIAlertController(title: "Theme Changed", message: "Would you like to recolor your existing notes too?", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action) in
            for note in self.noteCollection!.FBNotes {
                DataManager.updateNoteColor(color: ColorManager.setNoteColor(theme: theme.getColorArray()).getString(), uid: note.id) { (success) in }
            }
        }))
        alertController.addAction(UIAlertAction(title: "No", style: .default, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
}
