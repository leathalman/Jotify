//
//  NoteCollectionController.swift
//  Zurich
//
//  Created by Harrison Leath on 1/12/21.
//

import UIKit
import Blueprints
import SwiftMessages
import WidgetKit

class NoteCollectionController: UICollectionViewController {
    //update collection view when model changes
    var noteCollection: NoteCollection? {
        didSet {
            if isViewLoaded {
                collectionView.reloadData()
            }
        }
    }
    
    //used to hold notes filtered by the search bar
    var filteredNotes: [FBNote] = []

    //used to track the cells selected while multi-selection is enabled
    var selectedCells: [IndexPath] = []

    //global instance of searchController for NoteCollectionController
    let searchController = UISearchController(searchResultsController: nil)


    //layouts for collectionView
    let iOSLayout = VerticalBlueprintLayout(
        itemsPerRow: 2.0,
        minimumInteritemSpacing: 10,
        minimumLineSpacing: 15,
        sectionInset: EdgeInsets(top: 10, left: 10, bottom: 10, right: 10),
        stickyHeaders: false,
        stickyFooters: false)
    
    let iPadOSLayout = VerticalBlueprintLayout(
        itemsPerRow: 4.0,
        minimumInteritemSpacing: 10,
        minimumLineSpacing: 15,
        sectionInset: EdgeInsets(top: 10, left: 10, bottom: 10, right: 10),
        stickyHeaders: false,
        stickyFooters: false)
    
    //life cycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        enableAutomaticStatusBarStyle()
        resetAppBadgeIfAllRemindersCleared()
        // Re-apply the current `ColorManager.bgColor` every time this VC
        // becomes visible, so the Pure Dark Mode setting change flows back
        // through the nav stack naturally on pop. No notification needed.
        collectionView.backgroundColor = ColorManager.bgColor
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewElements()
        setupNavigationBar()
        setupSearchBar()
        cleanupOldNotes()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        hideToolbar()
        // Previously we tore down `navigationItem.searchController` here and
        // reinstalled it on every `viewWillAppear`. On iOS 26's stacked
        // search bar that churn forces a nav bar relayout during every
        // push/pop, which manifests as a stagger on every transition out of
        // this screen. Leave the search controller installed.
    }
    
    //view configuration
    func setupViewElements() {
        if UIDevice.current.userInterfaceIdiom == .pad {
            collectionView.setCollectionViewLayout(iPadOSLayout, animated: true)
        } else if UIDevice.current.userInterfaceIdiom == .phone {
            collectionView.setCollectionViewLayout(iOSLayout, animated: true)
        }
        
        extendedLayoutIncludesOpaqueBars = true
        collectionView.frame = view.frame
        collectionView.alwaysBounceVertical = true

        // UIScrollView's default 150ms touch delay makes every cell tap feel
        // laggy on the way to `didSelectItemAt`. We're fine letting a tap
        // register immediately — scroll still wins if the finger moves.
        collectionView.delaysContentTouches = false

        CellState.shouldSelectMultiple = false
        collectionView.allowsMultipleSelection = false
        
        //navigation bar item customization
        let leftItem = UIBarButtonItem(image: UIImage(systemName: "gear"), style: .plain, target: self, action: #selector(handleLeftNavButton))
        navigationItem.leftBarButtonItem = leftItem
        navigationItem.setHidesBackButton(true, animated: true)
        
        let rightItem = UIBarButtonItem(image: UIImage(systemName: "doc.badge.plus"), style: .plain, target: self, action: #selector(handleRightNavButton))
        navigationItem.rightBarButtonItem = rightItem
        
        collectionView.backgroundColor = ColorManager.bgColor
        collectionView.register(SavedNoteCell.self, forCellWithReuseIdentifier: "SavedNoteCell")

        // Single long-press recognizer for the whole collection view.
        // Previously we added one per cell inside `cellForItemAt`, which
        // meant reused cells accumulated dozens of recognizers and every
        // touch had to consult all of them — the main cause of scroll lag.
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(longTouchHandler(sender:)))
        // Don't swallow the touch when the long-press recognizes — the
        // option menu is a separate presentation, and letting the touch
        // pass through keeps short taps snappy.
        longPress.cancelsTouchesInView = false
        collectionView.addGestureRecognizer(longPress)
    }
    
    func setupNavigationBar() {
        navigationItem.title = "Notes"
        // Don't override the nav bar background on this screen. iOS 26's
        // adaptive chrome animates smoothly between the idle search bar
        // pill and the active state; forcing an opaque `ColorManager.bgColor`
        // prevents that animation and produces a visible color jump.
    }
    
func resetAppBadgeIfAllRemindersCleared() {
        var numOfReminders = 0
        if noteCollection?.FBNotes != nil {
            let notes = noteCollection!.FBNotes
            
            for note in notes {
                if note.reminderTimestamp ?? 0 > 0 {
                    //reminder has not been delivered
                    numOfReminders += 1
                }
            }
            
            if numOfReminders == 0 {
                UIApplication.shared.applicationIconBadgeNumber = 0
            }
        }
    }
    
    //action handlers
    @objc func longTouchHandler(sender: UILongPressGestureRecognizer) {
        guard !searchController.isActive else { return }

        let location = sender.location(in: collectionView)
        guard let indexPath = collectionView.indexPathForItem(at: location),
              let notes = noteCollection?.FBNotes,
              indexPath.row < notes.count
        else { return }
        let note = notes[indexPath.row]

        let menu: NoteOptionMenu
        do {
            menu = try SwiftMessages.viewFromNib(named: "NoteOptionMenu")
        } catch {
            print("Failed to load NoteOptionMenu NIB: \(error)")
            return
        }
        menu.configureBackgroundView(width: 250)
        
        //configure title and actions
        menu.titleLabel?.text = "Options"
        menu.button1.setTitle("Share Note", for: .normal)
        menu.button2.setTitle("Delete Note", for: .normal)
        menu.button3.setTitle("Select Multiple", for: .normal)
        menu.button4.setTitle("Cancel", for: .normal)
        
        menu.titleLabel?.font = .boldSystemFont(ofSize: 24)
        menu.button1.titleLabel?.font = .boldSystemFont(ofSize: 16)
        menu.button2.titleLabel?.font = .boldSystemFont(ofSize: 16)
        menu.button3.titleLabel?.font = .boldSystemFont(ofSize: 16)
        menu.button4.titleLabel?.font = .boldSystemFont(ofSize: 16)
        
        menu.button1.addTarget(self, action: #selector(shareNoteFromMenu(_:)), for: .touchUpInside)
        menu.button1.params["content"] = note.content
        menu.button2.addTarget(self, action: #selector(deleteNoteFromMenu(_:)), for: .touchUpInside)
        menu.button2.params["note"] = note
        menu.button3.addTarget(self, action: #selector(showToolbar), for: .touchUpInside)
        menu.button4.addTarget(self, action: #selector(cancelOptionFromMenu), for: .touchUpInside)
        
        menu.backgroundView.backgroundColor = ColorManager.bgColor
        menu.backgroundView.layer.cornerRadius = 10
        
        var config = SwiftMessages.defaultConfig
        config.presentationStyle = .center
        config.duration = .forever
        config.interactiveHide = false
        config.dimMode = .blur(style: .dark, alpha: 1, interactive: true)
        config.presentationContext  = .window(windowLevel: UIWindow.Level.statusBar)
        SwiftMessages.show(config: config, view: menu)
    }
    
    @objc func handleLeftNavButton() {
        //initialize settings controller and pass note collection for theme changing
        let vc = MasterSettingsController(style: .insetGrouped)
        vc.noteCollection = noteCollection
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            vc.modalPresentationStyle = .formSheet
            navigationController?.present(vc, animated: true, completion: nil)
        } else if UIDevice.current.userInterfaceIdiom == .phone {
            navigationController?.pushViewController(vc, animated: true)
        }
        
        self.playHapticFeedback()
    }
    
    @objc func handleRightNavButton() {
        let rootVC = self.rootViewController as! PageBoyController
        rootVC.scrollToWriteNoteController()
        self.playHapticFeedback()
    }

    //NoteOptionMenu Actions
    @objc func deleteNoteFromMenu(_ sender: PassableUIButton) {
        let note = sender.params["note"] as! FBNote
        let id = note.id
        
        DataManager.deleteNote(docID: id) { (success) in
            //if note is successfully deleted from server, remove it from local notification and badge number
            if success! {
                AnalyticsManager.logEvent(named: "note_deleted", description: "note_deleted")
                
                //remove pending reminder since note has been deleted
                if note.reminderTimestamp ?? 0 > 0 {
                    //is reminder
                    let notificationUUID = note.reminder ?? "nil"
                    let center = UNUserNotificationCenter.current()
                    center.removePendingNotificationRequests(withIdentifiers: [notificationUUID])
                    
                    //remove badge if notification is already delivered but not opened
                    if note.reminderTimestamp ?? 0 < Date.timeIntervalSinceReferenceDate {
                        //reminder is already delivered
                        UIApplication.shared.applicationIconBadgeNumber -= 1
                    }
                }
            }
        }
        SwiftMessages.hide()
    }
    
    @objc func shareNoteFromMenu(_ sender: PassableUIButton) {
        let objectsToShare = [sender.params["content"]]
        let activityVC = UIActivityViewController(activityItems: objectsToShare as [Any], applicationActivities: nil)
        activityVC.excludedActivityTypes = [UIActivity.ActivityType.addToReadingList]
        
        //required properties for iPad's popoverPresentationController, otherwise crash
        if let popoverController = activityVC.popoverPresentationController {
            popoverController.sourceRect = CGRect(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height / 2, width: 0, height: 0)
            popoverController.sourceView = self.view
            popoverController.permittedArrowDirections = UIPopoverArrowDirection(rawValue: 0)
        }
        
        self.present(activityVC, animated: true, completion: nil)
        AnalyticsManager.logEvent(named: "share_note", description: "share_note")
        SwiftMessages.hide()
    }
    
    @objc func showToolbar() {
        SwiftMessages.hide()
        CellState.shouldSelectMultiple = true
        
        collectionView.allowsMultipleSelection = true
        navigationController?.setToolbarHidden(false, animated: true)
        
        let appearance = UIToolbarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = ColorManager.bgColor
        navigationController?.toolbar.standardAppearance = appearance
        navigationController?.toolbar.compactAppearance = appearance
        
        var items = [UIBarButtonItem]()
        items.append(UIBarButtonItem(title: "Cancel", style: .done, target: self, action: #selector(hideToolbar)))
        items.append(UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil))
        items.append(UIBarButtonItem(title: "Delete", style: .done, target: self, action: #selector(deleteSelectedCells)))
        toolbarItems = items
    }
    
    @objc func cancelOptionFromMenu() {
        SwiftMessages.hide()
    }
    
    @objc func hideToolbar() {
        navigationController?.setToolbarHidden(true, animated: true)
        
        for path in selectedCells {
            if selectedCells.contains(path) {
                let index = selectedCells.firstIndex(of: path)!
                selectedCells.remove(at: index)
                collectionView.reloadItems(at: [path])
            }
        }
        
        CellState.shouldSelectMultiple = false
        collectionView.allowsMultipleSelection = false
    }
    
    @objc func deleteSelectedCells() {
        for indexPath in selectedCells {
            //remove pending reminder since note has been deleted
            if self.noteCollection?.FBNotes[indexPath.row].reminderTimestamp ?? 0 > 0 {
                //is reminder
                let notificationUUID = self.noteCollection?.FBNotes[indexPath.row].reminder ?? "nil"
                let center = UNUserNotificationCenter.current()
                center.removePendingNotificationRequests(withIdentifiers: [notificationUUID])
                
                //remove badge if notification is already delivered but not opened
                if self.noteCollection?.FBNotes[indexPath.row].reminderTimestamp ?? 0 < Date.timeIntervalSinceReferenceDate {
                    //reminder is already delivered
                    UIApplication.shared.applicationIconBadgeNumber -= 1
                }
            }
            
            DataManager.deleteNote(docID: noteCollection?.FBNotes[indexPath.row].id ?? "") { success in
                //handle success here
                AnalyticsManager.logEvent(named: "note_deleted", description: "note_deleted")
            }
        }
        selectedCells = []
    }
    
    //collectionView Logic
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //noteCollection.notes.count will return nil if no notes exist on launch, will return 0 if user deletes a note
        //and num of objs in array go to 0
        if (noteCollection?.FBNotes.count == nil) || (noteCollection?.FBNotes.count == 0) {
            if User.settings?.defaultView == 0 {
                collectionView.backgroundView = EmptyNoteView()
            }
        } else {
            //remove backgroundView if array of notes isn't empty
            collectionView.backgroundView = nil
            if isFiltering {
                return filteredNotes.count
            }
        }
        
        return noteCollection?.FBNotes.count ?? 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SavedNoteCell", for: indexPath) as? SavedNoteCell else { fatalError("Wrong cell class dequeued") }

        let note = isFiltering ? filteredNotes[indexPath.row] : noteCollection?.FBNotes[indexPath.row]

        // Cache derived values so we don't re-parse the color string or
        // recompute luminance on every property we set.
        let noteColor = note?.color.getColor()
        let contrastingColor: UIColor = (noteColor?.isDarkColor ?? true) ? .white : .black

        cell.textLabel.text = note?.content
        cell.dateLabel.text = note?.timestamp.getDate()
        cell.textLabel.textColor = contrastingColor
        cell.dateLabel.textColor = contrastingColor

        if selectedCells.contains(indexPath) {
            cell.contentView.backgroundColor = .darkGray
            cell.shake()
        } else {
            cell.contentView.backgroundColor = noteColor
            cell.stopShaking()
        }

        //show timer icon if note is a reminder
        if (note?.reminderTimestamp ?? 0) > 0 {
            cell.reminderIcon.tintColor = contrastingColor
            cell.reminderIcon.alpha = 1
        } else {
            cell.reminderIcon.alpha = 0
        }

        //when creating a note on first launch, server cannot update client fast enough for UI to show correct note content
        //instead, display the text stored locally for the first note created after launch
        if indexPath == IndexPath(row: 0, section: 0) && EditingData.firstNote {
            cell.textLabel.text = EditingData.currentNote.content
            EditingData.firstNote = false
        }

        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.playHapticFeedback()
        
        if CellState.shouldSelectMultiple {
            if !selectedCells.contains(indexPath) {
                selectedCells.append(indexPath)
            } else if let index = selectedCells.firstIndex(of: indexPath) {
                selectedCells.remove(at: index)
            }
            collectionView.reloadItems(at: [indexPath])
        } else {
            let controller = EditingController()
            controller.noteCollection = noteCollection
            EditingData.currentNote = (noteCollection?.FBNotes[indexPath.row])!
            if isFiltering {
                EditingData.currentNote = filteredNotes[indexPath.row]
            }
            AnalyticsManager.logEvent(named: "note_opened", description: "note_opened")
            navigationController?.pushViewController(controller, animated: true)
        }
    }
    
    func cleanupOldNotes() {
        if UserDefaults.standard.bool(forKey: "deleteOldNotes") {
            for note in noteCollection!.FBNotes {
                let today = Date.timeIntervalSinceReferenceDate
                let timeBetweenDates = today - note.timestamp
                if timeBetweenDates > 2592000 {
                    print("Deleting note because of old date.")
                    DataManager.deleteNote(docID: note.id) { success in
                        //handle success
                    }
                }
            }
        }
    }
    
//traitcollection: dynamic iPad layout and light/dark mode support
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        if traitCollection.horizontalSizeClass == .compact {
            iPadOSLayout.itemsPerRow = 2.0
        } else if traitCollection.horizontalSizeClass == .regular {
            iPadOSLayout.itemsPerRow = 4.0
        }
        collectionView.collectionViewLayout.invalidateLayout()
        collectionView.backgroundColor = ColorManager.bgColor
        setupNavigationBar()
        enableAutomaticStatusBarStyle()
    }
}

extension NoteCollectionController: CollectionViewFlowLayoutDelegate {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var height: CGFloat = 0
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            height = 120
        } else {
            height = 110
        }
        return CGSize(width: UIScreen.main.bounds.width, height: height)
    }
}
