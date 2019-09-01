//
//  ReminderController.swift
//  Jotify
//
//  Created by Harrison Leath on 8/31/19.
//  Copyright © 2019 Harrison Leath. All rights reserved.
//

import UIKit

struct cellData {
    var opened = Bool()
    var title = String()
    var sectionData = [String]()
}

class ReminderController: UITableViewController, UNUserNotificationCenterDelegate {
    
    var tableViewData = [cellData]()
    
    var cellColor = UIColor()
    var content = String()
    
    var dateCellExpanded: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        
        tableViewData = [cellData(opened: false, title: "Set a reminder", sectionData: ["Cell1", "cell2", "Cell3"])]
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        navigationController?.navigationBar.tintColor = nil
    }
    
    func setupView() {
        title = "Reminders"
        
        tableView.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0)
        tableView.register(SettingsCell.self, forCellReuseIdentifier: "SettingsCell")
        tableView.separatorColor = cellColor
        
        view.backgroundColor = cellColor
        
        navigationItem.setHidesBackButton(true, animated:true)
        
        var cancel = UIImage(named: "cancel")
        cancel = cancel?.withRenderingMode(.alwaysOriginal)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: cancel, style:.plain, target: self, action: #selector(handleCancel))
        
        //        setupDatePicker()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            if tableViewData[indexPath.section].opened == true {
                tableViewData[indexPath.section].opened = false
                let sections = IndexSet.init(integer: indexPath.section)
                tableView.reloadSections(sections, with: .none)
            } else {
                tableViewData[indexPath.section].opened = true
                let sections = IndexSet.init(integer: indexPath.section)
                tableView.reloadSections(sections, with: .none)
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsCell") as! SettingsCell
            cell.textLabel?.text = tableViewData[indexPath.section].title
            cell.backgroundColor = cellColor.adjust(by: -3)
            cell.contentView.backgroundColor = cellColor.adjust(by: -3)
            cell.textLabel?.textColor = UIColor.white
//            enableDynamicArrow(cell: cell)
            
            return cell
            
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsCell") as! SettingsCell
            cell.textLabel?.text = tableViewData[indexPath.section].sectionData[indexPath.row - 1]
            cell.backgroundColor = cellColor.adjust(by: -3)
            cell.contentView.backgroundColor = cellColor.adjust(by: -3)
            cell.textLabel?.textColor = UIColor.white
            
            return cell
        }
    }
    
    func enableDynamicArrow(cell: UITableViewCell) {
        if UserDefaults.standard.bool(forKey: "darkModeEnabled") == true {
                cell.accessoryView = UIImageView(image: UIImage(systemName: "chevron.right.circle"))
                
            } else {
                cell.accessoryView = UIImageView(image: UIImage(systemName: "chevron.right.circle.fill"))
            }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return tableViewData.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableViewData[section].opened == true {
            return tableViewData[section].sectionData.count + 1
        } else {
            return 1
        }
    }
    
    func setupDatePicker() {
        let datePicker: UIDatePicker = UIDatePicker()
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        
        datePicker.timeZone = NSTimeZone.local
        datePicker.backgroundColor = cellColor
        datePicker.setValue(UIColor.white, forKeyPath: "textColor")
        
        // Add an event to call onDidChangeDate function when value is changed.
        datePicker.addTarget(self, action: #selector(self.datePickerValueChanged(_:)), for: .valueChanged)
        
        self.view.addSubview(datePicker)
        
        datePicker.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        datePicker.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: -90).isActive = true
        datePicker.widthAnchor.constraint(equalToConstant: self.view.frame.width).isActive = true
        datePicker.heightAnchor.constraint(equalToConstant: 200).isActive = true
    }
    
    @objc func datePickerValueChanged(_ sender: UIDatePicker){
        
        // Create date formatter
        let dateFormatter: DateFormatter = DateFormatter()
        
        // Set date format
        dateFormatter.dateFormat = "MM/dd/yyyy hh:mm a"
        
        // Apply date format
        let selectedDate: String = dateFormatter.string(from: sender.date)
        
        print("Selected value \(selectedDate)")
    }
    
    func registerLocal() {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            if granted {
                print("Authorized Notifications")
                self.scheduledLocal()
            } else {
                print("NOT Authorized Notifications")
            }
        }
    }
    
    func scheduledLocal() {
        registerCategories()
        
        let center = UNUserNotificationCenter.current()
        //        center.removeAllPendingNotificationRequests()
        
        let content = UNMutableNotificationContent()
        content.title = "Reminder"
        
        DispatchQueue.main.async {
            content.body = "\(content)"
            content.badge = UIApplication.shared.applicationIconBadgeNumber + 1 as NSNumber
        }
        
        content.categoryIdentifier = "reminder"
        content.userInfo = ["customData" : "stuff"]
        content.sound = .default
        
        var dateComponets = DateComponents()
        dateComponets.hour = 10
        dateComponets.minute = 30
        //        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponets, repeats: false)
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        center.add(request)
        print("Added notification")
        
        //        UIApplication.shared.applicationIconBadgeNumber = 0
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        
        if let customData = userInfo["customData"] as? String {
            print("Custom data received: \(customData)")
            
            switch response.actionIdentifier {
            case UNNotificationDefaultActionIdentifier:
                // the user swiped to unlock
                print("Default identifier")
                let pageController = PageViewController()
                pageController.scrollToPage(.at(index: 0), animated: true)
                
            case "show":
                // the user tapped our "show more info…" button
                print("Show more information…")
                let pageController = PageViewController()
                pageController.scrollToPage(.at(index: 0), animated: true)
                
            default:
                break
            }
        }
        
        completionHandler()
    }
    
    func registerCategories() {
        let center = UNUserNotificationCenter.current()
        center.delegate = self
        
        let show = UNNotificationAction(identifier: "show", title: "Tell me more...", options: .foreground)
        let category = UNNotificationCategory(identifier: "reminder", actions: [show], intentIdentifiers: [])
        
        center.setNotificationCategories([category])
    }
    
    @objc func handleCancel() {
        navigationController?.popViewController(animated: true)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
}
