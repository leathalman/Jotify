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

class EditorDemoController: UIViewController {
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
        if wordPressMode {
            textView.load(WordPressPlugin())
        }

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

    fileprivate var currentSelectedAttachment: MediaAttachment?

    let sampleHTML: String?
    let wordPressMode: Bool

    private lazy var optionsTablePresenter = OptionsTablePresenter(presentingViewController: self, presentingTextView: richTextView)

    // MARK: - Lifecycle Methods

    init(withSampleHTML sampleHTML: String? = nil, wordPressMode: Bool) {
        self.sampleHTML = sampleHTML
        self.wordPressMode = wordPressMode

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        sampleHTML = nil
        wordPressMode = false
        super.init(coder: aDecoder)
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        edgesForExtendedLayout = UIRectEdge()
        view.addSubview(editorView)

        // color setup
        view.backgroundColor = .black
        editorView.backgroundColor = .red
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

        let html: String
        if let sampleHTML = sampleHTML {
            html = sampleHTML
        } else {
            html = ""
        }

        editorView.setHTML(html)
//        editorView.becomeFirstResponder()
    }

    @objc func changeFont() {
        editorView.richTextView.defaultFont = UIFont.preferredFont(forTextStyle: .callout)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        let nc = NotificationCenter.default
        nc.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        nc.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // Reanable scroll after setup is done
        editorView.isScrollEnabled = true
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        let nc = NotificationCenter.default
        nc.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        nc.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
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

    // MARK: - Configuration Methods

    override func updateViewConstraints() {
        super.updateViewConstraints()
    }

    private func configureConstraints() {
        NSLayoutConstraint.activate([
            editorView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10),
            editorView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10),
            editorView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            editorView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0)
        ])
    }

    private func configureDefaultProperties(for textView: UITextView, accessibilityLabel: String) {
        textView.accessibilityLabel = accessibilityLabel
        textView.font = Constants.defaultContentFont
        textView.keyboardDismissMode = .interactive
        textView.textColor = Constants.defaultTextColor

        if #available(iOS 13.0, *) {
            if let htmlStorage = textView.textStorage as? HTMLStorage {
                htmlStorage.textColor = UIColor.white
            }
        } else {
            //             Fallback on earlier versions
            textView.textColor = UIColor(red: 0x1A / 255.0, green: 0x1A / 255.0, blue: 0x1A / 255.0, alpha: 1)
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
