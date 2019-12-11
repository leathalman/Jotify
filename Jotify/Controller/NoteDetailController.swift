//
//  NoteDetailController.swift
//  Jotify
//
//  Created by Harrison Leath on 6/24/19.
//  Copyright © 2019 Harrison Leath. All rights reserved.
//

import UIKit
import UserNotifications

struct EditingData {
    static var index = Int()
    static var newContent = String()
    static var newDate = Double()
    static var notes = [Note]()
    static var isEditing = Bool()
}

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
        fetchNotificaitonUUID()
        setupNotifications()
        setupView()
        setEditingData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        updateContent(index: index, newContent: writeNoteView.inputTextView.text, newDate: newDate)
        
        EditingData.isEditing = false
    }
    
    func setEditingData() {
        EditingData.newDate = newDate
        EditingData.index = index
        EditingData.notes = notes
        // use isEditing to determine if we are on the NoteDetailController
        // if we are, then call function to save data
        EditingData.isEditing = true
    }
    
    func fetchNotificaitonUUID() {
        if isFiltering == false {
            let notificationUUID = notes[index].notificationUUID ?? ""
            RemindersData.notificationUUID = notificationUUID
            
        } else if isFiltering == true {
            let notificationUUID = filteredNotes[index].notificationUUID ?? ""
            RemindersData.notificationUUID = notificationUUID
        }
    }
    
    func removeReminderIfDelivered() {
        if checkIfReminderHasBeenDelivered() == true {
            if isFiltering == false {
                notes[index].isReminder = false
                
            } else if isFiltering == true {
                filteredNotes[index].isReminder = false
            }
            
            CoreDataManager.shared.enqueue { context in
                do {
                    try context.save()
                    
                } catch let error as NSError {
                    print("Could not save. \(error), \(error.userInfo)")
                }
            }
            
            UIApplication.shared.applicationIconBadgeNumber -= 1
            
        } else {
            if isFiltering == false {
                let reminderDate = notes[index].reminderDate ?? "July 1, 2000 at 12:00 AM"
                getReminderDateStringToDisplayForUser(reminderDate: reminderDate)
                
            } else if isFiltering == true {
                let reminderDate = filteredNotes[index].reminderDate ?? "July 1, 2000 at 12:00 AM"
                getReminderDateStringToDisplayForUser(reminderDate: reminderDate)
            }
        }
    }
    
    func getReminderDateStringToDisplayForUser(reminderDate: String) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy hh:mm a"
        let date = dateFormatter.date(from: reminderDate) ?? Date()
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: date)
        let formattedDate = calendar.date(from: components)!
        
        dateFormatter.dateFormat = "MMMM d, yyyy"
        let firstPartOfDisplayString = dateFormatter.string(from: formattedDate)
        
        dateFormatter.dateFormat = "h:mm a"
        let secondPartOfDisplayString = dateFormatter.string(from: formattedDate)
        
        RemindersData.reminderDate = firstPartOfDisplayString + " at " + secondPartOfDisplayString
    }
    
    func checkIfReminderHasBeenDelivered() -> Bool {
        if isFiltering == false {
            let notificationUUID = notes[index].notificationUUID
            
            if notificationUUID == "cleared" {
                notes[index].notificationUUID = "cleared"
                return true
            }
            
            let isReminder = notes[index].isReminder
            RemindersData.isReminder = notes[index].isReminder
            
            if isReminder == true {
                let reminderDate = notes[index].reminderDate ?? "07/02/2000 11:11 PM"
                
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "MM/dd/yyyy hh:mm a"
                let formattedReminderDate = dateFormatter.date(from: reminderDate) ?? Date()
                
                let currentDate = Date()
                
                if currentDate >= formattedReminderDate {
                    return true
                } else {
                    return false
                }
            }
            
        } else if isFiltering == true {
            let notificationUUID = filteredNotes[index].notificationUUID
            
            if notificationUUID == "cleared" {
                filteredNotes[index].notificationUUID = "cleared"
                return true
            }
            
            let isReminder = filteredNotes[index].isReminder
            RemindersData.isReminder = filteredNotes[index].isReminder
            
            if isReminder == true {
                let reminderDate = filteredNotes[index].reminderDate ?? "07/02/2000 11:11 PM"
                
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "MM/dd/yyyy hh:mm a"
                let formattedReminderDate = dateFormatter.date(from: reminderDate) ?? Date()
                
                let currentDate = Date()
                
                if currentDate >= formattedReminderDate {
                    return true
                } else {
                    return false
                }
            }
        }
        
        return false
    }
    
    func setupPersistentNavigationBar() {
        guard navigationController?.topViewController === self else { return }
        transitionCoordinator?.animate(alongsideTransition: { [weak self] _ in
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
    
    func setupView() {
        view = writeNoteView
        
        let textView = writeNoteView.inputTextView
        
        StoredColors.reminderColor = backgroundColor
        UIApplication.shared.windows.first?.backgroundColor = backgroundColor
        
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
        textView.frame = CGRect(x: 0, y: 15, width: writeNoteView.screenWidth, height: writeNoteView.screenHeight - navigationBarHeight - 30)
        textView.text = detailText
        textView.font = UIFont.boldSystemFont(ofSize: 18)
        textView.placeholder = ""
        
        textView.alwaysBounceVertical = true
        textView.isUserInteractionEnabled = true
        textView.isScrollEnabled = true
        textView.isPlaceholderScrollEnabled = true
        textView.delegate = self
        
        navigationItem.title = navigationTitle
        navigationItem.setHidesBackButton(true, animated: true)
        
        var cancel = UIImage(named: "cancel")
        cancel = cancel?.withRenderingMode(.alwaysOriginal)
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: cancel, style: .plain, target: self, action: #selector(handleCancel))
        
        var alarm = UIImage(named: "alarm.fill")
        alarm = alarm?.withRenderingMode(.alwaysOriginal)
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: alarm, style: .plain, target: self, action: #selector(handleReminder))
        
        hideKeyboardWhenTappedAround()
    }
    
    @objc func handleReminder() {
        if defaults.bool(forKey: "com.austinleath.Jotify.Premium") == false {
            PremiumView.shared.presentPremiumView(viewController: self)
        } else {
            let savedNoteController = SavedNoteController()
            savedNoteController.feedbackOnPress()
            
            if RemindersData.isReminder == false || RemindersData.reminderDate.isEmpty {
                reminderIsNotSet()
            } else {
                alreadySetReminder()
            }
        }
    }
    
    func alreadySetReminder() {
        print("Already set a reminder")
        
        // pass note data so that ReminderExistsController can directly edit the CoreData object
        let reminderExistsController = ReminderExistsController()
        reminderExistsController.index = index
        reminderExistsController.notes = notes
        reminderExistsController.filteredNotes = filteredNotes
        reminderExistsController.isFiltering = isFiltering
        
        present(reminderExistsController, animated: true, completion: nil)
    }
    
    func reminderIsNotSet() {
        let reminderController = ReminderController()
        
        if isFiltering == true {
            reminderController.filteredNotes = filteredNotes
            reminderController.isFiltering = true
            
        } else {
            reminderController.notes = notes
        }
        
        reminderController.index = index
        reminderController.reminderBodyText = writeNoteView.inputTextView.text
        requestNotificationPermission()
        present(reminderController, animated: true, completion: nil)
    }
    
    @objc func handleCancel() {
        let savedNoteController = SavedNoteController()
        savedNoteController.feedbackOnPress()
        navigationController?.popViewController(animated: true)
    }
    
    func requestNotificationPermission() {
        let center = UNUserNotificationCenter.current()
        
        center.requestAuthorization(options: [.alert, .badge, .sound]) { granted, _ in
            if granted {
                // print("Notifications granted")
            } else {
                // print("Notifications denied")
            }
        }
    }
    
    func updateContent(index: Int, newContent: String, newDate: Double) {
        if isFiltering == false {
            notes[index].content = newContent
            notes[index].modifiedDate = newDate
            
        } else if isFiltering == true {
            filteredNotes[index].content = newContent
            filteredNotes[index].modifiedDate = newDate
        }
        
        CoreDataManager.shared.enqueue { context in
            do {
                try context.save()
                
            } catch let error as NSError {
                print("Could not save. \(error), \(error.userInfo)")
            }
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        // set newContent everytime character is changed
        EditingData.newContent = textView.text
        
        return true
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
        
        let navigationBarHeight = navigationController?.navigationBar.frame.height
        
        if notification.name == UIResponder.keyboardWillHideNotification {
            writeNoteView.inputTextView.contentInset = .zero
            
        } else {
            writeNoteView.inputTextView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height + (navigationBarHeight ?? 10) + 42, right: 0)
        }
        
        writeNoteView.inputTextView.scrollIndicatorInsets = writeNoteView.inputTextView.contentInset
        
        let selectedRange = writeNoteView.inputTextView.selectedRange
        writeNoteView.inputTextView.scrollRangeToVisible(selectedRange)
    }
}
