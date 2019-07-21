//
//  WriteNoteController.swift
//  Sticky Notes
//
//  Created by Harrison Leath on 5/12/19.
//  Copyright © 2019 Harrison Leath. All rights reserved.
//

import UIKit
import MultilineTextField
import CoreData

class WriteNoteController: UIViewController, UITextViewDelegate {
    
    let writeNoteView = WriteNoteView()
    let themes = Themes()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNotifications()
        
        self.hideKeyboardWhenTappedAround()
        
        view = writeNoteView
        
        writeNoteView.inputTextView.isScrollEnabled = false
        writeNoteView.inputTextView.delegate = self
        writeNoteView.inputTextView.frame = CGRect(x: 0, y: 100, width: writeNoteView.screenWidth, height: writeNoteView.screenHeight)
        writeNoteView.inputTextView.tintColor = .white
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        handleRandomColorsEnabled()
    }
    
    //can change to dismiss when viewWillDisappear
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        writeNoteView.inputTextView.resignFirstResponder()
    }
    
    func handleRandomColorsEnabled() {
        if UserDefaults.standard.bool(forKey: "useRandomColor") == false {
            let color = UserDefaults.standard.color(forKey: "staticNoteColor")
            writeNoteView.colorView.backgroundColor = color
            
        }
        
        if UserDefaults.standard.bool(forKey: "darkModeEnabled") == true {
            writeNoteView.colorView.backgroundColor = InterfaceColors.writeViewColor
            
            UIApplication.shared.windows.first?.backgroundColor = InterfaceColors.viewBackgroundColor
            
        } else {
            writeNoteView.colorView.backgroundColor = StoredColors.noteColor
            
            UIApplication.shared.windows.first?.backgroundColor = StoredColors.noteColor
            
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
            writeNoteView.inputTextView.frame = CGRect(x: 0, y: 100, width: writeNoteView.screenWidth, height: writeNoteView.screenHeight)
        } else {
            writeNoteView.inputTextView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height + 60, right: 0)
            writeNoteView.inputTextView.frame = CGRect(x: 0, y: 40, width: writeNoteView.screenWidth, height: writeNoteView.screenHeight)
        }
        
        writeNoteView.inputTextView.scrollIndicatorInsets = writeNoteView.inputTextView.contentInset
        
        let selectedRange = writeNoteView.inputTextView.selectedRange
        writeNoteView.inputTextView.scrollRangeToVisible(selectedRange)
    }
    
    @objc func handleSend() {
        
        if writeNoteView.inputTextView.text == "" {
            
        } else {
            StoredColors.noteColorString = Colors.stringFromColor(color: StoredColors.noteColor)
            
            let date = Date.timeIntervalSinceReferenceDate
            saveNote(content: writeNoteView.inputTextView.text, color: StoredColors.noteColorString, date: date)
            writeNoteView.inputTextView.text = ""
        }
    }
    
    func saveNote(content: String, color: String, date: Double) {
        
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Note", in: managedContext)!
        let note = NSManagedObject(entity: entity, insertInto: managedContext)
        
        note.setValue(content, forKeyPath: "content")
        note.setValue(color, forKey: "color")
        note.setValue(date, forKey: "date")
        
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if (text as NSString).rangeOfCharacter(from: CharacterSet.newlines).location == NSNotFound {
            return true
        }
        
        //dismiss keyboard on return key
        textView.resignFirstResponder()
        handleSend()
        
        if UserDefaults.standard.bool(forKey: "useRandomColor") == true {
            writeNoteView.getRandomColor()
        }
        
        return false
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}
