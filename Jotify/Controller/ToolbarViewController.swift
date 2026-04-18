//
//  ToolbarViewController.swift
//  Jotify
//
//  Created by Harrison Leath on 6/21/21.
//

import UIKit
import SPIndicator
import SPPermissions
import SPPermissionsNotification

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

    // Identifiers for the keyboard accessory items, so subclasses can
    // hide/enable a specific button without poking at array indices.
    static let multilineItemID = "multiline"
    static let listItemID = "list"
    static let timerItemID = "timer"
    static let colorPickerItemID = "colorpicker"
    static let saveItemID = "save"

    lazy var field: UITextView = {
        let f = UITextView()
        f.backgroundColor = .clear
        f.textColor = .white
        f.tintColor = .white
        f.isEditable = true
        f.text = "Tap to start typing or swipe left to right for saved notes..."
        f.font = UIFont.boldSystemFont(ofSize: 32)
        f.textContainerInset = UIEdgeInsets(top: 10, left: 15, bottom: 10, right: 15)
        f.translatesAutoresizingMaskIntoConstraints = false
        return f
    }()

    let keyboardAccessory = KeyboardAccessoryView()
    
    var isBulletedList: Bool = false
    var isMultiline: Bool = false
    
    let placeholder: String = "Start typing or swipe right for saved notes..."
    
    //observe a color chosen through ColorGallery
    var colorOverride = ""
    
    var reminderButtonEnabled = true

    /// Subclasses override to contrast against the note's background color.
    /// Defaults to `.label` which adapts to light/dark mode.
    var accessoryTintColor: UIColor { .label }

    /// Guard so the accessory's item model is only built once.
    private var didPopulateAccessory = false

    override func viewDidLoad() {
        super.viewDidLoad()
        isMultiline = UserDefaults.standard.bool(forKey: "multilineInputEnabled")
        // Add the accessory view to the hierarchy now so subclasses can
        // anchor their text field to `keyboardAccessory.topAnchor` in
        // `setupConstraints`. This only creates a plain UIView — the
        // expensive SwiftUI `UIHostingController` inside it isn't spun up
        // until the first `setItems` call.
        installKeyboardAccessory()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // First `setItems` triggers the SwiftUI host instantiation +
        // render — ~20–80ms on the main thread on iOS 26. Running that in
        // `viewDidLoad` landed it between the tap and the push animation,
        // producing the visible lag before the detail view appeared. The
        // bar isn't visible until the keyboard rises anyway, so populate
        // it after the transition completes.
        guard !didPopulateAccessory else { return }
        didPopulateAccessory = true
        setupToolbar()
        configureAccessoryForFirstAppearance()
    }

    /// Subclasses override to tweak the accessory (hide items, etc.) after
    /// the bar has been populated. Runs once, on first `viewDidAppear`.
    func configureAccessoryForFirstAppearance() { }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Subclasses add their `field` after super.viewDidLoad, so the
        // accessory bar ends up below the field in z-order. Bring it forward
        // here so it stays visible once everything is laid out.
        view.bringSubviewToFront(keyboardAccessory)
    }

    /// Pin the accessory bar to the view's keyboard layout guide. The guide
    /// tracks the keyboard's top edge automatically and animates in lockstep
    /// with the system keyboard — no manual frame math, no
    /// keyboardWillShow/Hide observers, no contentInset calculations.
    /// Subclasses should pin their text field's `bottomAnchor` to
    /// `keyboardAccessory.topAnchor` to get the text view sized correctly.
    private func installKeyboardAccessory() {
        guard keyboardAccessory.superview == nil else { return }
        view.addSubview(keyboardAccessory)
        NSLayoutConstraint.activate([
            keyboardAccessory.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            keyboardAccessory.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            keyboardAccessory.bottomAnchor.constraint(equalTo: view.keyboardLayoutGuide.topAnchor)
        ])
    }
    
    //toolbar UI setup
    func setupToolbar() {
        let multilineImage = isMultiline
            ? UIImage(systemName: "line.horizontal.2.decrease.circle.fill")
            : UIImage(systemName: "line.horizontal.2.decrease.circle")

        keyboardAccessory.setItems([
            .init(identifier: Self.multilineItemID, image: multilineImage,
                  action: { [weak self] in self?.toggleMultilineInput() }),
            .init(identifier: Self.listItemID,
                  image: UIImage(systemName: "list.bullet"),
                  action: { [weak self] in self?.addBullet() }),
            .init(identifier: Self.timerItemID,
                  image: UIImage(systemName: "timer"),
                  action: { [weak self] in self?.showReminderController() }),
            .init(identifier: Self.colorPickerItemID,
                  image: UIImage(systemName: "eyedropper"),
                  action: { [weak self] in self?.showColorGalleryController() }),
            .init(identifier: Self.saveItemID,
                  image: UIImage(systemName: "arrow.down.to.line.circle"),
                  action: { [weak self] in self?.keyboardSaveNote() })
        ])

        keyboardAccessory.setEnabled(Self.timerItemID, reminderButtonEnabled)
        keyboardAccessory.setTintColor(Self.timerItemID,
                                       reminderButtonEnabled ? nil : .gray)
        keyboardAccessory.tintColor = accessoryTintColor
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
        if (User.settings?.hasPremium ?? false) {
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
        } else {
            let premiumVC = BuyPremiumController()
            premiumVC.titleText.text = "Reminders are essential."
            present(premiumVC, animated: true)
        }
    }
    
    @objc func showColorGalleryController() {
        if (User.settings?.hasPremium ?? false) {
            let gallery = ColorGalleryController(style: .insetGrouped)
            gallery.delegate = self
            present(gallery, animated: true, completion: nil)
        } else {
            let premiumVC = BuyPremiumController()
            premiumVC.titleText.text = "Want to Change Color?"
            present(premiumVC, animated: true)
        }
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
    
}
