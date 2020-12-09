//
//  NoteDetailController.swift
//  Jotify
//
//  Created by Harrison Leath on 6/24/19.
//  Copyright © 2019 Harrison Leath. All rights reserved.
//

import UIKit
import UserNotifications
import WidgetKit

struct EditingData {
    static var index = Int()
    static var newContent = String()
    static var notes = [Note]()
    static var isEditing = Bool()
    static var width = CGFloat()
}

class NoteDetailController: UIViewController, UITextViewDelegate {
    var navigationTitle: String = ""
    var backgroundColor: UIColor = .white
    var detailText: String = ""
    var index: Int = 0
    
    var datePicker: UIDatePicker = UIDatePicker()
    let toolBar = UIToolbar()
    
    let writeNoteView = WriteNoteView()
    
    let defaults = UserDefaults.standard
    
    var notes: [Note] = []
    var filteredNotes: [Note] = []
    var isFiltering: Bool = false
    
    var navigationBarHeight = CGFloat()
    var popupHeight: CGFloat = 0
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupPersistentNavigationBar()
        removeReminderIfDelivered()
        setupDynamicKeyboardColor()
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
        updateContent(index: index, newContent: writeNoteView.inputTextView.text)
        GroupDataManager().writeData(path: "widgetContent", content: writeNoteView.inputTextView.text)
        GroupDataManager().writeData(path: "widgetColor", content: UIColor.stringFromColor(color: backgroundColor))
        GroupDataManager().writeData(path: "widgetDate", content: navigationTitle)
        
        if #available(iOS 14.0, *) {
            WidgetCenter.shared.reloadAllTimelines()
        }
        
        EditingData.isEditing = false
    }
    
    func setEditingData() {
        EditingData.index = index
        EditingData.notes = notes
        // use isEditing to determine if we are on the NoteDetailController
        // if we are, then call function to save data
        EditingData.isEditing = true
    }
    
    func fetchNotificaitonUUID() {
        if isFiltering {
            let notificationUUID = filteredNotes[index].notificationUUID ?? ""
            RemindersData.notificationUUID = notificationUUID
            
        } else {
            let notificationUUID = notes[index].notificationUUID ?? ""
            RemindersData.notificationUUID = notificationUUID
        }
    }
    
    func setupDynamicKeyboardColor() {
        if !UserDefaults.standard.bool(forKey: "useSystemMode") {
            if UserDefaults.standard.bool(forKey: "darkModeEnabled") {
                writeNoteView.inputTextView.keyboardAppearance = .dark
                writeNoteView.inputTextView.overrideUserInterfaceStyle = .dark
                
            } else {
                writeNoteView.inputTextView.keyboardAppearance = .default
                writeNoteView.inputTextView.overrideUserInterfaceStyle = .light
            }
        }
    }
    
    func removeReminderIfDelivered() {
        if checkIfReminderHasBeenDelivered() {
            if isFiltering {
                filteredNotes[index].isReminder = false
                
            } else {
                notes[index].isReminder = false
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
            if isFiltering {
                let reminderDate = filteredNotes[index].reminderDate ?? "July 1, 2000 at 12:00 AM"
                getReminderDateStringToDisplayForUser(reminderDate: reminderDate)
                
            } else {
                let reminderDate = notes[index].reminderDate ?? "July 1, 2000 at 12:00 AM"
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
        if isFiltering {
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
            
        } else {
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
        }
        
        return false
    }
    
    //WORK ON THIS
    func setupPersistentNavigationBar() {
        guard navigationController?.topViewController === self else { return }
        transitionCoordinator?.animate(alongsideTransition: { [weak self] _ in
            self?.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
            self?.navigationController?.navigationBar.shadowImage = UIImage()
            self?.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
            self?.navigationController?.navigationBar.barStyle = .black
            
            if self?.defaults.bool(forKey: "darkModeEnabled") ?? false {
                if self?.defaults.bool(forKey: "vibrantDarkModeEnabled") ?? true {
                    self?.navigationController?.navigationBar.backgroundColor = self?.backgroundColor
                    self?.navigationController?.navigationBar.barTintColor = self?.backgroundColor
                    
                } else if self?.defaults.bool(forKey: "pureDarkModeEnabled") ?? false {
                    self?.navigationController?.navigationBar.backgroundColor = InterfaceColors.viewBackgroundColor
                    self?.navigationController?.navigationBar.barTintColor = InterfaceColors.viewBackgroundColor
                }
                
            } else {
                self?.navigationController?.navigationBar.backgroundColor = self?.backgroundColor
                self?.navigationController?.navigationBar.barTintColor = self?.backgroundColor
            }
            }, completion: nil)
    }
    
    func setupView() {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "disableSwipe"), object: nil)

        view = writeNoteView
        
        let textView = writeNoteView.inputTextView
        
        StoredColors.reminderColor = backgroundColor
        UIApplication.shared.windows.first?.backgroundColor = backgroundColor
        
        if defaults.bool(forKey: "darkModeEnabled") {
            if defaults.bool(forKey: "vibrantDarkModeEnabled") {
                writeNoteView.backgroundColor = backgroundColor
                textView.backgroundColor = backgroundColor
            } else if defaults.bool(forKey: "pureDarkModeEnabled") {
                writeNoteView.backgroundColor = InterfaceColors.viewBackgroundColor
                textView.backgroundColor = InterfaceColors.viewBackgroundColor
            }
            
        } else {
            writeNoteView.backgroundColor = backgroundColor
            textView.backgroundColor = backgroundColor
        }
        
        textView.tintColor = .white
        navigationBarHeight = navigationController?.navigationBar.bounds.height ?? 0
        print("Current width: \(EditingData.width)")
        writeNoteView.inputTextView.frame = CGRect(x: 0, y: 15, width: EditingData.width, height: writeNoteView.screenHeight - navigationBarHeight - 30)
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
        if !defaults.bool(forKey: "com.austinleath.Jotify.Premium") {
            PremiumView.shared.presentPremiumView(viewController: self)
        } else {
            self.playHapticFeedback()

            if !RemindersData.isReminder || RemindersData.reminderDate.isEmpty {
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
        if popupHeight.isZero {
            popupHeight = view.bounds.height
        }
        reminderExistsController.popupHeight = popupHeight + 170
        
        present(reminderExistsController, animated: true, completion: nil)
    }
    
    func reminderIsNotSet() {
        let reminderController = ReminderController()
        
        if isFiltering {
            reminderController.filteredNotes = filteredNotes
            reminderController.isFiltering = true
            
        } else {
            reminderController.notes = notes
        }
        
        reminderController.index = index
        reminderController.reminderBodyText = writeNoteView.inputTextView.text
        requestNotificationPermission()
        
        print("PopupHeight is \(popupHeight)")
        
        if popupHeight.isZero {
            popupHeight = view.bounds.height
        }
        reminderController.popupHeight = popupHeight
        
        present(reminderController, animated: true, completion: nil)
    }
    
    @objc func handleCancel() {
        self.playHapticFeedback()
        navigationController?.popViewController(animated: true)
    }
    
    func requestNotificationPermission() {
        let center = UNUserNotificationCenter.current()
        
        center.requestAuthorization(options: [.alert, .badge, .sound]) { granted, _ in
            if granted {
                 print("Notifications granted")
            } else {
                 print("Notifications denied")
            }
        }
    }
    
    func updateContent(index: Int, newContent: String) {
        if isFiltering {
            if filteredNotes[index].content != newContent {
                filteredNotes[index].content = newContent
                filteredNotes[index].modifiedDate = Date.timeIntervalSinceReferenceDate
                print("Note: date updated")
            }
            
        } else {
            if notes[index].content != newContent {
                notes[index].content = newContent
                notes[index].modifiedDate = Date.timeIntervalSinceReferenceDate
                print("Note: date updated")
            }
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
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        // more accurately returns new screen size
        // used each time the window is resized
        let frame = CGRect(x: 0, y: 15, width: size.width, height: writeNoteView.screenHeight - navigationBarHeight - 30)
        writeNoteView.inputTextView.frame = frame
        popupHeight = size.height + 40
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        // used to support adaptive interfaces with iPadOS on first launch
        if traitCollection.horizontalSizeClass == .compact {
            let frame = CGRect(x: 0, y: 15, width: view.bounds.width, height: writeNoteView.screenHeight - navigationBarHeight - 30)
            writeNoteView.inputTextView.frame = frame
            popupHeight = view.bounds.height + 40
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}
