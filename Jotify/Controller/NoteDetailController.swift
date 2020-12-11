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

class NoteDetailController: UIViewController, UITextViewDelegate {
    var navigationTitle: String = ""
    var backgroundColor: UIColor = .white
    
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
        setupView()
        fetchNotificaitonUUID()
        setupNotifications()
        updateWidget()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        updateContent(newContent: writeNoteView.inputTextView.text)
        updateWidget()
    }
    
    func fetchNotificaitonUUID() {
        let notificationUUID = NoteData.recentNote.notificationUUID ?? ""
        RemindersData.notificationUUID = notificationUUID
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
            NoteData.recentNote.isReminder = false
            
            CoreDataManager.shared.enqueue { context in
                do {
                    try context.save()
                    
                } catch let error as NSError {
                    print("Could not save. \(error), \(error.userInfo)")
                }
            }
            
            UIApplication.shared.applicationIconBadgeNumber -= 1
            
        } else {
            let reminderDate = NoteData.recentNote.reminderDate ?? "July 1, 2000 at 12:00 AM"
            getReminderDateStringToDisplayForUser(reminderDate: reminderDate)
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
        
        let notificationUUID = NoteData.recentNote.notificationUUID ?? ""
        
        if notificationUUID == "cleared" {
            NoteData.recentNote.notificationUUID = "cleared"
            return true
        }
        
        let isReminder = NoteData.recentNote.isReminder
        RemindersData.isReminder = NoteData.recentNote.isReminder
        
        if isReminder == true {
            let reminderDate = NoteData.recentNote.reminderDate ?? "07/02/2000 11:11 PM"
            
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
        return false
    }
    
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
        
        backgroundColor = UIColor.colorFromString(string: NoteData.recentNote.color ?? "blue2")
        navigationTitle = NoteData.recentNote.dateString ?? "July 2, 2002"
        navigationController?.navigationItem.title = NoteData.recentNote.dateString ?? "July 2, 2002"

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
        
        writeNoteView.inputTextView.frame = CGRect(x: 0, y: 15, width: UIDevice.current.screenWidth, height: UIDevice.current.screenHeight - navigationBarHeight - 30)
        
        textView.text = NoteData.recentNote.content ?? "Note data did not load properly"
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
        
        if popupHeight.isZero {
            popupHeight = view.bounds.height
        }
        reminderExistsController.popupHeight = popupHeight + 170
        
        present(ReminderExistsController(), animated: true, completion: nil)
    }
    
    func reminderIsNotSet() {
        requestNotificationPermission()
        present(ReminderController(), animated: true, completion: nil)
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
    
    func updateContent(newContent: String) {
        if NoteData.recentNote.content != newContent {
            NoteData.recentNote.content = newContent
            NoteData.recentNote.modifiedDate = Date.timeIntervalSinceReferenceDate
            print("Note: updated")
        }
        
        CoreDataManager.shared.fetchNotes()
    }
    
    func updateWidget() {
        GroupDataManager().writeData(path: "widgetContent", content: writeNoteView.inputTextView.text)
        GroupDataManager().writeData(path: "widgetColor", content: UIColor.stringFromColor(color: backgroundColor))
        GroupDataManager().writeData(path: "widgetDate", content: navigationTitle)
        
        if #available(iOS 14.0, *) {
            WidgetCenter.shared.reloadAllTimelines()
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        updateContent(newContent: textView.text)
        updateWidget()
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
        let frame = CGRect(x: 0, y: 15, width: size.width, height: UIDevice.current.screenHeight - navigationBarHeight - 30)
        writeNoteView.inputTextView.frame = frame
        popupHeight = size.height + 40
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        // used to support adaptive interfaces with iPadOS on first launch
        if traitCollection.horizontalSizeClass == .compact {
            let frame = CGRect(x: 0, y: 15, width: view.bounds.width, height: UIDevice.current.screenHeight - navigationBarHeight - 30)
            writeNoteView.inputTextView.frame = frame
            popupHeight = view.bounds.height + 40
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}
