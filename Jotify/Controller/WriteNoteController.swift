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
        super.viewWillAppear(animated)
        //change status bar style to white
        setStatusBarStyle(style: .lightContent)

        //show the most recent placeholder, but never over a draft in progress
        //(a cancelled page swipe can call this while the user is mid-note)
        if field.textColor != .white {
            field.text = UserDefaults.standard.string(forKey: "placeholder")
        }
    }
    
    //life cycle
    override func viewDidLoad() {
        let vdlID = Signposts.begin("WriteNote.viewDidLoad")
        defer { Signposts.end("WriteNote.viewDidLoad", id: vdlID) }
        super.viewDidLoad()
        Signposts.measure("WriteNote.setupView") { setupView() }
    }
    
    // Save in viewDidDisappear, not viewWillDisappear: the pager calls
    // viewWillDisappear as soon as an interactive swipe *starts*, so a swipe
    // the user cancels used to send the draft, clear the field, swap the
    // gradient and drop the keyboard. viewDidDisappear only fires once the
    // page has actually changed.
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        handleSend()
    }
    
    //view configuration
    func setupView() {
        view.setGradient(theme: theme ?? .olympia)
        noteColor = theme?.colors().randomElement() ?? .olympia1
        
        field.delegate = self
        view.addSubview(field)
        
        //manually handle placeholder
        field.textColor = .almostWhite
        
        setupConstraints()
    }
    
    //invalidate timer, reset timer-related variables, and do a final update on the document
    //clean up the UI by emptying the textView and resigning keyboard
    @objc func handleSend() {
        if !field.text.isEmpty && field.textColor == .white {
            DataManager.updateNoteContent(content: field.text, uid: documentID ?? "") { (success) in
                //handle success here
            }
            
            if colorOverride != "" {
                DataManager.updateNoteColor(color: colorOverride, uid: documentID ?? "") { success in
                    //handle success here
                    print("color overriden from selection")
                    print("Color override is \(self.colorOverride)")
                }
                colorOverride = ""
            }
            
            //stop timer so notes doesn't update outside of this view (WriteNoteController)
            timer?.invalidate()
            //reset hasCreatedDocument so view will be prepared to create another note
            hasCreatedDocument = false
            
            //manually replace the placeholder to fix bug when pasting text then calling handleSend
            field.text = placeholder
            field.textColor = .almostWhite
            
            //removed bulleted list from next note
            if isBulletedList {
                isBulletedList = false
            }
            
            //setup color and data for new note creation
            let newTheme = ColorManager.themes.randomElement()
            self.theme = newTheme
            self.noteColor = newTheme?.colors().randomElement() ?? .olympia1
            self.view.setGradient(theme: newTheme ?? .olympia)
            
            field.text = UserDefaults.standard.string(forKey: "placeholder")
            
        }
        field.resignFirstResponder()
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if (text as NSString).rangeOfCharacter(from: CharacterSet.newlines).location == NSNotFound {
            return true
        }
        
        if isBulletedList && isMultiline {
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
        let nextTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(handleIdleEvent), userInfo: nil, repeats: false)
        timer = nextTimer
    }
    
    @objc func handleIdleEvent() {
        if !field.text.isEmpty && field.textColor == .white {
            DataManager.updateNoteContent(content: field.text, uid: documentID ?? "") { (success) in
                //handle success here
            }
        }
    }
    
    //remove the placeholder when user begins to edit the TextView
    func textViewDidBeginEditing(_ textView: UITextView) {
        checkForBulletList()
        if field.textColor == .almostWhite {
            field.text = ""
            field.textColor = .white
        }
        
        //disable reminder button when first editing field
        //field should be empty since user input hasn't happened yet
        if field.text == "" {
            setReminderButtonEnabled(false)
        }
    }
    
    //add placeholder back when user is done editing
    func textViewDidEndEditing(_ textView: UITextView) {
        if field.text.isEmpty {
            field.text = placeholder
            field.textColor = .almostWhite
        }
    }
    
    //whenever user types, update the document and reset the timer
    func textViewDidChange(_ textView: UITextView) {
        checkForBulletList()
        if !hasCreatedDocument {
            documentID = DataManager.createNote(content: field.text, timestamp: Date.timeIntervalSinceReferenceDate, color: noteColor.getString())
            EditingData.currentNote = FBNote(content: field.text, timestamp: Date.timeIntervalSinceReferenceDate, id: documentID ?? "", color: noteColor.getString(), reminder: nil, reminderTimestamp: nil)
            hasCreatedDocument = true
        } else if !field.text.isEmpty && field.textColor == .white {
            updateEditingData()
            resetTimer()
        }
        
        //re-enable reminder button now that user is typing
        if field.text != "" {
            setReminderButtonEnabled(true)
        }
    }

    //only rebuild the keyboard bar when the state actually flips; this ran
    //setupToolbar() on every keystroke, rebuilding the SwiftUI bar ~3 times
    //per character
    private func setReminderButtonEnabled(_ enabled: Bool) {
        guard reminderButtonEnabled != enabled else { return }
        reminderButtonEnabled = enabled
        setupToolbar()
    }
    
    //update UI to new color chosen from ColorGallery
    override func updateColorOverride(color: String) {
        colorOverride = color
        view.removeGradient()
        view.backgroundColor = color.getColor()
    }
    
    //setup constraints for multiline textfield
    func setupConstraints() {
        if UIDevice.current.userInterfaceIdiom == .pad {
            field.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            field.topAnchor.constraint(equalTo: view.topAnchor, constant: 100).isActive = true
            field.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
            field.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.75).isActive = true
        } else if UIDevice.current.userInterfaceIdiom == .phone {
            field.topAnchor.constraint(equalTo: view.topAnchor, constant: 100).isActive = true
            field.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
            field.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
            field.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        }
    }
    
    func updateEditingData() {
        EditingData.currentNote.content = field.text
    }
    
    override func keyboardSaveNote() {
        handleSend()
    }
}
