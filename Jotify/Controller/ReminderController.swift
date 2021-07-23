//
//  ReminderController.swift
//  Jotify
//
//  Created by Harrison Leath on 7/10/21.
//

import UIKit

class ReminderController: UITableViewController, DatePickerDelegate, TimePickerDelegate {
    
    var sections: [String] = ["Select Date And Time"]
    var section1: [String] = ["Date", "Time"]
    
    var isReminderOnDate: Bool = false
    var isReminderOnTime: Bool = false
    
    var dateValue: String?
    var timeValue: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dateValue = formatDate(date: Date())
        timeValue = formatTime(date: Date())
        
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
    
    @objc func setDate(sender: UISwitch) {
        if sender.isOn {
            print("show date selector")
            isReminderOnDate = true
            section1.insert("", at: 1)
            tableView.insertRows(at: [IndexPath(row: 1, section: 0)], with: .automatic)
            tableView.reloadRows(at: [IndexPath(row: 0, section: 0)], with: .none)
            
        } else {
            print("hide date selector")
            if isReminderOnTime {
                section1.remove(at: 3)
                section1.remove(at: 1)
                tableView.deleteRows(at: [IndexPath(row: 1, section: 0), IndexPath(row: 3, section: 0)], with: .automatic)
                let cell = tableView.cellForRow(at: IndexPath(row: 1, section: 0)) as! SettingsSwitchCell
                cell.switchButton.isOn = false
                cell.detailTextLabel?.text = nil
            } else {
                section1.remove(at: 1)
                tableView.deleteRows(at: [IndexPath(row: 1, section: 0)], with: .automatic)
            }
            isReminderOnDate = false
            isReminderOnTime = false
            tableView.reloadRows(at: [IndexPath(row: 0, section: 0)], with: .none)
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
                tableView.insertRows(at: [IndexPath(row: 1, section: 0), IndexPath(row: 3, section: 0)], with: .automatic)
                tableView.reloadRows(at: [IndexPath(row: 0, section: 0), IndexPath(row: 2, section: 0)], with: .none)
            } else {
                section1.insert("", at: 3)
                tableView.insertRows(at: [IndexPath(row: 3, section: 0)], with: .automatic)
                tableView.reloadRows(at: [IndexPath(row: 2, section: 0)], with: .none)
            }
            
        } else {
            print("hide time selector")
            isReminderOnTime = false
            section1.remove(at: 3)
            tableView.deleteRows(at: [IndexPath(row: 3, section: 0)], with: .automatic)
            if section1.count != 3 {
                let cell = tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as! SettingsSwitchCell
                cell.switchButton.isOn = false
            }
            tableView.reloadRows(at: [IndexPath(row: 2, section: 0)], with: .none)
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
                cell.detailTextLabel?.text = dateValue
            } else {
                cell.detailTextLabel?.text = nil
            }
        } else {
            cell.switchButton.addTarget(self, action: #selector(setTime(sender:)), for: .valueChanged)
            if isReminderOnTime {
                cell.detailTextLabel?.text = timeValue
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
        return cell
    }
    
    func setupTimePickerCells(indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TimePickerCell", for: indexPath) as! TimePickerCell
        cell.selectionStyle = .none
        cell.textLabel?.text = section1[indexPath.row]
        cell.delegate = self
        return cell
    }
    
    func didChangeDate(date: Date) {
        dateValue = formatDate(date: date)
        tableView.reloadRows(at: [IndexPath(row: 0, section: 0)], with: .none)
    }
    
    func didChangeTime(date: Date) {
        timeValue = formatTime(date: date)
        tableView.reloadRows(at: [IndexPath(row: 2, section: 0)], with: .none)
    }
    
    func formatDate(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
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
}
