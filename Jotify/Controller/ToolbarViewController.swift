//
//  ToolbarViewController.swift
//  Jotify
//
//  Created by Harrison Leath on 6/21/21.
//

import UIKit
import SPIndicator
import SPPermissions

protocol ColorGalleryDelegate {
    func updateColorOverride(color: String)
}

//handles data sharing between ToolbarViewController and ReminderController
struct EditingData {
    static var currentNote = FBNote(content: "", timestamp: 0, id: "", color: "")
    //used to set the text of the most recent note on first launch from client instead of server
    static var firstNote = false
}

class ToolbarViewController: UIViewController, ColorGalleryDelegate {
    
    lazy var field: UITextView = {
        let f = UITextView()
        f.backgroundColor = .clear
        f.textColor = .white
        f.tintColor = .white
        f.isEditable = true
        f.font = UIFont.boldSystemFont(ofSize: 32)
        f.textContainerInset = UIEdgeInsets(top: 10, left: 15, bottom: 10, right: 15)
        f.translatesAutoresizingMaskIntoConstraints = false
        return f
    }()
    
    var keyboardToolbar = UIToolbar()
    
    var isBulletedList: Bool = false  
    var isMultiline: Bool = false
    
    let placeholder: String = "Start typing or swipe right for saved notes..."
    
    //observe a color chosen through ColorGallery
    var colorOverride = ""
    
    override func viewDidLoad() {
        SPIndicatorConfiguration.duration = 1

        setupToolbar()
        
        if UserDefaults.standard.bool(forKey: "multilineInputEnabled") {
            isMultiline = true
        } else {
            isMultiline = false
        }
        
        //setup notifications for keyboard
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    //toolbar UI setup
    func setupToolbar() {
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        let multiline = UIBarButtonItem(image: UIImage(systemName: "line.horizontal.2.decrease.circle"), style: .plain, target: self, action: #selector(toggleMultilineInput))
        let colorpicker = UIBarButtonItem(image: UIImage(systemName: "eyedropper"), style: .plain, target: self, action: #selector(showColorGalleryController))
        let list = UIBarButtonItem(image: UIImage(systemName: "list.bullet"), style: .plain, target: self, action: #selector(addBullet))
        let timer = UIBarButtonItem(image: UIImage(systemName: "timer"), style: .plain, target: self, action: #selector(showReminderController))
        let help = UIBarButtonItem(image: UIImage(systemName: "arrow.down.app"), style: .plain, target: self, action: #selector(keyboardSaveNote))
        keyboardToolbar.items = [multiline, spacer, list, spacer, timer, spacer, colorpicker, spacer, help]
        keyboardToolbar.sizeToFit()
        field.inputAccessoryView = keyboardToolbar
    }
    
    //toolbar action cofiguration
    @objc func toggleMultilineInput() {
        if isMultiline {
            isMultiline = false
            SPIndicator.present(title: "Multiline Input Disabled", preset: .error)
            UserDefaults.standard.setValue(false, forKey: "multilineInputEnabled")
            DataManager.updateUserSettings(setting: "multilineInputEnabled", value: false) { (success) in }
        } else {
            isMultiline = true
            SPIndicator.present(title: "Multiline Input Enabled", preset: .done)
            UserDefaults.standard.setValue(true, forKey: "multilineInputEnabled")
            DataManager.updateUserSettings(setting: "multilineInputEnabled", value: true) { (success) in }
        }
    }
    
    @objc func addBullet() {
        if isBulletedList {
            isBulletedList = false
            SPIndicator.present(title: "Bulleted List Disabled", preset: .error)
        } else {
            isBulletedList = true
            isMultiline = true
            SPIndicator.present(title: "Bulleted List Enabled", preset: .done)
            field.addBullet()
        }
    }
    
    @objc func showReminderController() {
        let setup = SetupController()
        if setup.isNotificationAuthorized {
            let reminder = ReminderController(style: .insetGrouped)
            present(reminder, animated: true, completion: nil)
        } else {
            //if notifications are not setup, do not let user create reminders
            let controller = SPPermissions.dialog([.notification])
            controller.dismissCondition = .allPermissionsAuthorized
            controller.showCloseButton = true
            controller.allowSwipeDismiss = false
            controller.footerText = "Notification permission is required for Jotify to deliver your reminders."
            controller.present(on: self)
        }
    }
    
    @objc func showColorGalleryController() {
        let gallery = ColorGalleryController(style: .insetGrouped)
        gallery.delegate = self
        present(gallery, animated: true, completion: nil)
    }
    
    @objc func keyboardSaveNote () { return }
    
    //empty method because it is designed to be overriden by child class
    func updateColorOverride(color: String) { }
    
    //takes text string and seperates it into array based on num of lines
    //checks line where cursor is for bullet point and changes editing var respectedly
    func checkForBulletList() {
        if !field.text.isEmpty {
            if let selectedRange = field.selectedTextRange {
                let cursorPosition = field.offset(from: field.beginningOfDocument, to: selectedRange.start)
                
                let lines = field.text.split(whereSeparator: \.isNewline)
                
                var charCount = 0
                var sectionCount = 0
                
                while charCount < cursorPosition && sectionCount < lines.count {
                    charCount += lines[sectionCount].count + 1
                    sectionCount += 1
                }
                
                //**throws index out of bounds error when pasting sometimes**
                if sectionCount > 0 {
                    if lines[sectionCount - 1].contains("\u{2022}") {
                        isBulletedList = true
                    } else {
                        isBulletedList = false
                    }
                }
            }
        }
    }
    
    //handle keyboard interaction with view
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            let insets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height + keyboardToolbar.frame.height, right: 0)
            field.contentInset = insets
            field.scrollIndicatorInsets = insets
            view.layoutIfNeeded()
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        let insets = UIEdgeInsets.zero
        field.contentInset = insets
        field.scrollIndicatorInsets = insets
        view.layoutIfNeeded()
    }
}
