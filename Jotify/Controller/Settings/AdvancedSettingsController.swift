//
//  AdvancedSettingsController.swift
//  Jotify
//
//  Created by Harrison Leath on 7/7/21.
//

import UIKit

class AdvancedSettingsController: SettingsController {
        
    override func viewDidLoad() {
        super.viewDidLoad()
        super.sections = ["Advanced"]
        super.section1 = ["Reset Note Colors"]
        navigationItem.title = "Advanced"
    }
    
    //tableView logic
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch indexPath.row {
        case 0:
            for note in self.noteCollection!.FBNotes {
                DataManager.updateNoteColor(color: ColorManager.noteColor.getNewString(), uid: note.id) { success in }
                ColorManager.setNewNoteColor()
            }
            
            let alertController = UIAlertController(title: "Sucesss!", message: "The color of your notes has been reset.", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alertController, animated: true, completion: nil)
            
        default:
            print("")
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsCell", for: indexPath) as! SettingsCell
        cell.textLabel?.text = "\(super.section1[indexPath.row])"
        
        return cell
    }
}

