//
//  EditorDemo.swift
//  Jotify
//
//  Created by Harrison Leath on 11/7/19.
//  Copyright © 2019 Harrison Leath. All rights reserved.
//

import Aztec
import Gridicons
import UIKit
import WordPressEditor

struct EditingData {
    static var index = Int()
    static var newContent = String()
    static var newDate = Double()
    static var notes = [Note]()
    static var isEditing = Bool()
}

class EditorDemoController: UIViewController {
    var navigationTitle: String = ""
    var backgroundColor: UIColor = .white
    var detailText: String = ""
    var index: Int = 0

    let newDate = Date.timeIntervalSinceReferenceDate
    
//    let writeNoteView = WriteNoteView()

    var datePicker: UIDatePicker = UIDatePicker()

    let defaults = UserDefaults.standard

    var notes: [Note] = []
    var filteredNotes: [Note] = []
    var isFiltering: Bool = false

    var navigationBarHeight = CGFloat()

    fileprivate(set) lazy var formatBar: Aztec.FormatBar = {
        self.createToolbar()
    }()

    private var richTextView: TextView {
        return editorView.richTextView
    }

    private var htmlTextView: UITextView {
        return editorView.htmlTextView
    }

    fileprivate(set) lazy var editorView: Aztec.EditorView = {
        let defaultHTMLFont: UIFont

        defaultHTMLFont = UIFontMetrics.default.scaledFont(for: Constants.defaultContentFont)

        let editorView = Aztec.EditorView(
            defaultFont: Constants.defaultContentFont,
            defaultHTMLFont: defaultHTMLFont,
            defaultParagraphStyle: .default,
            defaultMissingImage: Constants.defaultMissingImage)

        editorView.clipsToBounds = false

        setupHTMLTextView(editorView.htmlTextView)
        setupRichTextView(editorView.richTextView)

        return editorView
    }()

    private func setupRichTextView(_ textView: TextView) {
        let accessibilityLabel = NSLocalizedString("Rich Content", comment: "Post Rich content")
        configureDefaultProperties(for: textView, accessibilityLabel: accessibilityLabel)

        textView.delegate = self
        textView.formattingDelegate = self
        textView.accessibilityIdentifier = "richContentView"
        textView.clipsToBounds = false
        textView.smartDashesType = .no
        textView.smartQuotesType = .no
    }

    private func setupHTMLTextView(_ textView: UITextView) {
        let accessibilityLabel = NSLocalizedString("HTML Content", comment: "Post HTML content")
        configureDefaultProperties(for: textView, accessibilityLabel: accessibilityLabel)

        textView.isHidden = true
        textView.delegate = self
        textView.accessibilityIdentifier = "HTMLContentView"
        textView.autocorrectionType = .no
        textView.autocapitalizationType = .none
        textView.clipsToBounds = false
        textView.adjustsFontForContentSizeCategory = true

        textView.smartDashesType = .no
        textView.smartQuotesType = .no
    }

    // MARK: - viewDidAppear Functions

    func setupPersistentNavigationBar() {
        guard navigationController?.topViewController === self else { return }
        transitionCoordinator?.animate(alongsideTransition: { [weak self] _ in
            self?.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
            self?.navigationController?.navigationBar.shadowImage = UIImage()
            self?.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
            self?.navigationController?.navigationBar.barStyle = .black

            if self?.defaults.bool(forKey: "darkModeEnabled") == true {
                if self?.defaults.bool(forKey: "vibrantDarkModeEnabled") == true {
                    self?.navigationController?.navigationBar.backgroundColor = self?.backgroundColor
                    self?.navigationController?.navigationBar.barTintColor = self?.backgroundColor

                } else if self?.defaults.bool(forKey: "pureDarkModeEnabled") == true {
                    self?.navigationController?.navigationBar.backgroundColor = InterfaceColors.viewBackgroundColor
                    self?.navigationController?.navigationBar.barTintColor = InterfaceColors.viewBackgroundColor
                }

            } else if self?.defaults.bool(forKey: "darkModeEnabled") == false {
                self?.navigationController?.navigationBar.backgroundColor = self?.backgroundColor
                self?.navigationController?.navigationBar.barTintColor = self?.backgroundColor
            }
        }, completion: nil)
    }

    func removeReminderIfDelivered() {
        if checkIfReminderHasBeenDelivered() == true {
            if isFiltering == false {
                notes[index].isReminder = false

            } else if isFiltering == true {
                filteredNotes[index].isReminder = false
            }

            CoreDataManager.shared.enqueue { context in
                do {
                    try context.save()

                } catch let error as NSError {
                    print("Could not save. \(error), \(error.userInfo)")
                }
            }

            UIApplication.shared.applicationIconBadgeNumber -= 1

        } else {
            if isFiltering == false {
                let reminderDate = notes[index].reminderDate ?? "July 1, 2000 at 12:00 AM"
                getReminderDateStringToDisplayForUser(reminderDate: reminderDate)

            } else if isFiltering == true {
                let reminderDate = filteredNotes[index].reminderDate ?? "July 1, 2000 at 12:00 AM"
                getReminderDateStringToDisplayForUser(reminderDate: reminderDate)
            }
        }
    }

    // MARK: - viewDidLoad Functions

    func setupView() {
//        view = writeNoteView
//
//        let textView = writeNoteView.inputTextView

        StoredColors.reminderColor = backgroundColor

//        if defaults.bool(forKey: "darkModeEnabled") == true {
//            if defaults.bool(forKey: "vibrantDarkModeEnabled") == true {
//                writeNoteView.colorView.backgroundColor = backgroundColor
//                textView.backgroundColor = backgroundColor
//            } else if defaults.bool(forKey: "pureDarkModeEnabled") == true {
//                writeNoteView.colorView.backgroundColor = InterfaceColors.viewBackgroundColor
//                textView.backgroundColor = InterfaceColors.viewBackgroundColor
//            }
//
//        } else if defaults.bool(forKey: "darkModeEnabled") == false {
//            writeNoteView.colorView.backgroundColor = backgroundColor
//            textView.backgroundColor = backgroundColor
//        }
//
//        textView.tintColor = .white
//        navigationBarHeight = navigationController?.navigationBar.bounds.height ?? 0
//        textView.frame = CGRect(x: 0, y: 15, width: writeNoteView.screenWidth, height: writeNoteView.screenHeight - navigationBarHeight - 30)
//        textView.text = detailText
//        textView.font = UIFont.boldSystemFont(ofSize: 18)
//        textView.placeholder = ""
//
//        textView.alwaysBounceVertical = true
//        textView.isUserInteractionEnabled = true
//        textView.isScrollEnabled = true
//        textView.isPlaceholderScrollEnabled = true
//        textView.delegate = self

        edgesForExtendedLayout = UIRectEdge()
        view.addSubview(editorView)

        // color setup
        if defaults.bool(forKey: "darkModeEnabled") == true {
            if defaults.bool(forKey: "vibrantDarkModeEnabled") == true {
                view.backgroundColor = backgroundColor
                editorView.backgroundColor = backgroundColor
            } else if defaults.bool(forKey: "pureDarkModeEnabled") == true {
                view.backgroundColor = InterfaceColors.viewBackgroundColor
                editorView.backgroundColor = InterfaceColors.viewBackgroundColor
            }

        } else if defaults.bool(forKey: "darkModeEnabled") == false {
            view.backgroundColor = backgroundColor
            editorView.backgroundColor = backgroundColor
        }
            
        editorView.backgroundColor = backgroundColor
        editorView.richTextView.backgroundColor = .clear
        editorView.htmlTextView.backgroundColor = .clear

        // special colors
        editorView.richTextView.blockquoteBackgroundColor = UIColor.secondarySystemBackground
        editorView.richTextView.preBackgroundColor = UIColor.secondarySystemBackground
        editorView.richTextView.blockquoteBorderColor = UIColor.secondarySystemFill

        var attributes = editorView.richTextView.linkTextAttributes
        attributes?[.foregroundColor] = UIColor.link

        // Don't allow scroll while the constraints are being setup and text set
        editorView.isScrollEnabled = false
        configureConstraints()

        editorView.setHTML(detailText)
        //        editorView.becomeFirstResponder()

        navigationItem.title = navigationTitle
        navigationItem.setHidesBackButton(true, animated: true)

        var cancel = UIImage(named: "cancel")
        cancel = cancel?.withRenderingMode(.alwaysOriginal)
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: cancel, style: .plain, target: self, action: #selector(handleCancel))

        var alarm = UIImage(named: "alarm.fill")
        alarm = alarm?.withRenderingMode(.alwaysOriginal)
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: alarm, style: .plain, target: self, action: #selector(handleReminder))

        hideKeyboardWhenTappedAround()
    }

    func resetNavigationBarForTransition() {
        transitionCoordinator?.animate(alongsideTransition: { [weak self] _ in
            self?.navigationController?.navigationBar.setBackgroundImage(nil, for: UIBarMetrics.default)
            self?.navigationController?.navigationBar.backgroundColor = .white
            self?.navigationController?.navigationBar.barTintColor = .white
            self?.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
        }, completion: nil)
    }

    func setEditingData() {
        EditingData.newDate = newDate
        EditingData.index = index
        EditingData.notes = notes
        // use isEditing to determine if we are on the NoteDetailController
        // if we are, then call function to save data
        EditingData.isEditing = true
    }

    private lazy var optionsTablePresenter = OptionsTablePresenter(presentingViewController: self, presentingTextView: richTextView)

    // MARK: - Lifecycle Methods

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        fetchNotificaitonUUID()
        setupNotifications()
        setupView()
        setEditingData()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)

        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)

        setupPersistentNavigationBar()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        // Reanable scroll after setup is done
        editorView.isScrollEnabled = true

        removeReminderIfDelivered()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        updateContent(index: index, newContent: editorView.richTextView.text, newDate: newDate)

        resetNavigationBarForTransition()
        EditingData.isEditing = false

        let notificationCenter = NotificationCenter.default
        notificationCenter.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        notificationCenter.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        optionsTablePresenter.dismiss()
    }

    func updateScrollInsets() {
        var scrollInsets = editorView.contentInset
        var rightMargin = (view.frame.maxX - editorView.frame.maxX)
        rightMargin -= view.safeAreaInsets.right

        scrollInsets.right = -rightMargin
        editorView.scrollIndicatorInsets = scrollInsets
    }

    @objc func changeFont() {
        editorView.richTextView.defaultFont = UIFont.preferredFont(forTextStyle: .callout)
    }

    // MARK: - Migrated NoteDetailController

    func fetchNotificaitonUUID() {
        if isFiltering == false {
            let notificationUUID = notes[index].notificationUUID ?? ""
            RemindersData.notificationUUID = notificationUUID

        } else if isFiltering == true {
            let notificationUUID = filteredNotes[index].notificationUUID ?? ""
            RemindersData.notificationUUID = notificationUUID
        }
    }

    func getReminderDateStringToDisplayForUser(reminderDate: String) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy hh:mm a"
        let date = dateFormatter.date(from: reminderDate) ?? Date()
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: date)
        let formattedDate = calendar.date(from: components)!

        dateFormatter.dateFormat = "MMMM d, yyyy"
        let firstPartOfDisplayString = dateFormatter.string(from: formattedDate)

        dateFormatter.dateFormat = "h:mm a"
        let secondPartOfDisplayString = dateFormatter.string(from: formattedDate)

        RemindersData.reminderDate = firstPartOfDisplayString + " at " + secondPartOfDisplayString
    }

    func checkIfReminderHasBeenDelivered() -> Bool {
        if isFiltering == false {
            let notificationUUID = notes[index].notificationUUID

            if notificationUUID == "cleared" {
                notes[index].notificationUUID = "cleared"
                return true
            }

            let isReminder = notes[index].isReminder
            RemindersData.isReminder = notes[index].isReminder

            if isReminder == true {
                let reminderDate = notes[index].reminderDate ?? "07/02/2000 11:11 PM"

                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "MM/dd/yyyy hh:mm a"
                let formattedReminderDate = dateFormatter.date(from: reminderDate) ?? Date()

                let currentDate = Date()

                if currentDate >= formattedReminderDate {
                    return true
                } else {
                    return false
                }
            }

        } else if isFiltering == true {
            let notificationUUID = filteredNotes[index].notificationUUID

            if notificationUUID == "cleared" {
                filteredNotes[index].notificationUUID = "cleared"
                return true
            }

            let isReminder = filteredNotes[index].isReminder
            RemindersData.isReminder = filteredNotes[index].isReminder

            if isReminder == true {
                let reminderDate = filteredNotes[index].reminderDate ?? "07/02/2000 11:11 PM"

                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "MM/dd/yyyy hh:mm a"
                let formattedReminderDate = dateFormatter.date(from: reminderDate) ?? Date()

                let currentDate = Date()

                if currentDate >= formattedReminderDate {
                    return true
                } else {
                    return false
                }
            }
        }

        return false
    }

    @objc func handleReminder() {
        let savedNoteController = SavedNoteController()
        savedNoteController.feedbackOnPress()

        if RemindersData.isReminder == false || RemindersData.reminderDate == "" {
            reminderIsNotSet()
        } else {
            alreadySetReminder()
        }
    }

    func alreadySetReminder() {
        print("Already set a reminder")

        // pass note data so that ReminderExistsController can directly edit the CoreData object
        let reminderExistsController = ReminderExistsController()
        reminderExistsController.index = index
        reminderExistsController.notes = notes
        reminderExistsController.filteredNotes = filteredNotes
        reminderExistsController.isFiltering = isFiltering

        present(reminderExistsController, animated: true, completion: nil)
    }

    func reminderIsNotSet() {
        let reminderController = ReminderController()

        if isFiltering == true {
            reminderController.filteredNotes = filteredNotes
            reminderController.isFiltering = true

        } else {
            reminderController.notes = notes
        }

        reminderController.index = index
        reminderController.reminderBodyText = editorView.richTextView.text
        requestNotificationPermission()
        present(reminderController, animated: true, completion: nil)
    }

    @objc func handleCancel() {
        let savedNoteController = SavedNoteController()
        savedNoteController.feedbackOnPress()
        navigationController?.popViewController(animated: true)
    }

    func requestNotificationPermission() {
        let center = UNUserNotificationCenter.current()

        center.requestAuthorization(options: [.alert, .badge, .sound]) { granted, _ in
            if granted {
                // print("Notifications granted")
            } else {
                // print("Notifications denied")
            }
        }
    }

    func updateContent(index: Int, newContent: String, newDate: Double) {
        if isFiltering == false {
            notes[index].content = newContent
            notes[index].modifiedDate = newDate

        } else if isFiltering == true {
            filteredNotes[index].content = newContent
            filteredNotes[index].modifiedDate = newDate
        }

        CoreDataManager.shared.enqueue { context in
            do {
                try context.save()

            } catch let error as NSError {
                print("Could not save. \(error), \(error.userInfo)")
            }
        }
    }

    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        // set newContent everytime character is changed
        EditingData.newContent = textView.text

        return true
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

        let navigationBarHeight = navigationController!.navigationBar.frame.height

        if notification.name == UIResponder.keyboardWillHideNotification {
            editorView.richTextView.contentInset = .zero

        } else {
            editorView.richTextView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height + navigationBarHeight + 42, right: 0)
        }

        editorView.richTextView.scrollIndicatorInsets = editorView.richTextView.contentInset

        let selectedRange = editorView.richTextView.selectedRange
        editorView.richTextView.scrollRangeToVisible(selectedRange)
    }

    // MARK: - Configuration Methods

    override func updateViewConstraints() {
        super.updateViewConstraints()
    }

    private func configureConstraints() {
        NSLayoutConstraint.activate([
            editorView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10),
            editorView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10),
            editorView.topAnchor.constraint(equalTo: view.topAnchor, constant: 10),
            editorView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0)
        ])
    }

    private func configureDefaultProperties(for textView: UITextView, accessibilityLabel: String) {
        textView.accessibilityLabel = accessibilityLabel
        textView.font = Constants.defaultContentFont
        textView.keyboardDismissMode = .interactive
        textView.textColor = Constants.defaultTextColor
        
        if let htmlStorage = textView.textStorage as? HTMLStorage {
                htmlStorage.textColor = UIColor.white
            }
    }

    // MARK: - Helpers

    private func toggleEditingMode() {
        formatBar.overflowToolbar(expand: true)
        editorView.toggleEditingMode()
    }

    // MARK: - Options VC

    private let formattingIdentifiersWithOptions: [FormattingIdentifier] = [.orderedlist, .unorderedlist, .p, .header1, .header2, .header3, .header4, .header5, .header6]

    private func formattingIdentifierHasOptions(_ formattingIdentifier: FormattingIdentifier) -> Bool {
        return formattingIdentifiersWithOptions.contains(formattingIdentifier)
    }

    // MARK: - Keyboard Handling

    @objc func keyboardWillShow(_ notification: Notification) {
        guard let userInfo = notification.userInfo as? [String: AnyObject],
            let keyboardFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
            return
        }

        refreshInsets(forKeyboardFrame: keyboardFrame)
    }

    @objc func keyboardWillHide(_ notification: Notification) {
        guard let userInfo = notification.userInfo as? [String: AnyObject],
            let keyboardFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
            return
        }

        refreshInsets(forKeyboardFrame: keyboardFrame)
        optionsTablePresenter.dismiss()
    }

    fileprivate func refreshInsets(forKeyboardFrame keyboardFrame: CGRect) {
        // The reason why we're converting the keyboard coordinates instead of just using
        // keyboardFrame.height, is that we need to make sure the insets take into account the
        // possibility that there could be other views on top or below the text view.
        // keyboardInset is basically the distance between the top of the keyboard
        // and the bottom of the text view.
        let localKeyboardOrigin = view.convert(keyboardFrame.origin, from: nil)
        let keyboardInset = max(view.frame.height - localKeyboardOrigin.y, 0)

        let contentInset = UIEdgeInsets(
            top: editorView.contentInset.top,
            left: 0,
            bottom: keyboardInset,
            right: 0)

        editorView.contentInset = contentInset
        updateScrollInsets()
    }

    func updateFormatBar() {
        guard let toolbar = richTextView.inputAccessoryView as? Aztec.FormatBar else {
            return
        }

        let identifiers: Set<FormattingIdentifier>
        if richTextView.selectedRange.length > 0 {
            identifiers = richTextView.formattingIdentifiersSpanningRange(richTextView.selectedRange)
        } else {
            identifiers = richTextView.formattingIdentifiersForTypingAttributes()
        }

        toolbar.selectItemsMatchingIdentifiers(identifiers.map { $0.rawValue })
    }

    // MARK: - Sample Content

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        if richTextView.resignFirstResponder() {
            richTextView.becomeFirstResponder()
        }

        if htmlTextView.resignFirstResponder() {
            htmlTextView.becomeFirstResponder()
        }
    }
}

extension EditorDemoController: UITextViewDelegate {
    func textViewDidChangeSelection(_ textView: UITextView) {
        updateFormatBar()
        changeRichTextInputView(to: nil)
    }

    func textViewDidChange(_ textView: UITextView) {
        switch textView {
        case richTextView:
            updateFormatBar()
        default:
            break
        }
    }

    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        switch textView {
        case richTextView:
            formatBar.enabled = true
        case htmlTextView:
            formatBar.enabled = false

            // Disable the bar, except for the source code button
            let htmlButton = formatBar.items.first(where: { $0.identifier == FormattingIdentifier.sourcecode.rawValue })
            htmlButton?.isEnabled = true
        default: break
        }

        textView.inputAccessoryView = formatBar

        return true
    }

    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        return false
    }

//    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
//        if (text as NSString).rangeOfCharacter(from: CharacterSet.newlines).location == NSNotFound {
//            return true
//        }
//
//        if text == "\n" {
//            textView.text = textView.text + "\n"
//        }
//        print("TAPPED")
//
//        return false
//    }
}

extension EditorDemoController: Aztec.TextViewFormattingDelegate {
    func textViewCommandToggledAStyle() {
        updateFormatBar()
    }
}

extension EditorDemoController: UITextFieldDelegate {}

extension EditorDemoController {
    enum EditMode {
        case richText
        case html

        mutating func toggle() {
            switch self {
            case .html:
                self = .richText
            case .richText:
                self = .html
            }
        }
    }
}

// MARK: - Format Bar Delegate

extension EditorDemoController: Aztec.FormatBarDelegate {
    func formatBarTouchesBegan(_ formatBar: FormatBar) {}

    func formatBar(_ formatBar: FormatBar, didChangeOverflowState state: FormatBarOverflowState) {
        switch state {
        case .hidden:
            print("Format bar collapsed")
        case .visible:
            print("Format bar expanded")
        }
    }
}

// MARK: - Format Bar Actions

extension EditorDemoController {
    func handleAction(for barItem: FormatBarItem) {
        guard let identifier = barItem.identifier,
            let formattingIdentifier = FormattingIdentifier(rawValue: identifier) else {
            return
        }

        if !formattingIdentifierHasOptions(formattingIdentifier) {
            optionsTablePresenter.dismiss()
        }

        switch formattingIdentifier {
        case .bold:
            toggleBold()
        case .italic:
            toggleItalic()
        case .underline:
            toggleUnderline()
        case .strikethrough:
            toggleStrikethrough()
        case .blockquote:
            toggleBlockquote()
        case .unorderedlist, .orderedlist:
            toggleList(fromItem: barItem)
        case .media:
            break
        case .sourcecode:
            toggleEditingMode()
        case .p, .header1, .header2, .header3, .header4, .header5, .header6:
            toggleHeader(fromItem: barItem)
        case .more:
            insertMoreAttachment()
        case .horizontalruler:
            insertHorizontalRuler()
        case .code:
            toggleCode()
        default:
            break
        }

        updateFormatBar()
    }

    @objc func toggleBold() {
        richTextView.toggleBold(range: richTextView.selectedRange)
    }

    @objc func toggleItalic() {
        richTextView.toggleItalic(range: richTextView.selectedRange)
    }

    func toggleUnderline() {
        richTextView.toggleUnderline(range: richTextView.selectedRange)
    }

    @objc func toggleStrikethrough() {
        richTextView.toggleStrikethrough(range: richTextView.selectedRange)
    }

    @objc func toggleBlockquote() {
        richTextView.toggleBlockquote(range: richTextView.selectedRange)
    }

    @objc func toggleCode() {
        richTextView.toggleCode(range: richTextView.selectedRange)
    }

    func insertHorizontalRuler() {
        richTextView.replaceWithHorizontalRuler(at: richTextView.selectedRange)
    }

    func toggleHeader(fromItem item: FormatBarItem) {
        guard !optionsTablePresenter.isOnScreen() else {
            optionsTablePresenter.dismiss()
            return
        }

        let options = Constants.headers.map { headerType -> OptionsTableViewOption in
            let attributes: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: CGFloat(headerType.fontSize))
            ]

            let title = NSAttributedString(string: headerType.description, attributes: attributes)
            return OptionsTableViewOption(image: headerType.iconImage, title: title)
        }

        let selectedIndex = Constants.headers.firstIndex(of: headerLevelForSelectedText())
        let optionsTableViewController = OptionsTableViewController(options: options)
        optionsTableViewController.cellDeselectedTintColor = .gray

        optionsTablePresenter.present(
            optionsTableViewController,
            fromBarItem: item,
            selectedRowIndex: selectedIndex,
            onSelect: { [weak self] selected in
                guard let range = self?.richTextView.selectedRange else {
                    return
                }

                self?.richTextView.toggleHeader(Constants.headers[selected], range: range)
                self?.optionsTablePresenter.dismiss()
        })
    }

    func toggleList(fromItem item: FormatBarItem) {
        guard !optionsTablePresenter.isOnScreen() else {
            optionsTablePresenter.dismiss()
            return
        }

        let options = Constants.lists.map { (listType) -> OptionsTableViewOption in
            OptionsTableViewOption(image: listType.iconImage, title: NSAttributedString(string: listType.description, attributes: [:]))
        }

        var index: Int?
        if let listType = listTypeForSelectedText() {
            index = Constants.lists.firstIndex(of: listType)
        }

        let optionsTableViewController = OptionsTableViewController(options: options)
        optionsTableViewController.cellDeselectedTintColor = .gray

        optionsTablePresenter.present(
            optionsTableViewController,
            fromBarItem: item,
            selectedRowIndex: index,
            onSelect: { [weak self] selected in
                guard let range = self?.richTextView.selectedRange else { return }

                let listType = Constants.lists[selected]
                switch listType {
                case .unordered:
                    self?.richTextView.toggleUnorderedList(range: range)
                case .ordered:
                    self?.richTextView.toggleOrderedList(range: range)
                }

                self?.optionsTablePresenter.dismiss()
        })
    }

    @objc func toggleUnorderedList() {
        richTextView.toggleUnorderedList(range: richTextView.selectedRange)
    }

    @objc func toggleOrderedList() {
        richTextView.toggleOrderedList(range: richTextView.selectedRange)
    }

    func changeRichTextInputView(to: UIView?) {
        if richTextView.inputView == to {
            return
        }

        richTextView.inputView = to
        richTextView.reloadInputViews()
    }

    func headerLevelForSelectedText() -> Header.HeaderType {
        var identifiers = Set<FormattingIdentifier>()
        if richTextView.selectedRange.length > 0 {
            identifiers = richTextView.formattingIdentifiersSpanningRange(richTextView.selectedRange)
        } else {
            identifiers = richTextView.formattingIdentifiersForTypingAttributes()
        }
        let mapping: [FormattingIdentifier: Header.HeaderType] = [
            .header1: .h1,
            .header2: .h2,
            .header3: .h3,
            .header4: .h4,
            .header5: .h5,
            .header6: .h6
        ]
        for (key, value) in mapping {
            if identifiers.contains(key) {
                return value
            }
        }
        return .none
    }

    func listTypeForSelectedText() -> TextList.Style? {
        var identifiers = Set<FormattingIdentifier>()
        if richTextView.selectedRange.length > 0 {
            identifiers = richTextView.formattingIdentifiersSpanningRange(richTextView.selectedRange)
        } else {
            identifiers = richTextView.formattingIdentifiersForTypingAttributes()
        }
        let mapping: [FormattingIdentifier: TextList.Style] = [
            .orderedlist: .ordered,
            .unorderedlist: .unordered
        ]
        for (key, value) in mapping {
            if identifiers.contains(key) {
                return value
            }
        }

        return nil
    }

    func insertMoreAttachment() {
        richTextView.replace(richTextView.selectedRange, withComment: Constants.moreAttachmentText)
    }

    @objc func tabOnTitle() {
        if editorView.becomeFirstResponder() {
            editorView.selectedTextRange = editorView.htmlTextView.textRange(from: editorView.htmlTextView.endOfDocument, to: editorView.htmlTextView.endOfDocument)
        }
    }

    func makeToolbarButton(identifier: FormattingIdentifier) -> FormatBarItem {
        let button = FormatBarItem(image: identifier.iconImage, identifier: identifier.rawValue)
        return button
    }

    func createToolbar() -> Aztec.FormatBar {
//        let mediaItem = makeToolbarButton(identifier: .media)
        let scrollableItems = scrollableItemsForToolbar
        let overflowItems = overflowItemsForToolbar

        let toolbar = Aztec.FormatBar()

        toolbar.backgroundColor = UIColor.systemGroupedBackground
        toolbar.tintColor = UIColor.secondaryLabel
        toolbar.highlightedTintColor = UIColor.systemBlue
        toolbar.selectedTintColor = UIColor.systemBlue
        toolbar.disabledTintColor = .systemGray4
        toolbar.dividerTintColor = UIColor.separator

        toolbar.overflowToggleIcon = Gridicon.iconOfType(.ellipsis)
        toolbar.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 44.0)
        toolbar.autoresizingMask = [.flexibleHeight]
        toolbar.formatter = self

//        toolbar.leadingItem = mediaItem
        toolbar.setDefaultItems(
            scrollableItems,
            overflowItems: overflowItems)

        toolbar.barItemHandler = { [weak self] item in
            self?.handleAction(for: item)
        }

        return toolbar
    }

    var scrollableItemsForToolbar: [FormatBarItem] {
        let headerButton = makeToolbarButton(identifier: .p)

        var alternativeIcons = [String: UIImage]()
        let headings = Constants.headers.suffix(from: 1) // Remove paragraph style
        for heading in headings {
            alternativeIcons[heading.formattingIdentifier.rawValue] = heading.iconImage
        }

        headerButton.alternativeIcons = alternativeIcons

        let listButton = makeToolbarButton(identifier: .unorderedlist)
        var listIcons = [String: UIImage]()
        for list in Constants.lists {
            listIcons[list.formattingIdentifier.rawValue] = list.iconImage
        }

        listButton.alternativeIcons = listIcons

        return [
            headerButton,
            listButton,
            makeToolbarButton(identifier: .bold),
            makeToolbarButton(identifier: .italic),
            makeToolbarButton(identifier: .underline)
        ]
    }

    var overflowItemsForToolbar: [FormatBarItem] {
        return [
            makeToolbarButton(identifier: .blockquote),
            makeToolbarButton(identifier: .strikethrough),
            makeToolbarButton(identifier: .code),
            makeToolbarButton(identifier: .horizontalruler),
            makeToolbarButton(identifier: .sourcecode)
        ]
    }
}

extension EditorDemoController {
    struct Constants {
        static let defaultContentFont = UIFont.boldSystemFont(ofSize: 18)
        static let defaultHtmlFont = UIFont.boldSystemFont(ofSize: 18)
        static let defaultMissingImage = Gridicon.iconOfType(.image)
        static let formatBarIconSize = CGSize(width: 20.0, height: 20.0)
        static let headers = [Header.HeaderType.none, .h1, .h2, .h3, .h4, .h5, .h6]
        static let lists = [TextList.Style.unordered, .ordered]
        static let moreAttachmentText = "more"
        static let defaultTextColor = UIColor.white
    }
}

extension FormattingIdentifier {
    var iconImage: UIImage {
        switch self {
        case .media:
            return gridicon(.addOutline)
        case .p:
            return gridicon(.heading)
        case .bold:
            return gridicon(.bold)
        case .italic:
            return gridicon(.italic)
        case .underline:
            return gridicon(.underline)
        case .strikethrough:
            return gridicon(.strikethrough)
        case .blockquote:
            return gridicon(.quote)
        case .orderedlist:
            return gridicon(.listOrdered)
        case .unorderedlist:
            return gridicon(.listUnordered)
        case .horizontalruler:
            return gridicon(.minusSmall)
        case .sourcecode:
            return gridicon(.code)
        case .more:
            return gridicon(.readMore)
        case .header1:
            return gridicon(.headingH1)
        case .header2:
            return gridicon(.headingH2)
        case .header3:
            return gridicon(.headingH3)
        case .header4:
            return gridicon(.headingH4)
        case .header5:
            return gridicon(.headingH5)
        case .header6:
            return gridicon(.headingH6)
        case .code:
            return gridicon(.posts)
        default:
            return gridicon(.help)
        }
    }

    private func gridicon(_ gridiconType: GridiconType) -> UIImage {
        let size = EditorDemoController.Constants.formatBarIconSize
        return Gridicon.iconOfType(gridiconType, withSize: size)
    }
}

// MARK: - Header and List presentation extensions

private extension Header.HeaderType {
    var formattingIdentifier: FormattingIdentifier {
        switch self {
        case .none: return FormattingIdentifier.p
        case .h1: return FormattingIdentifier.header1
        case .h2: return FormattingIdentifier.header2
        case .h3: return FormattingIdentifier.header3
        case .h4: return FormattingIdentifier.header4
        case .h5: return FormattingIdentifier.header5
        case .h6: return FormattingIdentifier.header6
        }
    }

    var description: String {
        switch self {
        case .none: return NSLocalizedString("Default", comment: "Description of the default paragraph formatting style in the editor.")
        case .h1: return "Heading 1"
        case .h2: return "Heading 2"
        case .h3: return "Heading 3"
        case .h4: return "Heading 4"
        case .h5: return "Heading 5"
        case .h6: return "Heading 6"
        }
    }

    var iconImage: UIImage? {
        return formattingIdentifier.iconImage
    }
}

private extension TextList.Style {
    var formattingIdentifier: FormattingIdentifier {
        switch self {
        case .ordered: return FormattingIdentifier.orderedlist
        case .unordered: return FormattingIdentifier.unorderedlist
        }
    }

    var description: String {
        switch self {
        case .ordered: return "Ordered List"
        case .unordered: return "Unordered List"
        }
    }

    var iconImage: UIImage? {
        return formattingIdentifier.iconImage
    }
}
