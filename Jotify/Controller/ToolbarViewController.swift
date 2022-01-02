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
    
    //must define size for toolbar otherwise constraints get messy in console
    var keyboardToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
    
    var isBulletedList: Bool = false
    var isMultiline: Bool = false
    
    let placeholder: String = "Start typing or swipe right for saved notes..."
    
    //observe a color chosen through ColorGallery
    var colorOverride = ""
    
    var reminderButtonEnabled = true
    
    override func viewDidLoad() {
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
        //customize multiline appearance if its used
        var img = UIImage(systemName: "line.horizontal.2.decrease.circle")
        
        if isMultiline {
            img = UIImage(systemName: "line.horizontal.2.decrease.circle.fill")
        }
        
        let multiline = UIBarButtonItem(image: img, style: .plain, target: self, action: #selector(toggleMultilineInput))
        let colorpicker = UIBarButtonItem(image: UIImage(systemName: "eyedropper"), style: .plain, target: self, action: #selector(showColorGalleryController))
        let list = UIBarButtonItem(image: UIImage(systemName: "list.bullet"), style: .plain, target: self, action: #selector(addBullet))
        let timer = UIBarButtonItem(image: UIImage(systemName: "timer"), style: .plain, target: self, action: #selector(showReminderController))
        timer.isEnabled = reminderButtonEnabled

        if reminderButtonEnabled {
            timer.tintColor = nil
        } else {
            timer.tintColor = UIColor.gray
        }
        
        let help = UIBarButtonItem(image: UIImage(systemName: "arrow.down.to.line.circle"), style: .plain, target: self, action: #selector(keyboardSaveNote))
        keyboardToolbar.items = [multiline, spacer, list, spacer, timer, spacer, colorpicker, spacer, help]
        keyboardToolbar.sizeToFit()
        field.inputAccessoryView = keyboardToolbar
    }
    
    //toolbar action cofiguration
    @objc func toggleMultilineInput() {
        if isMultiline {
            isMultiline = false
            setupToolbar()
            let indicatorView = SPIndicatorView(title: "Multiline Input Disabled", preset: .error)
            indicatorView.present(duration: 1)
            UserDefaults.standard.setValue(false, forKey: "multilineInputEnabled")
            DataManager.updateUserSettings(setting: "multilineInputEnabled", value: false) { (success) in }
        } else {
            isMultiline = true
            setupToolbar()
            let indicatorView = SPIndicatorView(title: "Multiline Input Enabled", preset: .done)
            indicatorView.present(duration: 1)
            UserDefaults.standard.setValue(true, forKey: "multilineInputEnabled")
            DataManager.updateUserSettings(setting: "multilineInputEnabled", value: true) { (success) in }
        }
    }
    
    @objc func addBullet() {
        checkForBulletList()
        if isBulletedList {
            let indicatorView = SPIndicatorView(title: "Bullet Already Exists", preset: .error)
            indicatorView.present(duration: 1)
        } else {
            isMultiline = true
            field.addBullet()
        }
    }
    
    @objc func showReminderController() {
        if SPPermissions.Permission.notification.authorized {
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
                
                let lines = field.text.components(separatedBy: "\n")
                
                var charCount = 0
                var sectionCount = 0
                
                while charCount < cursorPosition && sectionCount < lines.count {
                    charCount += lines[sectionCount].count + 1
                    sectionCount += 1
                }
                
                if sectionCount > 0 {
                    //only true if cursor is on new "empty" line
                    //meaning either bullet is not enabled **or**
                    //bullet was deleted on current line, so user does not bullets to be enabled
                    if lines.indices.contains(sectionCount) {
                        isBulletedList = false
                    } else {
                        //there is text on the current line
                        if lines[sectionCount - 1].contains("\u{2022}") {
                            isBulletedList = true
                        } else {
                            isBulletedList = false
                        }
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
