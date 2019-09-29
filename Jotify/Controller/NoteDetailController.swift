//
//  NoteDetailController.swift
//  Jotify
//
//  Created by Harrison Leath on 6/24/19.
//  Copyright © 2019 Harrison Leath. All rights reserved.
//

import UIKit
import UserNotifications

class NoteDetailController: UIViewController, UITextViewDelegate {
    
    var navigationTitle: String = ""
    var backgroundColor: UIColor = .white
    var detailText: String = ""
    var index: Int = 0
    
    let newDate = Date.timeIntervalSinceReferenceDate
    
    var datePicker: UIDatePicker = UIDatePicker()
    let toolBar = UIToolbar()
    
    let writeNoteView = WriteNoteView()
    
    let defaults = UserDefaults.standard
    
    var notes: [Note] = []
    var filteredNotes: [Note] = []
    var isFiltering: Bool = false
    
    var navigationBarHeight = CGFloat()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupPersistentNavigationBar()
        removeReminderIfDelivered()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        resetRemindersData()
        setupNotifications()
        setupView()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        updateContent(index: index, newContent: writeNoteView.inputTextView.text, newDate: newDate, isReminder: RemindersData.isReminder, notificationUUID: RemindersData.notificationUUID, reminderDate: RemindersData.reminderDate)
        
        resetNavigationBarForTransition()
    }
    
    func resetRemindersData() {
        if isFiltering == false {
            if notes[index].isReminder == true {
                RemindersData.isReminder = true
            }
            
        } else if isFiltering == true {
            if filteredNotes[index].isReminder == true {
                RemindersData.isReminder = true
            }
        }
        
        RemindersData.notificationUUID = ""
    }
    
    func removeReminderIfDelivered() {
        if checkIfReminderHasBeenDelivered() == true {
            updateContent(index: index, newContent: writeNoteView.inputTextView.text, newDate: newDate, isReminder: false, notificationUUID: "", reminderDate: "")
            UIApplication.shared.applicationIconBadgeNumber -= 1
        }
    }
    
    func checkIfReminderHasBeenDelivered() -> Bool {
        
        if isFiltering == false {
            
            let isReminder = notes[index].isReminder
            
            if isReminder == true {
                let reminderDate = notes[index].reminderDate ?? "07/02/2000 11:11 PM"
                
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "MM/dd/yyyy hh:mm a"
                let formattedReminderDate = dateFormatter.date(from: reminderDate) ?? Date()
                
                let currentDate = Date()
                
                if currentDate > formattedReminderDate {
                    return true
                } else {
                    return false
                }
            }
            
        } else if isFiltering == true {
            
            let isReminder = filteredNotes[index].isReminder
            
            if isReminder == true {
                let reminderDate = filteredNotes[index].reminderDate ?? "07/02/2000 11:11 PM"

                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "MM/dd/yyyy hh:mm a"
                let formattedReminderDate = dateFormatter.date(from: reminderDate) ?? Date()
                
                let currentDate = Date()
                
                if currentDate + 10 > formattedReminderDate {
                    return true
                } else {
                    return false
                }
            }
        }
        
        return false
    }
    
    func setupPersistentNavigationBar() {
        guard self.navigationController?.topViewController === self else { return }
        self.transitionCoordinator?.animate(alongsideTransition: { [weak self](context) in
            self?.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
            self?.navigationController?.navigationBar.shadowImage = UIImage()
            self?.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
            self?.navigationController?.navigationBar.barStyle = .black
            
            if self?.defaults.bool(forKey: "darkModeEnabled") == true {
                if self?.defaults.bool(forKey: "vibrantDarkModeEnabled") == true {
                    self?.navigationController?.navigationBar.backgroundColor = self?.backgroundColor
                    self?.navigationController?.navigationBar.barTintColor = self?.backgroundColor
                    
                } else if self?.defaults.bool(forKey: "pureDarkModeEnabled") == true {
                    self?.navigationController?.navigationBar.backgroundColor = InterfaceColors.viewBackgroundColor
                    self?.navigationController?.navigationBar.barTintColor = InterfaceColors.viewBackgroundColor
                }
                
            } else if self?.defaults.bool(forKey: "darkModeEnabled") == false {
                self?.navigationController?.navigationBar.backgroundColor = self?.backgroundColor
                self?.navigationController?.navigationBar.barTintColor = self?.backgroundColor
            }
            }, completion: nil)
    }
    
    func resetNavigationBarForTransition() {
        self.transitionCoordinator?.animate(alongsideTransition: { [weak self](context) in
            self?.navigationController?.navigationBar.setBackgroundImage(nil, for: UIBarMetrics.default)
            self?.navigationController?.navigationBar.backgroundColor = .white
            self?.navigationController?.navigationBar.barTintColor = .white
            self?.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
            }, completion: nil)
    }
    
    func setupView() {
        view = writeNoteView
        let textView = writeNoteView.inputTextView
        
        if defaults.bool(forKey: "darkModeEnabled") == true {
            
            if defaults.bool(forKey: "vibrantDarkModeEnabled") == true {
                writeNoteView.colorView.backgroundColor = backgroundColor
                textView.backgroundColor = backgroundColor
            } else if defaults.bool(forKey: "pureDarkModeEnabled") == true {
                writeNoteView.colorView.backgroundColor = InterfaceColors.viewBackgroundColor
                textView.backgroundColor = InterfaceColors.viewBackgroundColor
            }
            
        } else if defaults.bool(forKey: "darkModeEnabled") == false {
            writeNoteView.colorView.backgroundColor = backgroundColor
            textView.backgroundColor = backgroundColor
        }
        
        textView.tintColor = .white
        navigationBarHeight = navigationController?.navigationBar.bounds.height ?? 0
        print(navigationBarHeight)
        textView.frame = CGRect(x: 0, y: 15, width: writeNoteView.screenWidth, height: writeNoteView.screenHeight - navigationBarHeight - 30)
        textView.text = detailText
        textView.font = UIFont.boldSystemFont(ofSize: 18)
        textView.placeholder = ""
        
        textView.alwaysBounceVertical = true
        textView.isUserInteractionEnabled = true
        textView.isScrollEnabled = true
        textView.isPlaceholderScrollEnabled = true
        
        navigationItem.title = navigationTitle
        navigationItem.setHidesBackButton(true, animated:true)
        
        var cancel = UIImage(named: "cancel")
        cancel = cancel?.withRenderingMode(.alwaysOriginal)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: cancel, style:.plain, target: self, action: #selector(handleCancel))
        
        if RemindersData.isReminder == true {
            setNavBarIfReminderIsActive()
        } else {
            setNavBarIfReminderIsNotActive()
        }
        
        self.hideKeyboardWhenTappedAround()
    }
    
    func setNavBarIfReminderIsActive() {
        var alarm = UIImage(named: "alarm.fill")
        alarm = alarm?.withRenderingMode(.alwaysOriginal)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: alarm, style: .plain, target: self, action: #selector(handleReminder))
    }
    
    func setNavBarIfReminderIsNotActive() {
        var alarm = UIImage(named: "alarm")
        alarm = alarm?.withRenderingMode(.alwaysOriginal)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: alarm, style: .plain, target: self, action: #selector(handleReminder))
    }
    
    @objc func handleReminder() {
        if RemindersData.isReminder == true {
            //do something if a reminder is already set
            // present secondary vc that displays time reminder is set, and offers to cancel it
            print("Already set a reminder")
            let uuid = notes[index].value(forKey: "notificationUUID") as! String
            
            let center = UNUserNotificationCenter.current()
            center.removeDeliveredNotifications(withIdentifiers: [uuid])
            center.removePendingNotificationRequests(withIdentifiers: [uuid])
            
        } else {
            //present controller to set a reminder if reminder is not already set
            StoredColors.reminderColor = backgroundColor
            let reminderController = ReminderController()
            reminderController.reminderBodyText = writeNoteView.inputTextView.text
            requestNotificationPermission()
            present(reminderController, animated: true, completion: nil)
        }
        
    }
    
    @objc func handleCancel() {
        let savedNoteController = SavedNoteController()
        savedNoteController.feedbackOnPress()
        navigationController?.popViewController(animated: true)
    }
    
    func requestNotificationPermission() {
        let center = UNUserNotificationCenter.current()
        
        center.requestAuthorization(options: [.alert, .badge, .sound]) { (granted, error) in
            if granted {
                print("Notifications granted")
            } else {
                print("Notifications denied")
            }
        }
    }
    
    func updateContent(index: Int, newContent: String, newDate: Double, isReminder: Bool, notificationUUID: String, reminderDate: String){
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        
        if isFiltering == false {
            notes[index].content = newContent
            notes[index].modifiedDate = newDate
            notes[index].isReminder = isReminder
            notes[index].notificationUUID = notificationUUID
            notes[index].reminderDate = reminderDate
            
        } else if isFiltering == true {
            filteredNotes[index].content = newContent
            filteredNotes[index].modifiedDate = newDate
            filteredNotes[index].isReminder = isReminder
            filteredNotes[index].notificationUUID = notificationUUID
            filteredNotes[index].reminderDate = reminderDate
        }
        
        //setup reminders for next note
        //set reminder to default (false) if note does not have a reminder
        RemindersData.isReminder = false
        
        appDelegate.saveContext()
    }
    
    func setupNotifications() {
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    @objc func adjustForKeyboard(notification: Notification) {
        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        
        let keyboardScreenEndFrame = keyboardValue.cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)
        
        let navigationBarHeight = self.navigationController!.navigationBar.frame.height
        
        if notification.name == UIResponder.keyboardWillHideNotification {
            writeNoteView.inputTextView.contentInset = .zero
            print(writeNoteView.inputTextView.contentInset)
            
        } else {
            writeNoteView.inputTextView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height + navigationBarHeight + 42, right: 0)
        }
        
        writeNoteView.inputTextView.scrollIndicatorInsets = writeNoteView.inputTextView.contentInset
        
        let selectedRange = writeNoteView.inputTextView.selectedRange
        writeNoteView.inputTextView.scrollRangeToVisible(selectedRange)
    }
    
}
