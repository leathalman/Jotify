//
//  EditingController.swift
//  Jotify
//
//  Created by Harrison Leath on 1/18/21.
//

import UIKit

class EditingController: ToolbarViewController, UITextViewDelegate {
    
    var noteCollection: NoteCollection?
    
    var timer: Timer?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        //change status bar style to white
        setStatusBarStyle(style: EditingData.currentNote.color.getColor().isDarkColor ? .lightContent : .darkContent)
        checkIfReminderExpired()
    }
    
    //life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupNavBar()
        
        //remove multiline input icon
        keyboardToolbar.items?.remove(at: 0)
        //remove save note icon
        keyboardToolbar.items?.removeLast()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        updateContent(content: field.text)
        //reset EditingData's current note for reuse
        EditingData.currentNote = FBNote(content: field.text, timestamp: EditingData.currentNote.timestamp, id: EditingData.currentNote.id, color: EditingData.currentNote.color, reminder: nil, reminderTimestamp: nil)
    }
    
    //view configuration
    func setupView() {
        //color customization to support white/black dynamic type
        field.backgroundColor = EditingData.currentNote.color.getColor()
        field.textColor = EditingData.currentNote.color.getColor().isDarkColor ? .white : .black
        field.tintColor = EditingData.currentNote.color.getColor().isDarkColor ? .white : .black
        
        field.text = EditingData.currentNote.content
        field.delegate = self
        field.font = UIFont.boldSystemFont(ofSize: 18)
        field.frame = CGRect(x: 0, y: 15, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        
        view.addSubview(field)
        
        setStatusBarStyle(style: EditingData.currentNote.color.getColor().isDarkColor ? .lightContent : .darkContent)
    }
    
    func setupNavBar() {
        //setup navigationbar elements
        navigationItem.title = EditingData.currentNote.timestamp.getDate()
        navigationController?.configure(bgColor: EditingData.currentNote.color.getColor())
        navigationController?.navigationBar.standardAppearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor : EditingData.currentNote.color.getColor().isDarkColor ? UIColor.white : .black]
        navigationItem.setHidesBackButton(true, animated: true)
        
        //define image and action for each navigation button
        let ellipsis = UIBarButtonItem(image: UIImage(systemName: "ellipsis.circle"), style: .plain, target: self, action: #selector(handleCancel))
        let cancel = UIBarButtonItem(image: UIImage(systemName: "xmark.circle"), style: .plain, target: self, action: #selector(handleCancel))

        //handle tint color of each button based on view background color
        ellipsis.tintColor = EditingData.currentNote.color.getColor().isDarkColor ? .white : .black
        cancel.tintColor = EditingData.currentNote.color.getColor().isDarkColor ? .white : .black
        
        navigationItem.leftBarButtonItems = [ellipsis]
        navigationItem.rightBarButtonItem = cancel
    }
   
    //action handlers
    @objc func handleCancel() {
        self.playHapticFeedback()
        //dismiss view differently based on presentation style
        if isModal {
            self.dismiss(animated: true, completion: nil)
        } else {
            navigationController?.popViewController(animated: true)
        }
    }
    
    //datamanager interface
    func updateContent(content: String) {
        
        if field.text != EditingData.currentNote.content {
            DataManager.updateNoteContent(content: field.text, uid: EditingData.currentNote.id) { success in
                //handle success
            }
        }
    }
    
    func checkIfReminderExpired() {
        if EditingData.currentNote.reminderTimestamp != nil {
            if EditingData.currentNote.reminderTimestamp ?? 0 < Date().timeIntervalSinceReferenceDate {
                DataManager.removeReminder(uid: EditingData.currentNote.id) { success in
                    if success! {
                        print("Reminder outdated, removed successfully")
                        UIApplication.shared.applicationIconBadgeNumber -= 1
                    } else {
                        print("Reminder outdated, removed unsuccessfully")
                    }
                }
            }
        }
    }
    
    //timer functions for "automatically" saving once a user stops typing
    func resetTimer() {
        timer?.invalidate()
        let nextTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(handleIdleEvent), userInfo: nil, repeats: false)
        timer = nextTimer
    }
    
    @objc func handleIdleEvent() {
        updateContent(content: field.text)
    }
    
    func textViewDidChange(_ textView: UITextView) {
        resetTimer()
        EditingData.currentNote.content = field.text
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if (text as NSString).rangeOfCharacter(from: CharacterSet.newlines).location == NSNotFound {
            return true
        }
        if isBulletedList {
            //make new line and add bullet where cursor is
            field.addBulletOnReturn()
        } else {
            //make new line where cursor is
            field.addNewLineOnReturn()
        }
        
        return false
    }
    
    //handle color selection from ColorGallery
    override func updateColorOverride(color: String) {
        colorOverride = color
        EditingData.currentNote.color = color
        setupView()
        setupNavBar()
        
        DataManager.updateNoteColor(color: color, uid: EditingData.currentNote.id) { success in
            //handle success here
        }
        
        colorOverride = ""
    }
}
