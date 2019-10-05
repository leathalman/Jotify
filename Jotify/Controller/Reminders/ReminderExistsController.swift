//
//  ReminderExistsController.swift
//  Jotify
//
//  Created by Harrison Leath on 9/29/19.
//  Copyright © 2019 Harrison Leath. All rights reserved.
//

import UIKit
import UserNotifications
import BottomPopup
import SPAlert

class ReminderExistsController: BottomPopupViewController {
    
    var noteColor = StoredColors.reminderColor
    var reminderDate = RemindersData.reminderDate
    
    var index: Int = 0
    var notes: [Note] = []
    var filteredNotes: [Note] = []
    var isFiltering: Bool = false
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Reminder already set:"
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 35)
        label.numberOfLines = 0
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    lazy var detailLabel: UILabel = {
        let label = UILabel()
        label.text = "Default text"
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.numberOfLines = 0
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    lazy var removeButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.setTitle("Delete", for: .normal)
        button.addTarget(self, action: #selector(removePressed(sender:)), for: .touchUpInside)
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
        
        detailLabel.text = "Would you like to delete this reminder for \(reminderDate)?"
        
        view.addSubview(titleLabel)
        view.addSubview(detailLabel)
        view.addSubview(removeButton)
        
        titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 25).isActive = true
        titleLabel.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width - 30).isActive = true
        
        detailLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        detailLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20).isActive = true
        detailLabel.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width / 1.15).isActive = true
        
        removeButton.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height / 11).isActive = true
        removeButton.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width - 30).isActive = true
        removeButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        removeButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -40).isActive = true
    }
    
    func setupDynamicColors () {
        if UserDefaults.standard.bool(forKey: "darkModeEnabled") == true {
            view.backgroundColor = .grayBackground
            let removeButtonColor = UIColor.grayBackground.adjust(by: 4.75)
            removeButton.backgroundColor = removeButtonColor
            
        } else if UserDefaults.standard.bool(forKey: "darkModeEnabled") == false {
            view.backgroundColor = noteColor
            removeButton.backgroundColor = noteColor.adjust(by: -7.75)
        }
    }
    
    @objc func removePressed(sender: UIButton) {
        print("Remove notification")
        let reminderController = ReminderController()
        reminderController.feedbackOnPress()
                
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        
        if isFiltering == false {
            let notificationUUID = notes[index].notificationUUID ?? "empty error in ReminderExistsController"
            let center = UNUserNotificationCenter.current()
            center.removePendingNotificationRequests(withIdentifiers: [notificationUUID])
            notes[index].notificationUUID = "cleared"
            notes[index].isReminder = false

        } else if isFiltering == true {
            let notificationUUID = filteredNotes[index].notificationUUID ?? "empty error in ReminderExistsController"
            let center = UNUserNotificationCenter.current()
            center.removePendingNotificationRequests(withIdentifiers: [notificationUUID])
            filteredNotes[index].notificationUUID = "cleared"
            filteredNotes[index].isReminder = false
        }
        
        appDelegate.saveContext()
        
        RemindersData.isReminder = false
        
        let alertView = SPAlertView(title: "Reminder Deleted", message: nil, preset: .done)
        alertView.duration = 1
        alertView.present()
        
        dismiss(animated: true, completion: nil)
    }
    
    @objc func cancelPressed(sender: UIButton) {
        print("Cancel removing notification")
        let reminderController = ReminderController()
        reminderController.feedbackOnPress()
        dismiss(animated: true, completion: nil)
    }
    
    func estimatedLabelHeight(text: String, width: CGFloat, font: UIFont) -> CGFloat {
        
        let size = CGSize(width: width, height: 1000)
        
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        
        let attributes = [NSAttributedString.Key.font: font]
        
        let rectangleHeight = String(text).boundingRect(with: size, options: options, attributes: attributes, context: nil).height
        
        return rectangleHeight
    }
    
    override func getPopupHeight() -> CGFloat {
        let titleText = titleLabel.text ?? ""
        let titleHeight = estimatedLabelHeight(text: titleText, width: UIScreen.main.bounds.width - 30, font: .boldSystemFont(ofSize: 35))
        
        let detailText = detailLabel.text ?? ""
        let detailHeight = estimatedLabelHeight(text: detailText, width: UIScreen.main.bounds.width / 1.15, font: .boldSystemFont(ofSize: 20))
        
        return (UIScreen.main.bounds.height / 11) + (detailHeight + 30) + (titleHeight + 40) + 90
    }
}
