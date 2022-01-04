//
//  ReminderController.swift
//  Jotify
//
//  Created by Harrison Leath on 7/10/21.
//

import UIKit
import UserNotifications

class ReminderController: UITableViewController, DatePickerDelegate, TimePickerDelegate {
    
    private var sections: [String] = ["Select Date And Time"]
    private var section1: [String] = ["Date", "Time"]
    
    //used to handle UI refreshing to the proper state
    private var isReminderOnDate: Bool = false
    private var isReminderOnTime: Bool = false
    
    //strings to be displayed by cells
    private var dateString: String?
    private var timeString: String?
    
    //actual date values to be used when creating notifications
    private var dateValue: Date?
    private var timeValue: Date?
    
    private var reminderExistsAtDate: Date?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //if reminder already exists, customize the view to dispaly existing reminder
        if EditingData.currentNote.reminderTimestamp ?? 0 > 1 {
            section1.insert("", at: 1)
            section1.insert("", at: 3)
            isReminderOnDate = true
            isReminderOnTime = true
            let tempDate = Date(timeIntervalSinceReferenceDate: EditingData.currentNote.reminderTimestamp ?? 0)
            dateString = formatDate(date: tempDate)
            timeString = formatTime(date: tempDate)
            
            reminderExistsAtDate = Date(timeIntervalSinceReferenceDate: EditingData.currentNote.reminderTimestamp ?? 0)
        } else {
            dateString = formatDate(date: Date())
            timeString = formatTime(date: Date())
        }
        
        view.backgroundColor = ColorManager.bgColor
        tableView.register(SettingsSwitchCell.self, forCellReuseIdentifier: "ReminderSwitchCell")
        tableView.register(DatePickerCell.self, forCellReuseIdentifier: "DatePickerCell")
        tableView.register(TimePickerCell.self, forCellReuseIdentifier: "TimePickerCell")
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if section1.count == 2 {
            switch indexPath.row {
            case 0:
                let cell = setupSwitchCells(indexPath: indexPath, isDatePicker: true) as! SettingsSwitchCell
                cell.switchButton.isOn = isReminderOnDate
                return cell
            case 1:
                let cell = setupSwitchCells(indexPath: indexPath, isDatePicker: false) as! SettingsSwitchCell
                cell.switchButton.isOn = isReminderOnTime
                return cell
            default:
                return setupSwitchCells(indexPath: indexPath, isDatePicker: true)
            }
        } else if section1.count == 3 {
            switch indexPath.row {
            case 0:
                let cell = setupSwitchCells(indexPath: indexPath, isDatePicker: true) as! SettingsSwitchCell
                cell.switchButton.isOn = isReminderOnDate
                return cell
            case 1:
                return setupDatePickerCells(indexPath: indexPath)
            case 2:
                let cell = setupSwitchCells(indexPath: indexPath, isDatePicker: false) as! SettingsSwitchCell
                cell.switchButton.isOn = isReminderOnTime
                return cell
            default:
                return setupSwitchCells(indexPath: indexPath, isDatePicker: true)
            }
        } else {
            switch indexPath.row {
            case 0:
                let cell = setupSwitchCells(indexPath: indexPath, isDatePicker: true) as! SettingsSwitchCell
                cell.switchButton.isOn = isReminderOnDate
                return cell
            case 1:
                return setupDatePickerCells(indexPath: indexPath)
            case 2:
                let cell = setupSwitchCells(indexPath: indexPath, isDatePicker: false) as! SettingsSwitchCell
                cell.switchButton.isOn = isReminderOnTime
                return cell
            case 3:
                return setupTimePickerCells(indexPath: indexPath)
            default:
                return setupSwitchCells(indexPath: indexPath, isDatePicker: true)
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return section1.count
        default:
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section]
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if section1.count == 2 {
            switch indexPath.row {
            case 0:
                return 60
            case 1:
                return 60
            default:
                return 0
            }
        } else if section1.count == 3 {
            switch indexPath.row {
            case 0:
                return 60
            case 1:
                return 325
            case 2:
                return 60
            case 3:
                return 0
            default:
                return 0
            }
        } else {
            switch indexPath.row {
            case 0:
                return 60
            case 1:
                return 325
            case 2:
                return 60
            case 3:
                return 250
            default:
                return 0
            }
        }
    }
    
    func createReminder() {
        // add category for custom buttons
        let center = UNUserNotificationCenter.current()
        
        if EditingData.currentNote.reminder != nil {
            center.removePendingNotificationRequests(withIdentifiers: [EditingData.currentNote.reminder!])
        }
        
        //need custom stuff here for UUID
        EditingData.currentNote.reminder = UUID().uuidString
        
        let content = UNMutableNotificationContent()
        content.body = EditingData.currentNote.content
        content.userInfo = ["noteID": EditingData.currentNote.id as Any, "color": EditingData.currentNote.color as Any, "timestamp": EditingData.currentNote.timestamp as Any, "content": EditingData.currentNote.content as Any]
        content.sound = UNNotificationSound.default
        content.categoryIdentifier = "NOTE_REMINDER"
        content.badge = UIApplication.shared.applicationIconBadgeNumber + 1 as NSNumber
        
        var components = DateComponents()
        components = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: dateValue ?? Date())
        
        if timeValue == nil {
            components.setValue(0, for: .hour)
            components.setValue(0, for: .minute)
        } else {
            components.setValue(Calendar.current.component(.hour, from: timeValue!), for: .hour)
            components.setValue(Calendar.current.component(.minute, from: timeValue!), for: .minute)
        }
        
        EditingData.currentNote.reminderTimestamp = Double(Calendar.current.date(from: components)!.timeIntervalSinceReferenceDate)

        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
        let request = UNNotificationRequest(identifier: EditingData.currentNote.reminder ?? "", content: content, trigger: trigger)
        center.add(request)
        
        //give Firebase UUID of reminder and timestamp
        DataManager.updateNoteReminder(reminder: EditingData.currentNote.reminder ?? "", reminderTimestamp: EditingData.currentNote.reminderTimestamp ?? 0, uid: EditingData.currentNote.id) { success in
            if !success! {
                print("There was an error creating the reminder")
            } else {
                print("Reminder was succesfully created and uploaded to backend")
            }
        }
    }
    
    //removes reminder and resets all relevant variables
    func removeReminder() {
        // add category for custom buttons
        let center = UNUserNotificationCenter.current()
        
        if EditingData.currentNote.reminderTimestamp ?? 0 > 0 {
            center.removePendingNotificationRequests(withIdentifiers: [EditingData.currentNote.reminder!])
            EditingData.currentNote.reminderTimestamp = 0
            EditingData.currentNote.reminder = ""
            dateValue = nil
            timeValue = nil
            dateString = nil
            timeString = nil
            print("Reminder removed from queue")
            
            //remove reminder from Firebase
            DataManager.removeReminder(uid: EditingData.currentNote.id) { success in
                if !success! {
                    print("There was an error deleting the reminder")
                } else {
                    print("Reminder was succesfully deleted and removed from backend")
                    UIApplication.shared.applicationIconBadgeNumber -= 1
                }
            }
        }
    }
    
    @objc func setDate(sender: UISwitch) {
        if sender.isOn {
            print("show date selector")
            isReminderOnDate = true
            //add item to array
            section1.insert("", at: 1)
            //insert item as row into tableview
            tableView.insertRows(at: [IndexPath(row: 1, section: 0)], with: .fade)
            //reload row above inserted row to account for detail text
            tableView.reloadRows(at: [IndexPath(row: 0, section: 0)], with: .none)
                        
        } else {
            print("hide date selector")
            //if both date and time are displayed
            if isReminderOnTime {
                section1.remove(at: 3)
                section1.remove(at: 1)
                tableView.deleteRows(at: [IndexPath(row: 1, section: 0), IndexPath(row: 3, section: 0)], with: .fade)
                let cell = tableView.cellForRow(at: IndexPath(row: 1, section: 0)) as! SettingsSwitchCell
                cell.switchButton.isOn = false
                cell.detailTextLabel?.text = nil
                //if only date is displayed
            } else {
                //remove item from array
                section1.remove(at: 1)
                //delete row from tableview
                tableView.deleteRows(at: [IndexPath(row: 1, section: 0)], with: .fade)
            }
            isReminderOnDate = false
            isReminderOnTime = false
            dateValue = nil
            timeValue = nil
            //reload row above inserted row to account for detail text
            tableView.reloadRows(at: [IndexPath(row: 0, section: 0)], with: .none)
            
            removeReminder()
        }
    }
    
    @objc func setTime(sender: UISwitch) {
        if sender.isOn {
            print("show time selector")
            isReminderOnDate = true
            isReminderOnTime = true
            if section1.count == 2 {
                let cell = tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as! SettingsSwitchCell
                cell.switchButton.isOn = true
                section1.insert("", at: 1)
                section1.insert("", at: 3)
                tableView.insertRows(at: [IndexPath(row: 1, section: 0), IndexPath(row: 3, section: 0)], with: .fade)
                tableView.reloadRows(at: [IndexPath(row: 2, section: 0), IndexPath(row: 0, section: 0)], with: .none)
            } else {
                section1.insert("", at: 3)
                tableView.insertRows(at: [IndexPath(row: 3, section: 0)], with: .fade)
            }
            
            tableView.reloadRows(at: [IndexPath(row: 2, section: 0)], with: .none)
            
        } else {
            print("hide time selector")
            section1.remove(at: 3)
            tableView.deleteRows(at: [IndexPath(row: 3, section: 0)], with: .fade)
            if section1.count != 3 {
                let cell = tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as! SettingsSwitchCell
                cell.switchButton.isOn = false
            }
            isReminderOnTime = false
            tableView.reloadRows(at: [IndexPath(row: 2, section: 0)], with: .none)
            dateValue = nil
            timeValue = nil
        }
    }
    
    func setupSwitchCells(indexPath: IndexPath, isDatePicker: Bool) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReminderSwitchCell", for: indexPath) as! SettingsSwitchCell
        cell.selectionStyle = .none
        cell.textLabel?.text = section1[indexPath.row]
        cell.detailTextLabel?.textColor = .systemBlue
        
        if isDatePicker {
            cell.switchButton.addTarget(self, action: #selector(setDate(sender:)), for: .valueChanged)
            if isReminderOnDate {
                cell.detailTextLabel?.text = dateString
            } else {
                cell.detailTextLabel?.text = nil
            }
        } else {
            cell.switchButton.addTarget(self, action: #selector(setTime(sender:)), for: .valueChanged)
            if isReminderOnTime {
                cell.detailTextLabel?.text = timeString
            } else {
                cell.detailTextLabel?.text = nil
            }
        }
        
        return cell
    }
    
    func setupDatePickerCells(indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DatePickerCell", for: indexPath) as! DatePickerCell
        cell.selectionStyle = .none
        cell.textLabel?.text = section1[indexPath.row]
        cell.delegate = self
        
        if reminderExistsAtDate != nil {
            cell.picker.date = reminderExistsAtDate ?? Date()
        }
        
        return cell
    }
    
    func setupTimePickerCells(indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TimePickerCell", for: indexPath) as! TimePickerCell
        cell.selectionStyle = .none
        cell.textLabel?.text = section1[indexPath.row]
        cell.delegate = self
        
        if reminderExistsAtDate != nil {
            cell.picker.date = reminderExistsAtDate ?? Date()
        }
        return cell
    }
    
    func didChangeDate(date: Date) {
        dateString = formatDate(date: date)
        dateValue = date
        tableView.reloadRows(at: [IndexPath(row: 0, section: 0)], with: .none)
        
        createReminder()
    }
    
    func didChangeTime(date: Date) {
        timeString = formatTime(date: date)
        timeValue = date
        tableView.reloadRows(at: [IndexPath(row: 2, section: 0)], with: .none)
        
        createReminder()
    }
    
    func formatDate(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .full
        formatter.timeZone = .current
        return formatter.string(from: date)
    }
    
    func formatTime(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "h:mm a"
        formatter.amSymbol = "AM"
        formatter.pmSymbol = "PM"
        return formatter.string(from: date)
    }
    
    //needed to make sure badge increments correctly
    //called from SceneDelegate
    func renumberBadgesOfPendingNotifications() {
        // once reminders are delivered it will override the badge number
        // so it will increment correctly as long as the notifications have been delivered
        // but a new reminder scheduled after the others have been delivered will still be badge = 1
        UNUserNotificationCenter.current().getPendingNotificationRequests { pendingNotificationRequests in
            if pendingNotificationRequests.count > 0 {
                let notificationRequests = pendingNotificationRequests
                    .filter { $0.trigger is UNCalendarNotificationTrigger }
                    .sorted(by: { (r1, r2) -> Bool in
                        let r1Trigger = r1.trigger as! UNCalendarNotificationTrigger
                        let r2Trigger = r2.trigger as! UNCalendarNotificationTrigger
                        let r1Date = r1Trigger.nextTriggerDate()!
                        let r2Date = r2Trigger.nextTriggerDate()!
                        
                        return r1Date.compare(r2Date) == .orderedAscending
                    })
                
                let identifiers = notificationRequests.map { $0.identifier }
                UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: identifiers)
                
                notificationRequests.enumerated().forEach { index, request in
                    if let trigger = request.trigger {
                        let content = UNMutableNotificationContent()
                        content.body = request.content.body
                        content.sound = .default
                        content.badge = (index + 1) as NSNumber
                        
                        let request = UNNotificationRequest(identifier: request.identifier, content: content, trigger: trigger)
                        UNUserNotificationCenter.current().add(request)
                    }
                }
            }
        }
    }
}
