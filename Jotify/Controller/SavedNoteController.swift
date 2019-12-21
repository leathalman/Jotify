//
//  SavedNoteController.swift
//  Sticky Notes
//
//  Created by Harrison Leath on 5/13/19.
//  Copyright © 2019 Harrison Leath. All rights reserved.
//

import AudioToolbox
import Blueprints
import CoreData
import UIKit
import ViewAnimator
import XLActionController

class SavedNoteController: UICollectionViewController, UISearchBarDelegate {
    var notes: [Note] = []
    var filteredNotes: [Note] = []
    
    var pressed: Int = 0
    
    let emptyView = EmptyView()
    
    let searchController = UISearchController(searchResultsController: nil)
    let loadingAnimations = [AnimationType.from(direction: .top, offset: 30.0)]
    
    let defaults = UserDefaults.standard
    
    let iOSLayout = VerticalBlueprintLayout(
        itemsPerRow: 2.0,
        minimumInteritemSpacing: 10,
        minimumLineSpacing: 15,
        sectionInset: EdgeInsets(top: 10, left: 10, bottom: 10, right: 10),
        stickyHeaders: false,
        stickyFooters: false)
    
    let iPadOSLayout = VerticalBlueprintLayout(
        itemsPerRow: 3.0,
        minimumInteritemSpacing: 10,
        minimumLineSpacing: 15,
        sectionInset: EdgeInsets(top: 10, left: 10, bottom: 10, right: 10),
        stickyHeaders: false,
        stickyFooters: false)
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
//        for note in notes {
//            if note.content == "" {
//                deleteEmptyNote(note: note)
//            }
//        }
        
        if !notes.isEmpty {
            setupSearchBar()
        }
        
        fetchNotesFromCoreData()
        setupDynamicViewElements()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        navigationItem.searchController = nil
        navigationController?.setToolbarHidden(true, animated: false)
        CellStates.shouldSelectMultiple = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        fetchNotesFromCoreData()
    }
    
    func setupView() {
        // setup CellState for multiple selection
        CellStates.shouldSelectMultiple = false
        
        navigationItem.title = "Saved Notes"
        navigationController?.navigationBar.prefersLargeTitles = false
        
        navigationController?.navigationBar.isTranslucent = false
        extendedLayoutIncludesOpaqueBars = true
        
        let rightItem = UIBarButtonItem(image: UIImage(systemName: "arrow.up.arrow.down.circle"), style: .plain, target: self, action: #selector(handleRightButton))
        navigationItem.rightBarButtonItem = rightItem
        
        let leftItem = UIBarButtonItem(image: UIImage(systemName: "gear"), style: .plain, target: self, action: #selector(handleLeftButton))
        navigationItem.leftBarButtonItem = leftItem
        navigationItem.setHidesBackButton(true, animated: true)
        
        collectionView.frame = view.frame
        collectionView.alwaysBounceVertical = true
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            collectionView.setCollectionViewLayout(iPadOSLayout, animated: true)
        } else if UIDevice.current.userInterfaceIdiom == .phone {
            collectionView.setCollectionViewLayout(iOSLayout, animated: true)
        }
        
        collectionView.allowsMultipleSelection = true
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.register(SavedNoteCell.self, forCellWithReuseIdentifier: "SavedNoteCell")
        view.addSubview(collectionView)
    }
    
    func setupDynamicViewElements() {
        collectionView.backgroundColor = InterfaceColors.viewBackgroundColor
        
        if defaults.bool(forKey: "darkModeEnabled") == true {
            searchController.searchBar.barTintColor = InterfaceColors.searchBarColor
            searchController.searchBar.backgroundImage = UIImage()
            
            emptyView.descriptionLabel.backgroundColor = InterfaceColors.viewBackgroundColor
            emptyView.descriptionLabel.textColor = .white
            emptyView.titleLabel.backgroundColor = InterfaceColors.viewBackgroundColor
            emptyView.titleLabel.textColor = .white
            
            UIApplication.shared.windows.first?.backgroundColor = InterfaceColors.viewBackgroundColor
            
            setupDarkPersistentNavigationBar()
            
        } else {
            searchController.searchBar.barTintColor = InterfaceColors.searchBarColor
            searchController.searchBar.backgroundImage = nil
            
            emptyView.descriptionLabel.backgroundColor = InterfaceColors.viewBackgroundColor
            emptyView.descriptionLabel.textColor = .black
            emptyView.titleLabel.backgroundColor = InterfaceColors.viewBackgroundColor
            emptyView.titleLabel.textColor = .black
            
            UIApplication.shared.windows.first?.backgroundColor = InterfaceColors.viewBackgroundColor
            
            setupDefaultPersistentNavigationBar()
        }
    }
    
    func setupDefaultPersistentNavigationBar() {
        navigationController?.navigationBar.backgroundColor = InterfaceColors.navigationBarColor
        navigationController?.navigationBar.barTintColor = InterfaceColors.navigationBarColor
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
        navigationController?.navigationBar.barStyle = .default
    }
    
    func setupDarkPersistentNavigationBar() {
        navigationController?.navigationBar.backgroundColor = InterfaceColors.navigationBarColor
        navigationController?.navigationBar.barTintColor = InterfaceColors.navigationBarColor
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navigationController?.navigationBar.barStyle = .black
    }
    
    func setupSearchBar() {
        searchController.searchResultsUpdater = self as UISearchResultsUpdating
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Notes"
        searchController.hidesNavigationBarDuringPresentation = true
        searchController.isActive = false
        searchController.searchBar.scopeButtonTitles = ["Content", "Date"]
        searchController.searchBar.delegate = self
        navigationItem.searchController = searchController
    }
    
    @objc func handleRightButton() {
        feedbackOnPress()
        
        let actionController = SkypeActionController()
        
        if defaults.bool(forKey: "showAlertOnSort") == true {
            if defaults.bool(forKey: "useRandomColor") == false {
                actionController.backgroundColor = defaults.color(forKey: "staticNoteColor") ?? UIColor.blue2
                
            } else if defaults.bool(forKey: "darkModeEnabled") == false {
                if isSelectedColorFromDefaults(key: "default") == true {
                    actionController.backgroundColor = Colors.defaultColors.randomElement() ?? UIColor.blue2
                    
                } else if isSelectedColorFromDefaults(key: "sunset") == true {
                    actionController.backgroundColor = Colors.sunsetColors.randomElement() ?? UIColor.blue2
                    
                } else if isSelectedColorFromDefaults(key: "kypool") == true {
                    actionController.backgroundColor = Colors.kypoolColors.randomElement() ?? UIColor.blue2
                    
                } else if isSelectedColorFromDefaults(key: "celestial") == true {
                    actionController.backgroundColor = Colors.celestialColors.randomElement() ?? UIColor.blue2
                    
                } else if isSelectedColorFromDefaults(key: "appleVibrant") == true {
                    actionController.backgroundColor = Colors.appleVibrantColors.randomElement() ?? UIColor.blue2
                }
                
            } else if defaults.bool(forKey: "darkModeEnabled") == true {
                actionController.backgroundColor = InterfaceColors.actionSheetColor
            }
            
            actionController.addAction(Action("Sort by date", style: .default, handler: { _ in
                self.defaults.set("date", forKey: "sortBy")
                self.fetchNotesFromCoreData()
                self.collectionView.reloadData()
                self.animateCells()
                
            }))
            actionController.addAction(Action("Sort by color", style: .default, handler: { _ in
                self.defaults.set("color", forKey: "sortBy")
                self.fetchNotesFromCoreData()
                self.collectionView.reloadData()
                self.animateCells()
                
            }))
            actionController.addAction(Action("Sort by content", style: .default, handler: { _ in
                self.defaults.set("content", forKey: "sortBy")
                self.fetchNotesFromCoreData()
                self.collectionView.reloadData()
                self.animateCells()
            }))
            actionController.addAction(Action("Sort by reminders", style: .default, handler: { _ in
                self.defaults.set("reminders", forKey: "sortBy")
                self.fetchNotesFromCoreData()
                self.collectionView.reloadData()
                self.animateCells()
            }))
            actionController.addAction(Action("Cancel", style: .cancel, handler: nil))
            
            present(actionController, animated: true, completion: nil)
            
        } else if defaults.bool(forKey: "showAlertOnSort") == false {
            if pressed == 0 {
                print("Sort by content")
                defaults.set("content", forKey: "sortBy")
                pressed += 1
                
            } else if pressed == 1 {
                print("Sort by color")
                defaults.set("color", forKey: "sortBy")
                pressed += 1
                
            } else if pressed == 2 {
                print("Sort by date")
                defaults.set("date", forKey: "sortBy")
                pressed = 0
                
            } else if pressed == 3 {
                print("Sort by reminders")
                defaults.set("reminders", forKey: "sortBy")
                pressed = 0
            }
            fetchNotesFromCoreData()
            animateCells()
        }
    }
    
    @objc func handleLeftButton() {
        feedbackOnPress()
        navigationController?.pushViewController(SettingsController(style: .insetGrouped), animated: true)
    }
    
    func isSelectedColorFromDefaults(key: String) -> Bool {
        let colorTheme = defaults.string(forKey: "noteColorTheme")
        
        if colorTheme == key {
            return true
        } else {
            return false
        }
    }
    
    func searchBarIsEmpty() -> Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    func filterContentForSearchText(_ searchText: String, scope: String = "All") {
        if searchController.searchBar.selectedScopeButtonIndex == 0 {
            filteredNotes = notes.filter { (note: Note) -> Bool in
                note.content?.lowercased().contains(searchText.lowercased()) ?? false
            }
            
            collectionView.reloadData()
            
        } else if searchController.searchBar.selectedScopeButtonIndex == 1 {
            filteredNotes = notes.filter { (note: Note) -> Bool in
                note.dateString?.lowercased().contains(searchText.lowercased()) ?? false
            }
            
            collectionView.reloadData()
        }
    }
    
    func isFiltering() -> Bool {
        return searchController.isActive && !searchBarIsEmpty()
    }
    
    func fetchNotesFromCoreData() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Note")
        fetchRequest.returnsObjectsAsFaults = false
        
        let sortBy = defaults.string(forKey: "sortBy")
        var sortDescriptor: NSSortDescriptor?
        
        if sortBy == "content" {
            sortDescriptor = NSSortDescriptor(key: "content", ascending: true)
            
        } else if sortBy == "date" {
            sortDescriptor = NSSortDescriptor(key: "modifiedDate", ascending: false)
            
        } else if sortBy == "color" {
            sortDescriptor = NSSortDescriptor(key: "color", ascending: false)
            
        } else if sortBy == "reminders" {
            sortDescriptor = NSSortDescriptor(key: "isReminder", ascending: false)
        }
        
        fetchRequest.sortDescriptors = [sortDescriptor] as? [NSSortDescriptor]
        
        CoreDataManager.shared.enqueue { _ in
            do {
                self.notes = try managedContext.fetch(fetchRequest) as! [Note]
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
                
            } catch let error as NSError {
                print("Could not fetch. \(error), \(error.userInfo)")
            }
        }
    }
    
    func animateCells() {
        collectionView?.reloadData()
        collectionView?.performBatchUpdates({
            UIView.animate(views: self.collectionView!.orderedVisibleCells, animations: loadingAnimations, completion: {})
        }, completion: nil)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if CellStates.shouldSelectMultiple == false {
            print("Normal Tap")
            cellSingleTap(indexPath: indexPath)
            
        } else if CellStates.shouldSelectMultiple == true {
            print("Multiple Tap")
        }
    }
    
    func cellSingleTap(indexPath: IndexPath) {
        let noteDetailController = NoteDetailController()
        
        var note = notes[indexPath.row]
        
        if isFiltering() {
            note = filteredNotes[indexPath.row]
            noteDetailController.filteredNotes = filteredNotes
            noteDetailController.isFiltering = true
            
        } else {
            note = notes[indexPath.row]
            noteDetailController.notes = notes
        }
        
        let modifiedDate = note.value(forKey: "modifiedDate")
        let color = note.value(forKey: "color") as! String
        let content = note.value(forKey: "content") as! String
        
        let updateDate = Date(timeIntervalSinceReferenceDate: modifiedDate as! TimeInterval)
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.long
        dateFormatter.timeZone = .current
        let dateString = dateFormatter.string(from: updateDate)
        
        noteDetailController.navigationController?.navigationItem.title = dateString
        noteDetailController.navigationTitle = dateString
        
        var cellColor: UIColor = .blue2
        cellColor = Colors.colorFromString(string: color)
        
        noteDetailController.backgroundColor = cellColor
        noteDetailController.detailText = content
        noteDetailController.index = indexPath.row
        
        navigationController?.pushViewController(noteDetailController, animated: true)
    }
    
    @objc func longTouchHandler(sender: UILongPressGestureRecognizer) {
        let location = sender.location(in: collectionView)
        let indexPath = collectionView.indexPathForItem(at: location)
        
        let note = notes[indexPath?.row ?? 0]
        let color = note.value(forKey: "color") as! String
        let content = note.value(forKey: "content") as! String
        var cellColor = UIColor(red: 18 / 255.0, green: 165 / 255.0, blue: 244 / 255.0, alpha: 1.0)
        cellColor = Colors.colorFromString(string: color)
        
        let actionController = SkypeActionController()
        
        if defaults.bool(forKey: "darkModeEnabled") == false {
            actionController.backgroundColor = cellColor
            
        } else if defaults.bool(forKey: "darkModeEnabled") == true {
            actionController.backgroundColor = InterfaceColors.actionSheetColor
        }
        
        actionController.addAction(Action("Share note", style: .default, handler: { _ in
            print("Share note")
            self.shareNote(text: content)
            
        }))
        
        actionController.addAction(Action("Delete note", style: .default, handler: { _ in
            print("Delete note")
            
            if self.defaults.bool(forKey: "showAlertOnDelete") == true {
                let alert = UIAlertController(title: "Are you sure?", message: "This will permanently delete this note in both iCloud and locally on this device. This message can be disabled from settings.", preferredStyle: .alert)
                
                alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { _ in
                    self.deleteNote(indexPath: indexPath ?? [0, 0])
                }))
                
                alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                self.present(alert, animated: true)
                
            } else if self.defaults.bool(forKey: "showAlertOnDelete") == false {
                self.deleteNote(indexPath: indexPath ?? [0, 0])
            }
            
        }))
        
        actionController.addAction(Action("Select multiple", style: .default, handler: { _ in
            print("Select multiple")
            CellStates.shouldSelectMultiple = true
            self.setupMultiSelectionToolBar()
            
        }))
        
        actionController.addAction(Action("Cancel", style: .cancel, handler: nil))
        
        present(actionController, animated: true, completion: nil)
    }
    
    func setupMultiSelectionToolBar() {
        let toolBar = navigationController?.toolbar
        if UserDefaults.standard.bool(forKey: "vibrantDarkModeEnabled") == true {
            toolBar?.tintColor = .white
            toolBar?.barTintColor = .grayBackground
            toolBar?.sizeToFit()
        } else if UserDefaults.standard.bool(forKey: "pureDarkModeEnabled") == true {
            toolBar?.tintColor = .white
            toolBar?.barTintColor = .black
            toolBar?.sizeToFit()
            
        } else {
            toolBar?.tintColor = nil
            toolBar?.barTintColor = nil
            toolBar?.sizeToFit()
        }
        
        navigationController?.setToolbarHidden(false, animated: true)
                
        var items = [UIBarButtonItem]()
        
        items.append(UIBarButtonItem(title: "Cancel", style: .done, target: self, action: #selector(removeMultipleSelection)))
        items.append(UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil))
        items.append(UIBarButtonItem(title: "Delete", style: .done, target: self, action: #selector(deleteSelectedCells)))
        
        toolbarItems = items
    }
    
    @objc func removeMultipleSelection() {
        navigationController?.setToolbarHidden(true, animated: true)
        
        let selectedItems = collectionView.indexPathsForSelectedItems ?? []
        
        for value in selectedItems {
            collectionView.deselectItem(at: value, animated: true)
        }
        
        CellStates.shouldSelectMultiple = false
    }
    
    @objc func deleteSelectedCells() {
        let selectedItems = collectionView.indexPathsForSelectedItems ?? []
        
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        let managedContext = appDelegate?.persistentContainer.viewContext
        
        var selectedNotes: [Note] = []
        
        for value in selectedItems {
            selectedNotes.append(notes[value.row])
        }
        
        for note in selectedNotes {
            managedContext?.delete(note)
        }
        
        CoreDataManager.shared.enqueue { context in
            do {
                try context.save()
                
            } catch let error as NSError {
                print("Could not save. \(error), \(error.userInfo)")
            }
        }
        
        fetchNotesFromCoreData()
    }
    
    func shareNote(text: String) {
        let textToShare = text
        let objectsToShare = [textToShare] as [Any]
        let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
        activityVC.excludedActivityTypes = [UIActivity.ActivityType.airDrop, UIActivity.ActivityType.addToReadingList]
        
        present(activityVC, animated: true, completion: nil)
    }
    
    func deleteNote(indexPath: IndexPath) {
        if isFiltering() == false {
            let note = notes[indexPath.row]
            // remove pending notification
            let notificationUUID = note.notificationUUID ?? "empty error in SavedNoteController"
            let center = UNUserNotificationCenter.current()
            center.removePendingNotificationRequests(withIdentifiers: [notificationUUID])
            
            // remove notification on badge if already delivered but not opened
            let isReminder = note.isReminder
            if isReminder == true {
                let reminderDate = note.reminderDate ?? "07/02/2000 11:11 PM"
                
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "MM/dd/yyyy hh:mm a"
                let formattedReminderDate = dateFormatter.date(from: reminderDate) ?? Date()
                
                let currentDate = Date()
                
                if currentDate >= formattedReminderDate {
                    UIApplication.shared.applicationIconBadgeNumber -= 1
                }
            }
            
            notes.remove(at: indexPath.row)
            
            let appDelegate = UIApplication.shared.delegate as? AppDelegate
            let managedContext = appDelegate?.persistentContainer.viewContext
            managedContext?.delete(note)
            
        } else {
            let filteredNote = filteredNotes[indexPath.row]
            
            // remove pending notification
            let notificationUUID = filteredNote.notificationUUID ?? "empty error in SavedNoteController"
            let center = UNUserNotificationCenter.current()
            center.removePendingNotificationRequests(withIdentifiers: [notificationUUID])
            
            // remove notification on badge if already delivered but not opened
            let isReminder = filteredNote.isReminder
            if isReminder == true {
                let reminderDate = filteredNote.reminderDate ?? "07/02/2000 11:11 PM"
                
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "MM/dd/yyyy hh:mm a"
                let formattedReminderDate = dateFormatter.date(from: reminderDate) ?? Date()
                
                let currentDate = Date()
                
                if currentDate >= formattedReminderDate {
                    UIApplication.shared.applicationIconBadgeNumber -= 1
                }
            }
            
            filteredNotes.remove(at: indexPath.row)
            
            let appDelegate = UIApplication.shared.delegate as? AppDelegate
            let managedContext = appDelegate?.persistentContainer.viewContext
            managedContext?.delete(filteredNote)
        }
        
        CoreDataManager.shared.enqueue { context in
            do {
                try context.save()
                
            } catch let error as NSError {
                print("Could not save. \(error), \(error.userInfo)")
            }
        }
        
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
    
    func deleteEmptyNote(note: Note) {
        // remove pending notification
        let notificationUUID = note.notificationUUID ?? "empty error in SavedNoteController"
        let center = UNUserNotificationCenter.current()
        center.removePendingNotificationRequests(withIdentifiers: [notificationUUID])
        
        // remove notification on badge if already delivered but not opened
        let isReminder = note.isReminder
        if isReminder == true {
            let reminderDate = note.reminderDate ?? "07/02/2000 11:11 PM"
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MM/dd/yyyy hh:mm a"
            let formattedReminderDate = dateFormatter.date(from: reminderDate) ?? Date()
            
            let currentDate = Date()
            
            if currentDate >= formattedReminderDate {
                UIApplication.shared.applicationIconBadgeNumber -= 1
            }
        }
        
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        let managedContext = appDelegate?.persistentContainer.viewContext
        managedContext?.delete(note)
        
        CoreDataManager.shared.enqueue { context in
            do {
                try context.save()
                
            } catch let error as NSError {
                print("Could not save. \(error), \(error.userInfo)")
            }
        }
        
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
    
    func feedbackOnPress() {
        if UIDevice.current.hasTapticEngine == true {
            // iPhone 6s and iPhone 6s Plus
            let peek = SystemSoundID(1519)
            AudioServicesPlaySystemSoundWithCompletion(peek, nil)
            
        } else if UIDevice.current.hasHapticFeedback == true {
            // iPhone 7 and newer
            let generator = UIImpactFeedbackGenerator(style: .medium)
            generator.impactOccurred()
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if notes.isEmpty {
            self.collectionView.backgroundView = emptyView
        } else {
            self.collectionView.backgroundView = nil
            if isFiltering() {
                return filteredNotes.count
            } else {
                return notes.count
            }
        }
        return notes.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, shouldDeselectItemAt indexPath: IndexPath) -> Bool {
        if let selectedItems = collectionView.indexPathsForSelectedItems {
            if selectedItems.contains(indexPath) {
                collectionView.deselectItem(at: indexPath, animated: true)
                return false
            }
        }
        return true
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SavedNoteCell", for: indexPath) as? SavedNoteCell else { fatalError("Wrong cell class dequeued") }
        
        var note = notes[indexPath.row]
        
        if isFiltering() {
            note = filteredNotes[indexPath.row]
        } else {
            note = notes[indexPath.row]
        }
        
        let content = note.value(forKey: "content") as? String
        let color = note.value(forKey: "color") as? String ?? "blue2"
        let modifiedDate = note.value(forKey: "modifiedDate") as? Double ?? 0
        let isReminder = note.value(forKey: "isReminder") as? Bool
        
        cell.textLabel.text = content
        cell.textLabel.textColor = UIColor.white
        cell.dateLabel.textColor = UIColor.white
        
        let updateDate = Date(timeIntervalSinceReferenceDate: modifiedDate)
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.long
        dateFormatter.timeZone = .current
        let dateString = dateFormatter.string(from: updateDate)
        cell.dateLabel.text = dateString
        
        let cellColor = Colors.colorFromString(string: color)
        
        if cellColor == UIColor.white {
            cell.textLabel.textColor = .black
            cell.dateLabel.textColor = .black
        }
        
        if defaults.bool(forKey: "darkModeEnabled") == true {
            if defaults.bool(forKey: "vibrantDarkModeEnabled") == true {
                cell.contentView.backgroundColor = cellColor
                cell.contentView.tintColor = cellColor
                
            } else if defaults.bool(forKey: "pureDarkModeEnabled") == true {
                cell.contentView.backgroundColor = UIColor.offBlackBackground
                cell.contentView.tintColor = UIColor.offBlackBackground
            }
            
        } else {
            cell.contentView.backgroundColor = cellColor
            cell.contentView.tintColor = cellColor
        }
        
        if isReminder == true {
            cell.layer.borderWidth = 5.5
            
            if UserDefaults.standard.bool(forKey: "pureDarkModeEnabled") == true {
                cell.layer.borderColor = UIColor.grayBackground.adjust(by: 10)?.cgColor
                cell.layer.cornerRadius = 5
                
            } else {
                cell.layer.borderColor = cellColor.adjust(by: 10)?.cgColor
                cell.layer.cornerRadius = 5
            }
            
        } else {
            cell.layer.borderWidth = 0
            cell.layer.borderColor = cellColor.cgColor
            cell.layer.cornerRadius = 0
        }
        
        cell.contentView.layer.cornerRadius = 5
        cell.layer.shouldRasterize = true
        cell.layer.rasterizationScale = UIScreen.main.scale
        
        if UserDefaults.standard.bool(forKey: "darkModeEnabled") == false {
            cell.layer.addShadow(color: UIColor.darkGray)
        }
        
        cell.contentView.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(longTouchHandler(sender:))))
        
        return cell
    }
}

extension SavedNoteController: CollectionViewFlowLayoutDelegate {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var height: CGFloat = 0
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            height = 120
        } else if UIDevice.current.userInterfaceIdiom == .phone {
            height = 110
        }

        return CGSize(width: UIScreen.main.bounds.width, height: height)
    }
}

extension SavedNoteController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
}
