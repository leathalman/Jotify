//
//  WriteNoteContrller.swift
//  Zurich
//
//  Created by Harrison Leath on 1/12/21.
//

import UIKit
import Combine

class WriteNoteController: ToolbarViewController, UITextViewDelegate {

    //generate random theme
    var theme = ColorManager.themes.randomElement()

    var hasCreatedDocument = false
    var documentID: String?

    //color assigned to note from gradient
    var noteColor: UIColor = UIColor.black

    private let textChanges = PassthroughSubject<String, Never>()
    private var autoSaveCancellable: AnyCancellable?

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //change status bar style to white
        setStatusBarStyle(style: .lightContent)

        //show the most recent placeholder
        field.text = UserDefaults.standard.string(forKey: "placeholder")
    }

    //life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        resetAutoSave()
    }

    /// (Re)install the 1-second idle auto-save pipeline. Called in
    /// `viewDidLoad` and again inside `handleSend` — reassigning
    /// `autoSaveCancellable` cancels the previous subscription, dropping
    /// any pending debounced value so a late save can't write old text to
    /// the fresh note that replaces the just-sent one.
    private func resetAutoSave() {
        autoSaveCancellable = textChanges
            .debounce(for: .seconds(1), scheduler: RunLoop.main)
            .sink { [weak self] content in
                self?.saveIfReady(content: content)
            }
    }

    private func saveIfReady(content: String) {
        guard !content.isEmpty, field.textColor == .white else { return }
        DataManager.updateNoteContent(content: content, uid: documentID ?? "") { _ in }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
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
            
            //reset the idle auto-save pipeline so any debounced value
            //pending from the just-sent note doesn't fire against the new
            //(blank) note we're about to create.
            resetAutoSave()
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
            
            AnalyticsManager.logEvent(named: "note_created", description: "note_created")
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
            reminderButtonEnabled = false
            setupToolbar()
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
            //used to dictate whether NoteCollection should use client or server version of most recent note
            EditingData.firstNote = true
            hasCreatedDocument = true
        } else if !field.text.isEmpty && field.textColor == .white {
            updateEditingData()
            textChanges.send(field.text)
        }
        
        //re-enable reminder button now that user is typing
        if field.text != "" {
            reminderButtonEnabled = true
            setupToolbar()
        }
    }
    
    //update UI to new color chosen from ColorGallery
    override func updateColorOverride(color: String) {
        colorOverride = color
        view.removeGradient()
        view.backgroundColor = color.getColor()
    }
    
    //setup constraints for multiline textfield
    func setupConstraints() {
        let safeArea = view.safeAreaLayoutGuide
        // Same pattern as EditingController: pin field.bottom to the keyboard
        // accessory's top so the text view auto-resizes with the keyboard.
        if UIDevice.current.userInterfaceIdiom == .pad {
            field.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            field.topAnchor.constraint(equalTo: safeArea.topAnchor).isActive = true
            field.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.75).isActive = true
            field.bottomAnchor.constraint(equalTo: keyboardAccessory.topAnchor).isActive = true
        } else if UIDevice.current.userInterfaceIdiom == .phone {
            field.topAnchor.constraint(equalTo: safeArea.topAnchor).isActive = true
            field.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
            field.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
            field.bottomAnchor.constraint(equalTo: keyboardAccessory.topAnchor).isActive = true
        }
    }
    
    func updateEditingData() {
        EditingData.currentNote.content = field.text
    }
    
    override func keyboardSaveNote() {
        handleSend()
    }
    
    //traitcollection: light/dark mode support with status bar
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        setStatusBarStyle(style: .lightContent)
    }
    
    //detect when orientation of view will change -> iPad, not enabled on iPhone
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        //make sure gradient view resizes properly
        view.gradientAnimator?.frame = CGRect(origin: .zero, size: size)
    }
}
