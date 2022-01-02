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
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if UserDefaults.standard.bool(forKey: "useBiometrics") {
            let poc = PrivacyOverlayController()
            poc.modalPresentationStyle = .fullScreen
            present(poc, animated: true, completion: nil)
        }
        
        //set PageboyViewControllerDataSource dataSource to configure page view controller
        dataSource = self
        
        //remove bounce effect when overscrolling from page to page
        bounces = false
        
        //set custom transition to allow time for keyboard to pop up when programmatically scrolling
        transition = Transition(style: .push, duration: 0.15)
        
        //setup the color system for background with light/dark mode
        if traitCollection.userInterfaceStyle == .light {
            ColorManager.bgColor = UIColor.white.adjust(by: -4) ?? .white
        } else if traitCollection.userInterfaceStyle == .dark {
            ColorManager.bgColor = .mineShaft
        }
        
        view.backgroundColor = .clear
        
        setupNoteRetrieval()
        
        NotificationCenter.default.addObserver(self, selector: #selector(appleIDStateDidRevoked(_:)), name: ASAuthorizationAppleIDProvider.credentialRevokedNotification, object: nil)
    }
    
    func setupNoteRetrieval() {
        //retrieve settings from Firebase here instead of AppDelegate
        //cloud settings > local settings
        //if cloud settings hasn't migrated check with local settings
        //if local settings hasn't migrated check too, then initialize CloudKit and start migration process
        DataManager.retrieveUserSettings { (settings, success) in
            if success! {
                User.settings = settings
                
                if !(settings!.hasMigrated) && !UserDefaults.standard.bool(forKey: "hasMigrated") {
                    print("Has migrated?: \(UserDefaults.standard.bool(forKey: "hasMigrated"))")
                    //notify when notes are fetched from context, CloudKit
                    NotificationCenter.default.addObserver(self, selector: #selector(self.migrateDataFromCloudKit), name: .NSManagedObjectContextObjectsDidChange, object: MigrationHandler().context)
                }
            }
        }
        
        //get notes from Firebase
        DataManager.observeNoteChange { (collection, success) in
            if success! {
                let controller = self.noteCollectionController.viewControllers.first as! NoteCollectionController
                controller.noteCollection = collection
                
                SetupController.updateRecentWidget(note: collection?.FBNotes.first ?? FBNote(content: "There was an error retrieving your note.", timestamp: 0, id: "", color: "systemBlue"))
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
        return .last //default page to display in the page view controller (nil equals default/first index).
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
            ColorManager.bgColor = UIColor.white.adjust(by: -4) ?? .white
        } else if traitCollection.userInterfaceStyle == .dark {
            ColorManager.bgColor = .mineShaft
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return statusBarStyle
    }
}
