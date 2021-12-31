//
//  EditingController.swift
//  Jotify
//
//  Created by Harrison Leath on 1/18/21.
//

import UIKit

class EditingController: ToolbarViewController, UITextViewDelegate {
    
    var noteCollection: NoteCollection?
    
    //store the content value before note is edited
    var initialContent: String?
    
    var timer: Timer?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        //change status bar style to white when PageBoyController is present
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
        initialContent = EditingData.currentNote.content
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
        
        navigationItem.setHidesBackButton(true, animated: false)
        
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
        if field.text != initialContent {
            DataManager.updateNoteContent(content: field.text, uid: EditingData.currentNote.id) { success in
                //handle success
            }
        }
    }
    
    func checkIfReminderExpired() {
        if EditingData.currentNote.reminderTimestamp ?? 0 > 0 {
            if EditingData.currentNote.reminderTimestamp ?? 0 < Date().timeIntervalSinceReferenceDate {
                DataManager.removeReminder(uid: EditingData.currentNote.id) { success in
                    if success! {
                        print("Reminder outdated, removed successfully")
                        EditingData.currentNote.reminderTimestamp = nil
                        EditingData.currentNote.reminder = nil
                        //Retreive the value from User Defaults and decrease it by 1
                        let badgeCount = UserDefaults.standard.value(forKey: "notificationBadgeCount") as! Int - 1
                        //Save the new value to User Defaults
                        UserDefaults.standard.set(badgeCount, forKey: "notificationBadgeCount")
                        UIApplication.shared.applicationIconBadgeNumber -= 1
                    } else {
                        print("Reminder outdated, removed unsuccessfully")
                    }
                }
            }
        } else {
            print("No reminder to delete")
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
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        checkForBulletList()
    }
    
    func textViewDidChange(_ textView: UITextView) {
        checkForBulletList()
        resetTimer()
        EditingData.currentNote.content = field.text
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        //allow user to copy and paste
        //putting "return false" instead of "return true" disables this functionality to some extent
        if text.count > 1 {
            //User did copy & paste because character input is greater than 1
            return true
        }
        
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
        
        //force navigation bar to redraw since color change does not take effect otherwise
        self.navigationController?.isNavigationBarHidden = true
        self.navigationController?.isNavigationBarHidden = false
        
        DataManager.updateNoteColor(color: color, uid: EditingData.currentNote.id) { success in
            //handle success here
        }
        
        colorOverride = ""
    }
    
    //needed for status bar customization when presenting from widget or notification
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return EditingData.currentNote.color.getColor().isDarkColor ? .lightContent : .darkContent
    }
    
    //detect when orientation of view will change -> iPad, not enabled on iPhone
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        field.frame = CGRect(origin: CGPoint(x: 0, y: 0), size: size)
    }
}
