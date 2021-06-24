//
//  WriteNoteContrller.swift
//  Zurich
//
//  Created by Harrison Leath on 1/12/21.
//

import UIKit

class WriteNoteController: ToolbarViewController, UITextViewDelegate {
    
    //generate random theme
    var theme = ColorManager.themes.randomElement()
    
    //used within timer logic to determine and save current note dynamically
    var hasCreatedDocument = false
    var timer: Timer?
    var documentID: String?
    
    //color assigned to note from gradient
    var noteColor: UIColor = UIColor.black
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        //change status bar style to white
        setStatusBarStyle(style: .lightContent)
    }
    
    //life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        handleSend()
    }
    
    //view configuration
    func setupView() {
        view.setGradient(theme: theme ?? .BlueLagoon)
        noteColor = theme?.colors().randomElement() ?? .bluelagoon1
        
        field.delegate = self
        field.frame = CGRect(x: 0, y: 100, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        view.addSubview(field)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        view.addGestureRecognizer(tap)
    }
    
    //whenever the area around the textView is tapped, bring up the keyboard
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        if field.isFirstResponder {
            field.resignFirstResponder()
        } else {
            field.becomeFirstResponder()
        }
    }
    
    //invalidate timer, reset timer-related variables, and do a final update on the document
    //clean up the UI by emptying the textView and resigning keyboard
    @objc func handleSend() {
        if !field.text.isEmpty {
            DataManager.updateNoteContent(content: field.text, uid: documentID ?? "") { (success) in
                //handle success here
            }
            //stop timer so notes doesn't update outside of this view (WriteNoteController)
            timer?.invalidate()
            //reset hasCreatedDocument so view will be prepared to create another note
            hasCreatedDocument = false
            field.text = ""
            
            //setup color and data for new note creation
            let newTheme = ColorManager.themes.randomElement()
            self.theme = newTheme
            self.noteColor = newTheme?.colors().randomElement() ?? .bluelagoon1
            self.view.setGradient(theme: newTheme ?? .BlueLagoon)
            
            AnalyticsManager.logEvent(named: "note_created", description: "note_created")
        }
        field.resignFirstResponder()
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if (text as NSString).rangeOfCharacter(from: CharacterSet.newlines).location == NSNotFound {
            return true
        }
        
        if isBulletedList {
            field.addBulletOnReturn()
        } else if isMultiline {
            field.addNewLineOnReturn()
        } else {
            handleSend()
        }
        
        return false
    }
    
    //timer functions for "automatically" saving once a user stops typing
    func resetTimer() {
        timer?.invalidate()
        let nextTimer = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(handleIdleEvent), userInfo: nil, repeats: false)
        timer = nextTimer
    }
    
    @objc func handleIdleEvent() {
        if !field.text.isEmpty {
            DataManager.updateNoteContent(content: field.text, uid: documentID ?? "") { (success) in
                //handle success here
            }
        }
    }
    
    //whenever user types, update the document and reset the timer
    func textViewDidChange(_ textView: UITextView) {
        if !hasCreatedDocument {
            documentID = DataManager.createNote(content: field.text, timestamp: Date.timeIntervalSinceReferenceDate, color: noteColor.getNewString())
            hasCreatedDocument = true
        } else if !field.text.isEmpty {
            resetTimer()
        }
    }
    
    override func keyboardSaveNote() {
        handleSend()
    }
    
    //resize the textfield frame each time the window size changes
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        let frame = CGRect(x: 0, y: 100, width: size.width, height: size.height / 4)
        field.frame = frame
    }
    
    //traitcollection: light/dark mode support with status bar
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        setStatusBarStyle(style: .lightContent)
    }
}
