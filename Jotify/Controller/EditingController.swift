//
//  EditingController.swift
//  Jotify
//
//  Created by Harrison Leath on 1/18/21.
//

import UIKit
import Combine

class EditingController: ToolbarViewController, UITextViewDelegate {

    var noteCollection: NoteCollection?

    override var accessoryTintColor: UIColor {
        EditingData.currentNote.color.getColor().isDarkColor ? .white : .black
    }
    
    //store the content value before note is edited
    var initialContent: String?

    private let textChanges = PassthroughSubject<String, Never>()
    private var autoSaveCancellable: AnyCancellable?

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //change status bar style to white when PageBoyController is present
        setStatusBarStyle(style: EditingData.currentNote.color.getColor().isDarkColor ? .lightContent : .darkContent)
        checkIfReminderExpired()
    }

    //life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupNavBar()

        // Combine debounce replaces the old Timer-based idle auto-save.
        // Each keystroke pushes into `textChanges`; if 1s passes with no
        // further input, sink fires and we persist the note. Much cleaner
        // than manually invalidating + rescheduling a Timer on every tap.
        autoSaveCancellable = textChanges
            .debounce(for: .seconds(1), scheduler: RunLoop.main)
            .sink { [weak self] content in
                self?.updateContent(content: content)
            }
    }

    override func configureAccessoryForFirstAppearance() {
        // Applied once `ToolbarViewController` has installed the accessory
        // on first `viewDidAppear`. Hiding items here means the SwiftUI
        // host's initial render already has the right set of buttons —
        // no second pass after the user sees the view.
        keyboardAccessory.setHidden(Self.multilineItemID, true)
        keyboardAccessory.setHidden(Self.saveItemID, true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        updateContent(content: field.text)
        //reset EditingData's current note for reuse
        EditingData.currentNote = FBNote(content: field.text, timestamp: EditingData.currentNote.timestamp, id: EditingData.currentNote.id, color: EditingData.currentNote.color, reminder: nil, reminderTimestamp: nil)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    //view configuration
    func setupView() {
        //color customization to support white/black dynamic type
        view.backgroundColor = EditingData.currentNote.color.getColor()
        field.backgroundColor = EditingData.currentNote.color.getColor()
        field.textColor = EditingData.currentNote.color.getColor().isDarkColor ? .white : .black
        field.tintColor = EditingData.currentNote.color.getColor().isDarkColor ? .white : .black
        
        field.text = EditingData.currentNote.content
        initialContent = EditingData.currentNote.content
        field.delegate = self
        field.font = UIFont.boldSystemFont(ofSize: 18)

        view.addSubview(field)
        
        setupConstraints()
        
        setStatusBarStyle(style: EditingData.currentNote.color.getColor().isDarkColor ? .lightContent : .darkContent)
    }
    
    //setup constraints for multiline textfield
    func setupConstraints() {
        let safeArea = view.safeAreaLayoutGuide
        // Pin the field's bottom to the keyboard accessory's top, not the
        // view bottom. The accessory is pinned to keyboardLayoutGuide.top,
        // so the field automatically resizes as the keyboard slides in and
        // out — no keyboardWillShow/Hide observer or contentInset math
        // required.
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
    
    func setupNavBar() {
        //setup navigationbar elements
        navigationItem.title = EditingData.currentNote.timestamp.getDate()
        configureNavigationBar(bgColor: EditingData.currentNote.color.getColor())
        
        navigationItem.setHidesBackButton(true, animated: false)
        
        // iOS 26 already wraps bar-button images in a glass pill, so use the
        // plain glyph (`xmark`, `ellipsis`) — the system provides the circle.
        let ellipsis = UIBarButtonItem(image: UIImage(systemName: "ellipsis"), style: .plain, target: self, action: #selector(handleCancel))
        let cancel = UIBarButtonItem(image: UIImage(systemName: "xmark"), style: .plain, target: self, action: #selector(handleCancel))
        
        // Let the glyphs use the interface style's label color. iOS 26's
        // Liquid Glass pill wraps the button in a light-ish translucent
        // material regardless of the nav bar color, so matching tint to the
        // *note* color would make the glyph vanish inside the pill.
        ellipsis.tintColor = .label
        cancel.tintColor = .label
        
//        navigationItem.leftBarButtonItems = [ellipsis]
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
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        checkForBulletList()
    }

    func textViewDidChange(_ textView: UITextView) {
        checkForBulletList()
        EditingData.currentNote.content = field.text
        textChanges.send(field.text)
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
        setupToolbar()
        
        DataManager.updateNoteColor(color: color, uid: EditingData.currentNote.id) { success in
            //handle success here
        }
        
        colorOverride = ""
    }
    
    //needed for status bar customization when presenting from widget or notification
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return EditingData.currentNote.color.getColor().isDarkColor ? .lightContent : .darkContent
    }
}
