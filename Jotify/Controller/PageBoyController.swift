//
//  PageBoyController.swift
//  Jotify
//
//  Created by Harrison Leath on 4/25/21.
//

import UIKit
import Pageboy
import FirebaseFirestore
import AuthenticationServices
import os

class PageBoyController: PageboyViewController, PageboyViewControllerDataSource, PageboyViewControllerDelegate {
    
    // MARK: Properties
    
    var statusBarStyle: UIStatusBarStyle = .lightContent

    /// Live Firestore listener for the signed-in user's notes.
    private var notesListener: ListenerRegistration?
    
    //view controllers that will be displayed in page view controller.
    let noteCollectionController = UINavigationController(rootViewController: NoteCollectionController(collectionViewLayout: UICollectionViewFlowLayout()))
    let writeNotesController = WriteNoteController()
    
    private lazy var viewControllers: [UIViewController] = {
        return [self.noteCollectionController, self.writeNotesController]
    }()
    
    var noteCollection: NoteCollection? {
        didSet {
            if isViewLoaded {
                SetupController.updateRecentWidget(note: self.noteCollection?.FBNotes.first ?? FBNote(content: "There was an error retrieving your note.", timestamp: 0, id: "", color: "systemBlue"))
            }
        }
    }
    
    // MARK: Lifecycle

    deinit {
        notesListener?.remove()
    }
    
    override func viewDidLoad() {
        let vdlID = Signposts.begin("PageBoy.viewDidLoad")
        defer { Signposts.end("PageBoy.viewDidLoad", id: vdlID) }
        super.viewDidLoad()

        // The biometric lock is shown by SceneDelegate (on launch, foreground
        // and background). Presenting it here as well, from viewDidLoad before
        // the view is in a window, only produced "not in the window hierarchy"
        // warnings and a competing presentation.

        if (!(User.settings?.hasPremium ?? false)) {
            //if they don't already have premium fetch the records from Apple
            IAPManager.shared.requestIAP()
        }
        
        //set PageboyViewControllerDataSource dataSource to configure page view controller
        dataSource = self
        delegate = self
        
        //remove bounce effect when overscrolling from page to page
        bounces = false

        // No custom `transition` here: in Pageboy 4+ a non-nil `transition`
        // replaces the native UIPageViewController animator for swipes too,
        // which felt laggy after the upgrade. iOS 26's keyboard animation
        // happens in parallel with the page change, so the old "slow the
        // push so the keyboard can catch up" trick is no longer needed.
        
        //setup the color system for background with light/dark mode
        if traitCollection.userInterfaceStyle == .light {
            ColorManager.bgColor = .jotifyGray
        } else if traitCollection.userInterfaceStyle == .dark {
            if UserDefaults.standard.bool(forKey: "usePureDarkMode") {
                ColorManager.bgColor = .black
            } else {
                ColorManager.bgColor = .mineShaft
            }
        }
        
        view.backgroundColor = .clear

        setupNoteRetrieval()

        // Pre-warm the notes list view hierarchy so the first swipe from the
        // write screen doesn't pay for `NoteCollectionController.viewDidLoad`
        // (collection view, cell registration, search bar setup) on top of
        // the Pageboy transition.
        Signposts.measure("PageBoy.prewarmNoteCollection") {
            // Touching the nav controller's view alone doesn't load its root
            // view controller's view, so load the Notes list explicitly.
            _ = noteCollectionController.view
            noteCollectionController.viewControllers.first?.loadViewIfNeeded()
        }
    }

    // MARK: PageboyViewControllerDelegate (signpost-only, no behavior)

    private var pageScrollSignpostID: OSSignpostID?

    func pageboyViewController(_ pageboyViewController: PageboyViewController,
                               willScrollToPageAt index: PageboyViewController.PageIndex,
                               direction: PageboyViewController.NavigationDirection,
                               animated: Bool) {
        pageScrollSignpostID = Signposts.begin("Pageboy.scroll")
    }

    func pageboyViewController(_ pageboyViewController: PageboyViewController,
                               didScrollToPageAt index: PageboyViewController.PageIndex,
                               direction: PageboyViewController.NavigationDirection,
                               animated: Bool) {
        if let id = pageScrollSignpostID {
            Signposts.end("Pageboy.scroll", id: id)
            pageScrollSignpostID = nil
        }
        refreshStatusBarStyle(forPageAt: index)
    }

    func pageboyViewController(_ pageboyViewController: PageboyViewController,
                               didScrollTo position: CGPoint,
                               direction: PageboyViewController.NavigationDirection,
                               animated: Bool) {}

    func pageboyViewController(_ pageboyViewController: PageboyViewController,
                               didCancelScrollToPageAt index: PageboyViewController.PageIndex,
                               returningToPageAt previousIndex: PageboyViewController.PageIndex) {
        if let id = pageScrollSignpostID {
            Signposts.end("Pageboy.scroll", id: id)
            pageScrollSignpostID = nil
        }
        // Child appearance callbacks fire when a swipe starts, so the page
        // being swiped toward has already restyled the status bar. Put it
        // back for the page we actually stayed on.
        refreshStatusBarStyle(forPageAt: previousIndex)
    }

    // MARK: Status bar

    /// Recomputes the status bar style for whichever page is showing. Pages
    /// set it from their appearance callbacks too, but those also fire for
    /// swipes that get cancelled and for trait changes on off-screen pages.
    func refreshStatusBarStyle(forPageAt index: PageboyViewController.PageIndex? = nil) {
        guard let index = index ?? currentIndex, viewControllers.indices.contains(index) else { return }
        let page = viewControllers[index]

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

    func pageboyViewController(_ pageboyViewController: PageboyViewController,
                               didReloadWith currentViewController: UIViewController,
                               currentPageIndex: PageboyViewController.PageIndex) {}
    
    func setupNoteRetrieval() {
        //retrieve settings from Firebase here instead of AppDelegate
        //cloud settings > local settings
        //if cloud settings hasn't migrated check with local settings
        //if local settings hasn't migrated check too, then initialize CloudKit and start migration process
        DataManager.retrieveUserSettings { (settings, success) in
            if success! {
                User.settings = settings
                
                if settings?.referralLink == "" {
                    print("created new referral link")
                    ReferralManager().createReferralLink()
                }
                
                // No automatic restoreCompletedTransactions() here: it runs on
                // every launch for non-premium users and makes iOS prompt for
                // their Apple Account password. Restoring is user-initiated
                // from General settings; new purchases arrive through the
                // payment-queue observer.

                //check to see if they should get premium from referrals
                if !(settings?.hasPremium ?? false) {
                    if settings?.referrals ?? 0 >= 3 {
                        print("Awarding premium from referrals")
                        //TODO: LET USER KNOW THEY GOT PREMIUM!
                        DataManager.updateUserSettings(setting: "hasPremium", value: true) { success in
                            if !success! {
                                print("Error awarding premium from referral")
                            }
                        }
                    }
                }
                
                print("Has migrated: \(User.settings?.hasMigrated ?? false)")
                if !(settings?.hasMigrated ?? true) && !UserDefaults.standard.bool(forKey: "hasMigrated") {
                    //ask user if they want to migrate notes
                    let alertController = UIAlertController(title: "Have you used Jotify before?", message: "If you have, Jotify can automatically import your notes from previous verions. Do you want to import your old notes?", preferredStyle: .alert)
                    alertController.addAction(UIAlertAction(title: "No", style: .default, handler: {(action) in
                        //set these values, so this prompt does not appear on every launch
                        UserDefaults.standard.setValue(true, forKey: "hasMigrated")
                        DataManager.updateUserSettings(setting: "hasMigrated", value: true) { (success) in }
                    }))
                    alertController.addAction(UIAlertAction(title: "Yes", style: .default, handler: {(action) in
                        //notify when notes are fetched from context, CloudKit
                        NotificationCenter.default.addObserver(self, selector: #selector(self.migrateDataFromCloudKit), name: .NSManagedObjectContextObjectsDidChange, object: MigrationHandler().context)
                    }))
                    self.present(alertController, animated: true, completion: nil)
                }
            }
        }
        
        //get notes from Firebase. Keep the registration and capture self
        //weakly: Firestore holds the listener until it's removed, so the old
        //strong capture kept every PageBoyController (and its whole page
        //hierarchy) alive after sign-out.
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
    
    //if fetch request from CloudKit returns objects, duplicate each object in Firebase
    @objc func migrateDataFromCloudKit() {
        if !MigrationHandler.CDNotes.isEmpty {
            NotificationCenter.default.removeObserver(self)
            for note in MigrationHandler.CDNotes {
                DataManager.createNote(content: note.content ?? "", timestamp: note.modifiedDate, color: ColorManager.noteColor.getString())
                ColorManager.setNoteColor()
            }
            UserDefaults.standard.setValue(true, forKey: "hasMigrated")
            DataManager.updateUserSettings(setting: "hasMigrated", value: true) { (success) in }
        }
    }
    
    // MARK: PageboyViewControllerDataSource
    
    func numberOfViewControllers(in pageboyViewController: PageboyViewController) -> Int {
        viewControllers.count //how many view controllers to display in the page view controller.
    }
    
    func viewController(for pageboyViewController: PageboyViewController, at index: PageboyViewController.PageIndex) -> UIViewController? {
        viewControllers[index] //view controller to display at a specific index for the page view controller.
    }
    
    func defaultPage(for pageboyViewController: PageboyViewController) -> PageboyViewController.Page? {
        if UserDefaults.standard.integer(forKey: "defaultView") == 0 {
            return .last
        } else if UserDefaults.standard.integer(forKey: "defaultView") == 1{
            return .first
        } else {
            return .last //default page to display in the page view controller (nil equals default/first index).
        }
    }
    
    // MARK: Actions
    
    func scrollToWriteNoteController() {
        scrollToPage(.last, animated: true) { (vc, result, result2) in
            if result && result2 {
                let writeNoteController = vc as! WriteNoteController
                writeNoteController.field.becomeFirstResponder()
            }
        }
    }
    
    //used to handle event when "Apple Credential Revoked" while app is in background
    @objc func appleIDStateDidRevoked(_ notification: Notification) {
        if AuthManager().isSignedInWithApple {
            AuthManager.signOut()
        }
    }
    
    // MARK: TraitCollection
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        defer { refreshStatusBarStyle() }
        if traitCollection.userInterfaceStyle == .light {
            ColorManager.bgColor = .jotifyGray
        } else if traitCollection.userInterfaceStyle == .dark {
            if UserDefaults.standard.bool(forKey: "usePureDarkMode") {
                ColorManager.bgColor = .black
            } else {
                ColorManager.bgColor = .mineShaft
            }
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return statusBarStyle
    }

}
