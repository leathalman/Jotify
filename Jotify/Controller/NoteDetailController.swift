//
//  NoteDetailController.swift
//  Jotify
//
//  Created by Harrison Leath on 6/24/19.
//  Copyright © 2019 Harrison Leath. All rights reserved.
//

import UIKit
import UserNotifications

class NoteDetailController: UIViewController {
    
    var navigationTitle: String = ""
    var backgroundColor: UIColor = .white
    var detailText: String = ""
    var index: Int = 0
    
    var notes: [Note] = []
    var filteredNotes: [Note] = []
    var isFiltering: Bool = false
    
    lazy var textView: UITextView = {
        let frame = CGRect(x: 0, y: 30, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        let textField = UITextView(frame: frame)
        textField.backgroundColor = .clear
        textField.textColor = .white
        textField.isEditable = true
        textField.font = UIFont.boldSystemFont(ofSize: 32)
        textField.textContainerInset = UIEdgeInsets(top: 10, left: 15, bottom: 10, right: 15)
        textField.text = detailText
        return textField
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        navigationController?.navigationBar.isHidden = true
        
        view.backgroundColor = backgroundColor
        navigationItem.title = navigationTitle
        navigationController?.navigationBar.prefersLargeTitles = false
        view.addSubview(textView)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        
//        navigationController?.navigationBar.isHidden = false
        
        let newDate = Date.timeIntervalSinceReferenceDate
        updateContent(index: index, newContent: textView.text, newDate: newDate)
        
//        if textView.text.contains("remind") || textView.text.contains("Remind") {
//            print("remind written down!")
//            scheduleNotification(notificationType: "Reminder")
//        }
    }
    
    func scheduleNotification(notificationType: String) {
        
        let notificationCenter = UNUserNotificationCenter.current()
        
        notificationCenter.getNotificationSettings { (settings) in
            if settings.authorizationStatus != .authorized {
                // Notifications not allowed
            } else {
                // Notifcations enabled
                
                let content = UNMutableNotificationContent()
                
                content.title = notificationType
                content.body = self.textView.text
                content.sound = UNNotificationSound.default
                content.badge = 1
                
                //        let date = Date(timeIntervalSinceNow: 3600)
                //        let triggerDate = Calendar.current.dateComponents([.year,.month,.day,.hour,.minute,.second,], from: date)
                //        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: false)
                
                let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
                
                let identifier = "Local Notification"
                let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
                
                notificationCenter.add(request) { (error) in
                    if let error = error {
                        print("Error \(error.localizedDescription)")
                    }
                }
                
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
            notes[index].date = newDate
            
        } else if isFiltering == true {
            filteredNotes[index].content = newContent
            filteredNotes[index].date = newDate
            
        }
        
        appDelegate.saveContext()
    }
    
}
