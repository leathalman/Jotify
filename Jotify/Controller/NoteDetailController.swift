//
//  NoteDetailController.swift
//  Jotify
//
//  Created by Harrison Leath on 6/24/19.
//  Copyright © 2019 Harrison Leath. All rights reserved.
//

import UIKit
import UserNotifications

//crashes when relaunching and entering existing controller
//doesnt properly save reminder date???

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
        //        resetRemindersData()
        setupNotifications()
        setupView()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        updateContent(index: index, newContent: writeNoteView.inputTextView.text, newDate: newDate)
        
        resetNavigationBarForTransition()
    }
    
    func removeReminderIfDelivered() {
        if checkIfReminderHasBeenDelivered() == true {
            updateContent(index: index, newContent: writeNoteView.inputTextView.text, newDate: newDate)
            UIApplication.shared.applicationIconBadgeNumber -= 1
            
        } else {
            if isFiltering == false {
                
                let reminderDate = notes[index].reminderDate!
                getReminderDateStringToDisplayForUser(reminderDate: reminderDate)
                
            } else if isFiltering == true {
                
                let reminderDate = filteredNotes[index].reminderDate!
                getReminderDateStringToDisplayForUser(reminderDate: reminderDate)
                
            }
        }
    }
    
    func getReminderDateStringToDisplayForUser(reminderDate: String) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy hh:mm a"
        let date = dateFormatter.date(from: reminderDate) ?? Date()
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day, .hour], from: date)
        let formattedDate = calendar.date(from:components)!
        
        dateFormatter.dateFormat = "MMMM d, yyyy"
        let firstPartOfDisplayString = dateFormatter.string(from: formattedDate)
        
        dateFormatter.dateFormat = "h:mm a"
        let secondPartOfDisplayString = dateFormatter.string(from: formattedDate)
        
        RemindersData.reminderDate = firstPartOfDisplayString + " at " + secondPartOfDisplayString
    }
    
    func checkIfReminderHasBeenDelivered() -> Bool {
        //refactor!
        
        if isFiltering == false {
            
            let isReminder = notes[index].isReminder
            
            if isReminder == true {
                let reminderDate = notes[index].reminderDate ?? "07/02/2000 11:11 PM"
                
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "MM/dd/yyyy hh:mm a"
                let formattedReminderDate = dateFormatter.date(from: reminderDate) ?? Date()
                
                let currentDate = Date()
                
                if currentDate + 10 >= formattedReminderDate {
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
                
                if currentDate + 10 >= formattedReminderDate {
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
        
        StoredColors.reminderColor = backgroundColor
        
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
        
        navigationItem.title = navigationTitle
        navigationItem.setHidesBackButton(true, animated:true)
        
        var cancel = UIImage(named: "cancel")
        cancel = cancel?.withRenderingMode(.alwaysOriginal)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: cancel, style:.plain, target: self, action: #selector(handleCancel))
        
        var alarm = UIImage(named: "alarm.fill")
        alarm = alarm?.withRenderingMode(.alwaysOriginal)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: alarm, style: .plain, target: self, action: #selector(handleReminder))
        
        self.hideKeyboardWhenTappedAround()
    }
    
    @objc func handleReminder() {
        
        if isFiltering == false {
            if notes[index].isReminder == true {
                alreadySetReminder()
                
            } else {
                reminderIsNotSet()
            }
            
        } else if isFiltering == true {
            if filteredNotes[index].isReminder == true {
                alreadySetReminder()
                
            } else {
                reminderIsNotSet()
            }
        }
    }
    
    func alreadySetReminder() {
        //do something if a reminder is already set
        // present secondary vc that displays time reminder is set, and offers to cancel it
        print("Already set a reminder")
        
        present(ReminderExistsController(), animated: true, completion: nil)
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
        
        center.requestAuthorization(options: [.alert, .badge, .sound]) { (granted, error) in
            if granted {
                print("Notifications granted")
            } else {
                print("Notifications denied")
            }
        }
    }
    
    func updateContent(index: Int, newContent: String, newDate: Double){
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        
        if isFiltering == false {
            notes[index].content = newContent
            notes[index].modifiedDate = newDate
            
        } else if isFiltering == true {
            filteredNotes[index].content = newContent
            filteredNotes[index].modifiedDate = newDate
        }
        
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
