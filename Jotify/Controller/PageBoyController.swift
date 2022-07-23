//
//  PageBoyController.swift
//  Jotify
//
//  Created by Harrison Leath on 4/25/21.
//

import UIKit
import Pageboy
import AuthenticationServices

class PageBoyController: PageboyViewController, PageboyViewControllerDataSource {
    
    // MARK: Properties
    
    var statusBarStyle: UIStatusBarStyle = .lightContent
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        if UserDefaults.standard.bool(forKey: "useBiometrics") {
            let poc = PrivacyOverlayController()
            poc.modalPresentationStyle = .fullScreen
            present(poc, animated: true, completion: nil)
        }
        
        if (!(User.settings?.hasPremium ?? false)) {
            //if they don't already have premium fetch the records from Apple
            IAPManager.shared.requestIAP()
        }
        
        //set PageboyViewControllerDataSource dataSource to configure page view controller
        dataSource = self
        
        //remove bounce effect when overscrolling from page to page
        bounces = false
        
        //set custom transition to allow time for keyboard to pop up when programmatically scrolling
        transition = Transition(style: .push, duration: 0.15)
        
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
    }
    
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
                
                if !(settings?.hasPremium ?? false) {
                    self.checkForRestorePurchase()
                }
                
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
                if !(settings!.hasMigrated) && !UserDefaults.standard.bool(forKey: "hasMigrated") {
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
        
        //get notes from Firebase
        DataManager.observeNoteChange { (collection, success) in
            if success! {
                let controller = self.noteCollectionController.viewControllers.first as! NoteCollectionController
                controller.noteCollection = collection
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
    
    func checkForRestorePurchase() {
        IAPManager.shared.restorePurchases { (result) in
            DispatchQueue.main.async {
                switch result {
                case .success(let success):
                    if success {
                        //unlock premium
                        DataManager.updateUserSettings(setting: "hasPremium", value: true) { success in
                            if !success! {
                                print("Error granting premium from restore")
                            }
                            print("Restored automatically")
                            User.settings?.hasPremium = true
                        }
                    } else {
                        //no products were found
                        print("Nothing to automatically restore...")
                    }
                    
                case .failure(let error):
                    //there was an error
                    print("\(error) restoring IAP")
                }
            }
        }
    }
}
