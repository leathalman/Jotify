//
//  ReminderController.swift
//  Jotify
//
//  Created by Harrison Leath on 8/31/19.
//  Copyright © 2019 Harrison Leath. All rights reserved.
//

import UIKit
import UserNotifications
import BottomPopup

struct RemindersData {
    static var isReminder = Bool()
    static var reminderDate = String()
}

class ReminderController: BottomPopupViewController, UNUserNotificationCenterDelegate {
    
    public var screenWidth: CGFloat {
        return UIScreen.main.bounds.width
    }
    
    public var screenHeight: CGFloat {
        return UIScreen.main.bounds.height
    }
    
    var noteColor = StoredColors.reminderColor
    var reminderBodyText = String()
    
    let datePicker: UIDatePicker = UIDatePicker()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Set a reminder:"
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 40)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    lazy var confirmButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.setTitle("Confirm", for: .normal)
        button.addTarget(self, action: #selector(setReminder(sender:)), for: .touchUpInside)
        button.backgroundColor = UIColor.black
        button.layer.cornerRadius = 5
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    func setupView() {
        title = "Set a reminder"
        
        setupDynamicColors()
        
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        datePicker.timeZone = NSTimeZone.local
        datePicker.setValue(UIColor.white, forKeyPath: "textColor")
        
        view.addSubview(titleLabel)
        view.addSubview(datePicker)
        view.addSubview(confirmButton)
        
        titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 25).isActive = true
        
        datePicker.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        datePicker.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 2).isActive = true
        datePicker.widthAnchor.constraint(equalToConstant: view.frame.width).isActive = true
        datePicker.heightAnchor.constraint(equalToConstant: 200).isActive = true
        
        confirmButton.heightAnchor.constraint(equalToConstant: screenHeight / 11).isActive = true
        confirmButton.widthAnchor.constraint(equalToConstant: screenWidth - 30).isActive = true
        confirmButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        confirmButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20).isActive = true
    }
    
    func setupDynamicColors () {
        if UserDefaults.standard.bool(forKey: "darkModeEnabled") == true {
            view.backgroundColor = .grayBackground
            datePicker.backgroundColor = .grayBackground
            let confirmButtonColor = UIColor.grayBackground.adjust(by: 3.75)
            confirmButton.backgroundColor = confirmButtonColor
            
        } else if UserDefaults.standard.bool(forKey: "darkModeEnabled") == false {
            view.backgroundColor = noteColor
            datePicker.backgroundColor = noteColor
            confirmButton.backgroundColor = noteColor.adjust(by: -3.75)
        }
    }
    
    @objc func setReminder(sender: UIButton) {
        //display animation that confirms it worked
        scheduleNotification()
        dismiss(animated: true, completion: nil)
    }
    
    func scheduleNotification() {
        //add category for custom buttons
        let center = UNUserNotificationCenter.current()
        
        let content = UNMutableNotificationContent()
        content.body = reminderBodyText
        content.categoryIdentifier = "reminder"
        content.userInfo = ["customData": "placeholder"]
        content.sound = UNNotificationSound.default
        
        let componets = datePicker.calendar?.dateComponents([.day, .hour, .minute], from: datePicker.date)
        let trigger = UNCalendarNotificationTrigger(dateMatching: componets!, repeats: false)
        
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        center.add(request)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy hh:mm a"
        let selectedDate = dateFormatter.string(from: datePicker.date)
        
        RemindersData.isReminder = true
        RemindersData.reminderDate = selectedDate
    }
    
    override func getPopupHeight() -> CGFloat {
        return 80 + (screenHeight / 11) + datePicker.frame.height
    }
    
}
