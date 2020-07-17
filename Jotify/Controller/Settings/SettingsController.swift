//
//  SettingsController.swift
//  Sticky Notes
//
//  Created by Harrison Leath on 5/12/19.
//  Copyright © 2019 Harrison Leath. All rights reserved.
//

import CoreData
import UIKit

class SettingsController: UITableViewController {
    let sections: Array = ["General", "Advanced"]
    let general: Array = ["About", "Appearance", "Privacy", "Alerts"]
    let advanced1: Array = ["Get Premium", "Restore Purchases", "Show Tutorial", "Reset Settings to Default", "Delete All Data"]
    let advanced2: Array = ["Restore Purchases", "Show Tutorial", "Reset Settings to Default", "Delete All Data"]
    
    let defaults = UserDefaults.standard
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)

        setupDynamicViewElements()
        removeExtraHeaderView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.contentInset = .zero
        
        tableView.isUserInteractionEnabled = true
        tableView.isScrollEnabled = true
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "disableSwipe"), object: nil)
        
        navigationItem.title = "Settings"
        
        UIApplication.shared.windows.first?.backgroundColor = UIColor.grayBackground
        
        tableView.register(SettingsCell.self, forCellReuseIdentifier: "SettingsCell")
        tableView.register(SettingsSwitchCell.self, forCellReuseIdentifier: "SettingsSwitchCell")
    }
    
    func setupDynamicViewElements() {
        Themes().setupPersistentNavigationBar(navController: navigationController ?? UINavigationController())
        
        if darkModeEnabled() {
            if UserDefaults.standard.bool(forKey: "vibrantDarkModeEnabled") {
                Themes().setupVibrantDarkMode()
                view.backgroundColor = InterfaceColors.viewBackgroundColor
                tableView.separatorColor = InterfaceColors.separatorColor
                tableView.reloadData()
                
            } else if UserDefaults.standard.bool(forKey: "pureDarkModeEnabled") {
                Themes().setupPureDarkMode()
                view.backgroundColor = InterfaceColors.viewBackgroundColor
                tableView.separatorColor = InterfaceColors.separatorColor
                tableView.reloadData()
            }
            
        } else {
            view.backgroundColor = InterfaceColors.viewBackgroundColor
            tableView.separatorColor = nil
            Themes().setupDefaultMode()
            tableView.reloadData()
            ()
        }
    }
    
    func removeExtraHeaderView() {
        var frame = CGRect.zero
        frame.size.height = .leastNormalMagnitude
        tableView.tableHeaderView = UIView(frame: frame)
    }
    
    func deleteAllNotes(entity: String) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        CoreDataManager.shared.enqueue { context in
            do {
                try context.execute(batchDeleteRequest)
                try context.save()
                
            } catch let error as NSError {
                print("Could not save. \(error), \(error.userInfo)")
            }
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
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
                navigationController?.pushViewController(AlertSettingsController(style: .insetGrouped), animated: true)
            default:
                return
            }
            
        } else if indexPath.section == 1 {
            
            if defaults.bool(forKey: "com.austinleath.Jotify.Premium") {
                switch indexPath.row {
                case 0:
                    let cell = tableView.cellForRow(at: indexPath)
                    cell?.isSelected = false
                    
                    notifyUserOfRestore()
                    ReceiptHandler().handleReceiptValidation()
                    JotifyProducts.store.restorePurchases()
                case 1:
                    let writeNoteController = WriteNoteController()
                    writeNoteController.presentFirstLaunchOnboarding(viewController: self, tintColor: StoredColors.noteColor)
                    
                    let cell = tableView.cellForRow(at: indexPath)
                    cell?.isSelected = false
                    
                case 2:
                    let alert = UIAlertController(title: "Are you sure?", message: "This will reset all settings to default.", preferredStyle: .alert)
                    
                    let cell = tableView.cellForRow(at: indexPath)
                    cell?.isSelected = false
                    
                    alert.addAction(UIAlertAction(title: "Reset", style: .destructive, handler: { _ in
                        
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
                        self.defaults.set(false, forKey: "useMultilineInput")
                    }))
                    
                    alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                    present(alert, animated: true)
                    
                case 3:
                    print("Delete all data")
                    let cell = tableView.cellForRow(at: indexPath)
                    cell?.isSelected = false
                    
                    let alert = UIAlertController(title: "Are you sure?", message: "This will permanently delete all data saved in both iCloud and saved locally on this device.", preferredStyle: .alert)
                    
                    alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { _ in
                        self.deleteAllNotes(entity: "Note")
                    }))
                    
                    alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                    present(alert, animated: true)
                    
                default:
                    print("default")
                }
            } else {
                switch indexPath.row {
                case 0:
                    let cell = tableView.cellForRow(at: indexPath)
                    cell?.isSelected = false
                    
                    PremiumView.shared.presentPremiumView(viewController: self)
                case 1:
                    let cell = tableView.cellForRow(at: indexPath)
                    cell?.isSelected = false
                    
                    notifyUserOfRestore()
                    ReceiptHandler().handleReceiptValidation()
                    JotifyProducts.store.restorePurchases()
                case 2:
                    let writeNoteController = WriteNoteController()
                    writeNoteController.presentFirstLaunchOnboarding(viewController: self, tintColor: StoredColors.noteColor)
                    
                    let cell = tableView.cellForRow(at: indexPath)
                    cell?.isSelected = false
                    
                case 3:
                    let alert = UIAlertController(title: "Are you sure?", message: "This will reset all settings to default.", preferredStyle: .alert)
                    
                    let cell = tableView.cellForRow(at: indexPath)
                    cell?.isSelected = false
                    
                    alert.addAction(UIAlertAction(title: "Reset", style: .destructive, handler: { _ in
                        
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
                        self.defaults.set(false, forKey: "useMultilineInput")
                    }))
                    
                    alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                    present(alert, animated: true)
                    
                case 4:
                    print("Delete all data")
                    let cell = tableView.cellForRow(at: indexPath)
                    cell?.isSelected = false
                    
                    let alert = UIAlertController(title: "Are you sure?", message: "This will permanently delete all data saved in both iCloud and saved locally on this device.", preferredStyle: .alert)
                    
                    alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { _ in
                        self.deleteAllNotes(entity: "Note")
                    }))
                    
                    alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                    present(alert, animated: true)
                    
                default:
                    print("default")
                }
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return general.count
        } else if section == 1 {
            if defaults.bool(forKey: "com.austinleath.Jotify.Premium") {
                return advanced2.count
            } else {
                return advanced1.count
            }
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
                cell.accessoryType = .disclosureIndicator
                
                setupDynamicCells(cell: cell, enableArrow: true)
                
                return cell
                
            case 1, 2, 3:
                let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsCell", for: indexPath) as! SettingsCell
                cell.textLabel?.text = "\(general[indexPath.row])"
                cell.accessoryType = .disclosureIndicator
                
                setupDynamicCells(cell: cell, enableArrow: true)
                
                return cell
                
            default:
                let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsCell", for: indexPath) as! SettingsCell
                cell.textLabel?.text = "\(general[indexPath.row])"
                cell.accessoryType = .disclosureIndicator
                
                setupDynamicCells(cell: cell, enableArrow: true)
                
                return cell
            }
            
        } else if indexPath.section == 1 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsCell", for: indexPath) as! SettingsCell
            
            if defaults.bool(forKey: "com.austinleath.Jotify.Premium") {
                cell.textLabel?.text = "\(advanced2[indexPath.row])"
            } else {
                cell.textLabel?.text = "\(advanced1[indexPath.row])"
            }
            
            if defaults.bool(forKey: "com.austinleath.Jotify.Premium") {
                switch indexPath.row {
                case 0, 1, 2:
                    cell.backgroundColor = UIColor.white
                    cell.backgroundColor = InterfaceColors.cellColor
                    cell.textLabel?.textColor = UIColor.lightBlue
                    setupHighlightCorrection(cell: cell)
                case 3:
                    cell.backgroundColor = UIColor.white
                    cell.backgroundColor = InterfaceColors.cellColor
                    cell.textLabel?.textColor = UIColor.red
                    setupHighlightCorrection(cell: cell)
                default:
                    return cell
                }
                
            } else {
                switch indexPath.row {
                case 0, 1, 2, 3:
                    cell.backgroundColor = UIColor.white
                    cell.backgroundColor = InterfaceColors.cellColor
                    cell.textLabel?.textColor = UIColor.lightBlue
                    setupHighlightCorrection(cell: cell)
                case 4:
                    cell.backgroundColor = UIColor.white
                    cell.backgroundColor = InterfaceColors.cellColor
                    cell.textLabel?.textColor = UIColor.red
                    setupHighlightCorrection(cell: cell)
                default:
                    return cell
                }
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
        
        setupHighlightCorrection(cell: cell)
        
        if enableArrow {
            if darkModeEnabled() {
                cell.accessoryView = UIImageView(image: UIImage(systemName: "chevron.right.circle"))
                
            } else {
                cell.accessoryView = UIImageView(image: UIImage(systemName: "chevron.right.circle.fill"))
            }
        }
    }
    
    func setupHighlightCorrection(cell: UITableViewCell) {
        if !defaults.bool(forKey: "useSystemMode") && !defaults.bool(forKey: "darkModeEnabled") {
            let backgroundView = UIView()
            backgroundView.backgroundColor = UIColor.cellHighlightDefault
            cell.selectedBackgroundView = backgroundView
            
        } else if !defaults.bool(forKey: "useSystemMode") && defaults.bool(forKey: "darkModeEnabled") {
            let backgroundView = UIView()
            backgroundView.backgroundColor = UIColor.cellHighlightDark
            cell.selectedBackgroundView = backgroundView
            
        } else {
            cell.selectedBackgroundView = nil
        }
    }
    
    func notifyUserOfRestore() {
        // setups observer for IAPHandler
        NotificationCenter.default.addObserver(self, selector: #selector(self.handleIAPNotification(notification:)), name: .IAPHelperPurchaseNotification, object: nil)
    }
    
    @objc func handleIAPNotification(notification: Notification) {
        // will not account for receipt validator
        
        print(notification)
        
        if notification.object as! String == "com.austinleath.Jotify.Premium" || notification.object as! String == "com.austinleath.Jotify.premium" {
            // if purchased
            let alert = UIAlertController(title: "Congratulations!", message: "You successfully restored your purchase! Enjoy Jotify premium!", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Yay!", style: .cancel, handler: { _ in
                
            }))
            present(alert, animated: true)
            self.tableView.reloadData()
            
        } else {
            // if not purchased
            // TODO: make sure this correctly triggers
            let alert = UIAlertController(title: "Not quite.", message: "It looks like you have not bought premium yet. Please consider supporting Jotify!", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { _ in
                
            }))
            present(alert, animated: true)
        }
    }

    func showIAPAlert() {
        
    }
    
    func darkModeEnabled() -> Bool {
        return defaults.bool(forKey: "darkModeEnabled")
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {       
        Themes().triggerSystemMode(mode: traitCollection)
        setupDynamicViewElements()
        tableView.reloadData()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return Themes().setStatusBar(traitCollection: traitCollection)
    }
}
