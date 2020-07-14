//
//  WriteNoteController.swift
//  Sticky Notes
//
//  Created by Harrison Leath on 5/12/19.
//  Copyright © 2019 Harrison Leath. All rights reserved.
//

import CoreData
import MultilineTextField
import UIKit

class WriteNoteController: UIViewController, UITextViewDelegate {
    let writeNoteView = WriteNoteView()
    
    let defaults = UserDefaults.standard
        
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupNotifications()
        presentOnboarding()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        Themes().triggerSystemMode(mode: traitCollection)
        setupPlaceholder()
        setupDynamicBackground()
        setupDynamicKeyboardColor()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        writeNoteView.inputTextView.resignFirstResponder()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        handleSend()
    }
    
    func setupView() {
        view = writeNoteView
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        view.addGestureRecognizer(tap)
        
        writeNoteView.inputTextView.frame = CGRect(x: 0, y: 100, width: writeNoteView.screenWidth, height: writeNoteView.screenHeight / 4)
        
        writeNoteView.inputTextView.isScrollEnabled = false
        writeNoteView.inputTextView.delegate = self
        writeNoteView.inputTextView.tintColor = .white
        writeNoteView.inputTextView.isScrollEnabled = true
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        writeNoteView.inputTextView.becomeFirstResponder()
    }
    
    func setupPlaceholder() {
        let placeholder = UserDefaults.standard.string(forKey: "writeNotePlaceholder")
        writeNoteView.inputTextView.placeholder = placeholder
    }
    
    func setupDynamicBackground() {
        if defaults.bool(forKey: "vibrantDarkModeEnabled") {
            writeNoteView.backgroundColor = UIColor.grayBackground
            UIApplication.shared.windows.first?.backgroundColor = UIColor.grayBackground
        } else if defaults.bool(forKey: "pureDarkModeEnabled") {
            writeNoteView.backgroundColor = UIColor.black
            UIApplication.shared.windows.first?.backgroundColor = UIColor.black
        } else if !defaults.bool(forKey: "darkModeEnabled") {
            writeNoteView.backgroundColor = StoredColors.noteColor
            UIApplication.shared.windows.first?.backgroundColor = StoredColors.noteColor
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
            writeNoteView.inputTextView.frame = CGRect(x: 0, y: 100, width: view.bounds.width, height: writeNoteView.screenHeight / 4)
        } else {
            writeNoteView.inputTextView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height + 42, right: 0)
            writeNoteView.inputTextView.frame = CGRect(x: 0, y: 40, width: view.bounds.width, height: writeNoteView.screenHeight)
        }
        
        writeNoteView.inputTextView.scrollIndicatorInsets = writeNoteView.inputTextView.contentInset
        
        let selectedRange = writeNoteView.inputTextView.selectedRange
        writeNoteView.inputTextView.scrollRangeToVisible(selectedRange)
    }
    
    @objc func handleSend() {
        if !writeNoteView.inputTextView.text.isEmpty {
            StoredColors.noteColorString = UIColor.stringFromColor(color: StoredColors.noteColor)
            UserDefaults.standard.setValue(StoredColors.noteColorString, forKey: "previousColor")
            
            let date = Date.timeIntervalSinceReferenceDate
            saveNote(content: writeNoteView.inputTextView.text, color: StoredColors.noteColorString, date: date)
            writeNoteView.inputTextView.text = ""
            
            // userdefaults so previous color persists through relaunch
            if defaults.bool(forKey: "useRandomColor") {
                writeNoteView.getRandomColor(previousColor: UIColor.colorFromString(string: UserDefaults.standard.string(forKey: "previousColor") ?? "blue2"))
            }
        }
    }
    
    func saveNote(content: String, color: String, date: Double) {
        CoreDataManager.shared.enqueue { context in
            do {
                self.setNoteValues(context: context, content: content, color: color, date: date)
                try context.save()
                
            } catch let error as NSError {
                print("Could not save. \(error), \(error.userInfo)")
            }
        }
    }
    
    func setNoteValues(context: NSManagedObjectContext, content: String, color: String, date: Double) {
        let entity = NSEntityDescription.entity(forEntityName: "Note", in: context)!
        let note = NSManagedObject(entity: entity, insertInto: context)
        
        note.setValue(content, forKeyPath: "content")
        note.setValue(color, forKey: "color")
        note.setValue(date, forKey: "date")
        
        note.setValue(date, forKey: "createdDate")
        note.setValue(date, forKey: "modifiedDate")
        note.setValue(false, forKey: "isReminder")
        note.setValue("", forKey: "reminderDate")
                
        let updateDate = Date(timeIntervalSinceReferenceDate: date)
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.long
        dateFormatter.timeZone = .current
        let dateString = dateFormatter.string(from: updateDate)
        
        note.setValue(dateString, forKey: "dateString")
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if (text as NSString).rangeOfCharacter(from: CharacterSet.newlines).location == NSNotFound {
            return true
        }
        
        if defaults.bool(forKey: "useMultilineInput") {
            // print new line on return
            if text == "\n" {
                textView.text += "\n"
            }
            
        } else {
            // dismiss keyboard on return key
            textView.resignFirstResponder()
            handleSend()
        }
        
        return false
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        // more accurately returns new screen size
        // used each time the window is resized
        let frame = CGRect(x: 0, y: 100, width: size.width, height: writeNoteView.screenHeight / 4)
        writeNoteView.inputTextView.frame = frame
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        // used to support adaptive interfaces with iPadOS on first launch
        if traitCollection.horizontalSizeClass == .compact {
            let frame = CGRect(x: 0, y: 100, width: view.bounds.width, height: writeNoteView.screenHeight / 4)
            writeNoteView.inputTextView.frame = frame
        }
        
        Themes().triggerSystemMode(mode: traitCollection)
        setupDynamicBackground()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}
