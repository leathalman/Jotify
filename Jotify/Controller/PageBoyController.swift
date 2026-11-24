//
//  PageBoyController.swift
//  Jotify
//
//  Created by Harrison Leath on 4/25/21.
//

import UIKit
import FirebaseFirestore
import AuthenticationServices
import os

/// The app's root: a native horizontal pager with the Notes list on the
/// left and the write-a-note page on the right. (Name kept from the
/// Pageboy days so existing call sites don't change.)
class PageBoyController: UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {

    // MARK: Properties

    var statusBarStyle: UIStatusBarStyle = .lightContent

    /// Live Firestore listener for the signed-in user's notes.
    private var notesListener: ListenerRegistration?

    let noteCollectionController = UINavigationController(rootViewController: NoteCollectionController())
    let writeNotesController = WriteNoteController()

    private lazy var pages: [UIViewController] = [noteCollectionController, writeNotesController]

    /// The pager's internal scroll view, for turning swipes on and off.
    private var pagingScrollView: UIScrollView? {
        view.subviews.compactMap { $0 as? UIScrollView }.first
    }

    var currentIndex: Int? {
        viewControllers?.first.flatMap { pages.firstIndex(of: $0) }
    }

    var noteCollection: NoteCollection? {
        didSet {
            if isViewLoaded {
                SetupController.updateRecentWidget(note: self.noteCollection?.FBNotes.first ?? FBNote(content: "", timestamp: 0, id: "", color: ""))
            }
        }
    }

    // MARK: Lifecycle

    init() {
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        notesListener?.remove()
        NotificationCenter.default.removeObserver(self)
    }

    override func viewDidLoad() {
        let vdlID = Signposts.begin("PageBoy.viewDidLoad")
        defer { Signposts.end("PageBoy.viewDidLoad", id: vdlID) }
        super.viewDidLoad()

        // The biometric lock is shown by SceneDelegate (on launch, foreground
        // and background), not from here.

        dataSource = self
        delegate = self
        view.backgroundColor = .clear

        // defaultView 0 opens on the write page, 1 on the Notes list.
        let startPage = UserDefaults.standard.integer(forKey: "defaultView") == 1 ? noteCollectionController : writeNotesController
        setViewControllers([startPage], direction: .forward, animated: false)

        // Editing a note pushes onto the Notes navigation stack; paging
        // sideways from there would strand the editor.
        NotificationCenter.default.addObserver(forName: NSNotification.Name("disableSwipe"), object: nil, queue: .main) { [weak self] _ in
            self?.pagingScrollView?.isScrollEnabled = false
        }
        NotificationCenter.default.addObserver(forName: NSNotification.Name("enableSwipe"), object: nil, queue: .main) { [weak self] _ in
            self?.pagingScrollView?.isScrollEnabled = true
        }

        registerForTraitChanges([UITraitUserInterfaceStyle.self]) { (self: Self, _: UITraitCollection) in
            self.refreshStatusBarStyle()
        }

        setupNoteRetrieval()

        // Pre-warm the notes list view hierarchy so the first swipe from the
        // write screen doesn't pay for `NoteCollectionController.viewDidLoad`.
        Signposts.measure("PageBoy.prewarmNoteCollection") {
            _ = noteCollectionController.view
            noteCollectionController.viewControllers.first?.loadViewIfNeeded()
        }
        refreshStatusBarStyle()
    }

    // MARK: UIPageViewControllerDataSource

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let index = pages.firstIndex(of: viewController), index > 0 else { return nil }
        return pages[index - 1]
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let index = pages.firstIndex(of: viewController), index < pages.count - 1 else { return nil }
        return pages[index + 1]
    }

    // MARK: UIPageViewControllerDelegate

    private var pageScrollSignpostID: OSSignpostID?

    func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
        pageScrollSignpostID = Signposts.begin("Pager.scroll")
    }

    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if let id = pageScrollSignpostID {
            Signposts.end("Pager.scroll", id: id)
            pageScrollSignpostID = nil
        }
        // Child appearance callbacks fire when a swipe starts, so the page
        // being swiped toward may have already restyled the status bar.
        // Recompute for whichever page is actually showing (this also covers
        // cancelled swipes).
        refreshStatusBarStyle()
    }

    // MARK: Status bar

    /// Recomputes the status bar style for whichever page is showing.
    func refreshStatusBarStyle() {
        guard let page = viewControllers?.first else { return }

        let style: UIStatusBarStyle
        if page === writeNotesController {
            style = .lightContent
        } else if noteCollectionController.topViewController is EditingController {
            style = EditingData.currentNote.color.getColor().isDarkColor ? .lightContent : .darkContent
        } else {
            style = .default
        }

        guard style != statusBarStyle else { return }
        statusBarStyle = style
        animateStatusBarAppearanceUpdate()
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        statusBarStyle
    }


    // MARK: Data

    func setupNoteRetrieval() {
        //cloud settings win over local settings
        DataManager.retrieveUserSettings { (settings, success) in
            guard success == true else { return }
            User.settings = settings

            if settings?.referralLink == "" {
                ReferralManager().createReferralLink()
            }

            if !(settings?.hasPremium ?? false) {
                if settings?.referrals ?? 0 >= 3 {
                    //three referrals earn premium
                    DataManager.updateUserSettings(setting: "hasPremium", value: true) { success in
                        if success != true { print("Error awarding premium from referral") }
                    }
                } else {
                    // Purchases made on another device or before a reinstall
                    // show up in StoreKit's entitlements; no password prompt.
                    Task { await PremiumStore.shared.refreshEntitlement() }
                }
            }
        }

        // Keep the registration and capture self weakly: Firestore holds the
        // listener until it's removed.
        notesListener?.remove()
        notesListener = DataManager.observeNoteChange { [weak self] (collection, success) in
            guard let self else { return }
            if success == true {
                let controller = self.noteCollectionController.viewControllers.first as? NoteCollectionController
                controller?.noteCollection = collection
                self.noteCollection = collection
            } else {
                print("Error retrieving note collection")
            }
        }
    }

    // MARK: Actions

    func scrollToWriteNoteController() {
        guard viewControllers?.first !== writeNotesController else {
            writeNotesController.field.becomeFirstResponder()
            return
        }
        setViewControllers([writeNotesController], direction: .forward, animated: true) { [weak self] finished in
            guard let self, finished else { return }
            // UIPageViewController keeps a stale neighbour cache after an
            // animated programmatic turn; a second, non-animated set resets it
            // so swiping back still lands on Notes.
            DispatchQueue.main.async {
                self.setViewControllers([self.writeNotesController], direction: .forward, animated: false)
            }
            self.refreshStatusBarStyle()
            self.writeNotesController.field.becomeFirstResponder()
        }
    }

    //used to handle event when "Apple Credential Revoked" while app is in background
    @objc func appleIDStateDidRevoked(_ notification: Notification) {
        if AuthManager().isSignedInWithApple {
            AuthManager.signOut()
        }
    }
}
