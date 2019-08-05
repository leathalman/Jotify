//
//  WriteNoteController.swift
//  Sticky Notes
//
//  Created by Harrison Leath on 5/12/19.
//  Copyright © 2019 Harrison Leath. All rights reserved.
//

import UIKit
import CoreData
import MultilineTextField
import WhatsNewKit

class WriteNoteController: UIViewController, UITextViewDelegate {
    
    let writeNoteView = WriteNoteView()
    
    let themes = Themes()
    
    let defaults = UserDefaults.standard

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        setupNotifications()
          
        if defaults.bool(forKey: "isFirstLaunch") == true {
            presentOnboarding(viewController: self, tintColor: StoredColors.noteColor)
            
            defaults.set(false, forKey: "isFirstLaunch")
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        handleRandomColorsEnabled()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        writeNoteView.inputTextView.resignFirstResponder()
    }
    
    func setupView() {
        self.hideKeyboardWhenTappedAround()
        view = writeNoteView
        
        writeNoteView.inputTextView.isScrollEnabled = false
        writeNoteView.inputTextView.delegate = self
        writeNoteView.inputTextView.frame = CGRect(x: 0, y: 100, width: writeNoteView.screenWidth, height: writeNoteView.screenHeight)
        writeNoteView.inputTextView.tintColor = .white
    }
    
    func handleRandomColorsEnabled() {
        if defaults.bool(forKey: "useRandomColor") == false {
            let color = defaults.color(forKey: "staticNoteColor")
            writeNoteView.colorView.backgroundColor = color
            
        }
        
        if defaults.bool(forKey: "darkModeEnabled") == true {
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
        
        let updateDate = Date(timeIntervalSinceReferenceDate: date)
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.long
        dateFormatter.timeZone = .current
        let dateString = dateFormatter.string(from: updateDate)
        
        note.setValue(dateString, forKey: "dateString")
        
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
        
        if defaults.bool(forKey: "useRandomColor") == true {
            writeNoteView.getRandomColor()
        }
        
        return false
    }
     
    func presentOnboarding(viewController: UIViewController, tintColor: UIColor) {
        let whatsNew = WhatsNew(
            title: "Welcome!",
            items: [
                WhatsNew.Item(
                    title: "Notes",
                    subtitle: "Creating notes is simple: type and enter. Your notes are automatically saved and synced to all of your devices. Swipe right to view your notes.",
                    image: UIImage(named: "write")
                ),
                WhatsNew.Item(
                    title: "Privacy",
                    subtitle: "Jotify does not have access to any of your data and never will. All of your notes are just that, yours.",
                    image: UIImage(named: "lock")
                ),
                WhatsNew.Item(
                    title: "No Accounts. Ever.",
                    subtitle: "Jotify uses your iCloud account to store notes, so no annoying emails or extra passwords to worry about.",
                    image: UIImage(named: "person")
                ),
                WhatsNew.Item(
                    title: "Dark Mode",
                    subtitle: "It looks pretty good. You should check it out.",
                    image: UIImage(named: "moon")
                ),
                WhatsNew.Item(
                    title: "Open Source",
                    subtitle: "Jotify is open source, so you know exactly what is running on your device. Feel free to check it out on GitHub.",
                    image: UIImage(named: "github")
                )
            ]
        )
        
        var configuration = WhatsNewViewController.Configuration()
        configuration.backgroundColor = .white
        configuration.titleView.titleColor = tintColor
        configuration.titleView.insets = UIEdgeInsets(top: 40, left: 20, bottom: 15, right: 15)
        configuration.itemsView.titleFont = .boldSystemFont(ofSize: 17)
        configuration.itemsView.imageSize = .fixed(height: 50)
        configuration.detailButton?.titleColor = tintColor
        configuration.completionButton.backgroundColor = tintColor
        
        let whatsNewViewController = WhatsNewViewController(
            whatsNew: whatsNew,
            configuration: configuration
        )
        
        DispatchQueue.main.async {
            viewController.present(whatsNewViewController, animated: true)
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}
