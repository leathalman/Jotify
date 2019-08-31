//
//  NoteDetailController.swift
//  Jotify
//
//  Created by Harrison Leath on 6/24/19.
//  Copyright © 2019 Harrison Leath. All rights reserved.
//

import UIKit
import UserNotifications

class NoteDetailController: UIViewController, UITextViewDelegate, UNUserNotificationCenterDelegate {
    
    var navigationTitle: String = ""
    var backgroundColor: UIColor = .white
    var detailText: String = ""
    var index: Int = 0
    
    let writeNoteView = WriteNoteView()
    
    let defaults = UserDefaults.standard
        
    var notes: [Note] = []
    var filteredNotes: [Note] = []
    var isFiltering: Bool = false
    
    var navigationBarHeight = CGFloat()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupPersistentNavigationBar()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationBarHeight = self.navigationController!.navigationBar.frame.height
        
        setupNotifications()
        setupView()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        let newDate = Date.timeIntervalSinceReferenceDate
        updateContent(index: index, newContent: writeNoteView.inputTextView.text, newDate: newDate)
        
        resetNavigationBarForTransition()
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
        textView.frame = CGRect(x: 0, y: 15, width: writeNoteView.screenWidth, height: writeNoteView.screenHeight)
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
        
        var alarm = UIImage(named: "alarm")
        alarm = alarm?.withRenderingMode(.alwaysOriginal)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: alarm, style: .plain, target: self, action: #selector(handleReminder))
        
        self.hideKeyboardWhenTappedAround()
    }
    
    @objc func handleCancel() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func handleReminder() {
        registerLocal()
        scheduledLocal()
    }
    
    func registerLocal() {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            if granted {
                print("Authorized Notifications")
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
        content.body = self.writeNoteView.inputTextView.text
        content.categoryIdentifier = "reminder"
        content.userInfo = ["customData" : "stuff"]
        content.sound = .default
        content.badge = 1
        
        var dateComponets = DateComponents()
        dateComponets.hour = 10
        dateComponets.minute = 30
//        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponets, repeats: false)
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 3, repeats: false)
        
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        center.add(request)
        print("added notification")
        
//        UIApplication.shared.applicationIconBadgeNumber = 0
    }
    
    func registerCategories() {
        let center = UNUserNotificationCenter.current()
        center.delegate = self
        
        let show = UNNotificationAction(identifier: "show", title: "Tell me more...", options: .foreground)
        let category = UNNotificationCategory(identifier: "reminder", actions: [show], intentIdentifiers: [])
        
        center.setNotificationCategories([category])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        
        if let customData = userInfo["customData"] as? String {
            print("Custom data received: \(customData)")
            
            switch response.actionIdentifier {
            case UNNotificationDefaultActionIdentifier:
                // the user swiped to unlock
                print("Default identifier")

            case "show":
                // the user tapped our "show more info…" button
                print("Show more information…")

            default:
                break
            }
        }
        
        completionHandler()
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
        
        if notification.name == UIResponder.keyboardWillHideNotification {
            writeNoteView.inputTextView.contentInset = .zero
            
        } else {
            writeNoteView.inputTextView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height + navigationBarHeight + 20, right: 0)
        }
        
        writeNoteView.inputTextView.scrollIndicatorInsets = writeNoteView.inputTextView.contentInset
        
        let selectedRange = writeNoteView.inputTextView.selectedRange
        writeNoteView.inputTextView.scrollRangeToVisible(selectedRange)
    }
    
    
}
