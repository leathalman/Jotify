//
//  ReminderController.swift
//  Jotify
//
//  Created by Harrison Leath on 8/31/19.
//  Copyright © 2019 Harrison Leath. All rights reserved.
//

import AudioToolbox
import BottomPopup
import SPAlert
import UIKit
import UserNotifications

struct RemindersData {
    static var reminderDate = String()
    static var notificationUUID = String()
    static var isReminder = Bool()
}

class ReminderController: BottomPopupViewController, UNUserNotificationCenterDelegate {
    public var screenWidth: CGFloat {
        return UIScreen.main.bounds.width
    }
    
    public var screenHeight: CGFloat {
        return UIScreen.main.bounds.height
    }
    
    var notes: [Note] = []
    var filteredNotes: [Note] = []
    var isFiltering: Bool = false
    var index: Int = 0
    
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
        confirmButton.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -40).isActive = true
        confirmButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        confirmButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -40).isActive = true
    }
    
    func updateContentWithReminder(reminderDate: String, notificationUUID: String, reminderDateDisplay: String) {
        if isFiltering == false {
            notes[index].isReminder = true
            notes[index].reminderDate = reminderDate
            notes[index].notificationUUID = notificationUUID
            notes[index].reminderDateDisplay = reminderDateDisplay
            
        } else if isFiltering == true {
            filteredNotes[index].isReminder = true
            filteredNotes[index].reminderDate = reminderDate
            filteredNotes[index].notificationUUID = notificationUUID
            filteredNotes[index].reminderDateDisplay = reminderDateDisplay
        }
        
        CoreDataManager.shared.enqueue { context in
            do {
                try context.save()
                
            } catch let error as NSError {
                print("Could not save. \(error), \(error.userInfo)")
            }
        }
    }
    
    func setupDynamicColors() {
        if UserDefaults.standard.bool(forKey: "darkModeEnabled") == true {
            view.backgroundColor = .grayBackground
            datePicker.backgroundColor = .grayBackground
            let confirmButtonColor = UIColor.grayBackground.adjust(by: 4.75)
            confirmButton.backgroundColor = confirmButtonColor
            
        } else if UserDefaults.standard.bool(forKey: "darkModeEnabled") == false {
            view.backgroundColor = noteColor
            datePicker.backgroundColor = noteColor
            confirmButton.backgroundColor = noteColor.adjust(by: -7.75)
        }
    }
    
    @objc func setReminder(sender: UIButton) {
        feedbackOnPress()
        scheduleNotification()
        
        // add dark mode support too
        let alertView = SPAlertView(title: "Reminder Set", message: nil, preset: .done)
        alertView.duration = 1
        alertView.present()
        
        dismiss(animated: true, completion: nil)
    }
    
    func scheduleNotification() {
        // add category for custom buttons
        let center = UNUserNotificationCenter.current()
        
        let uuid = UUID().uuidString
        
        let content = UNMutableNotificationContent()
        content.body = reminderBodyText
        content.userInfo = ["reminderBodyText": reminderBodyText]
        content.sound = UNNotificationSound.default
        content.badge = UIApplication.shared.applicationIconBadgeNumber + 1 as NSNumber
        
        let componets = datePicker.calendar?.dateComponents([.year, .month, .day, .hour, .minute], from: datePicker.date)
        let trigger = UNCalendarNotificationTrigger(dateMatching: componets!, repeats: false)
        
        let request = UNNotificationRequest(identifier: uuid, content: content, trigger: trigger)
        center.add(request)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy hh:mm a"
        let dateFromPicker = dateFormatter.string(from: datePicker.date)
        
        let calendar = Calendar.current
        let formattedDate = calendar.date(from: componets!)
        
        dateFormatter.dateFormat = "MMMM d, yyyy"
        let firstPartOfDisplayString = dateFormatter.string(from: formattedDate!)
        
        dateFormatter.dateFormat = "h:mm a"
        let secondPartOfDisplayString = dateFormatter.string(from: formattedDate!)
        
        RemindersData.reminderDate = firstPartOfDisplayString + " at " + secondPartOfDisplayString
        
        let reminderDateString = firstPartOfDisplayString + " at " + secondPartOfDisplayString
        
        RemindersData.isReminder = true
        
        // set acutal note to isReminder true
        updateContentWithReminder(reminderDate: dateFromPicker, notificationUUID: uuid, reminderDateDisplay: reminderDateString)
    }
    
    func feedbackOnPress() {
        if UIDevice.current.hasTapticEngine == true {
            // iPhone 6s and iPhone 6s Plus
            let peek = SystemSoundID(1519)
            AudioServicesPlaySystemSoundWithCompletion(peek, nil)
            
        } else if UIDevice.current.hasHapticFeedback == true {
            // iPhone 7 and newer
            let generator = UIImpactFeedbackGenerator(style: .medium)
            generator.impactOccurred()
        }
    }
    
    override func getPopupHeight() -> CGFloat {
        return 80 + (screenHeight / 11) + datePicker.frame.height + 30
    }
}
