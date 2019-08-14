//
//  SavedNoteController.swift
//  Sticky Notes
//
//  Created by Harrison Leath on 5/13/19.
//  Copyright © 2019 Harrison Leath. All rights reserved.
//

import UIKit
import CoreData
import AudioToolbox
import Blueprints
import ViewAnimator
import XLActionController

class SavedNoteController: UICollectionViewController, UISearchBarDelegate {
    
    var notes: [Note] = []
    var filteredNotes: [Note] = []
    
    var firstLaunch: Bool = true
    var pressed: Int = 0
    
    let searchController = UISearchController(searchResultsController: nil)
    let loadingAnimations = [AnimationType.from(direction: .top, offset: 30.0)]
    
    let defaults = UserDefaults.standard

    let blueprintLayout = VerticalBlueprintLayout(
        itemsPerRow: 2.0,
        minimumInteritemSpacing: 10,
        minimumLineSpacing: 15,
        sectionInset: EdgeInsets(top: 10, left: 10, bottom: 10, right: 10),
        stickyHeaders: false,
        stickyFooters: false)
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupSearchBar()
        
        if firstLaunch == true {
            fetchNotesFromCoreData()
            firstLaunch = false
        }

        setupDynamicViewElements()
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
        navigationItem.title = "Saved Notes"
        navigationController?.navigationBar.prefersLargeTitles = false

        navigationController?.navigationBar.isTranslucent = false
        extendedLayoutIncludesOpaqueBars = true

        let rightItem = UIBarButtonItem(image: UIImage(systemName: "arrow.up.arrow.down.circle"), style: .plain, target: self, action: #selector(handleRightButton))
        navigationItem.rightBarButtonItem  = rightItem

        let leftItem = UIBarButtonItem(image: UIImage(systemName: "gear"), style: .plain, target: self, action: #selector(handleLeftButton))
        navigationItem.leftBarButtonItem  = leftItem
        navigationItem.setHidesBackButton(true, animated: true)

        collectionView.frame = self.view.frame
        collectionView.alwaysBounceVertical = true

        collectionView.setCollectionViewLayout(blueprintLayout, animated: true)

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
            
            UIApplication.shared.windows.first?.backgroundColor = InterfaceColors.viewBackgroundColor

            setupDarkPersistentNavigationBar()
            
        } else {
            searchController.searchBar.barTintColor = InterfaceColors.searchBarColor
            searchController.searchBar.backgroundImage = nil
            
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
                actionController.backgroundColor = defaults.color(forKey: "staticNoteColor") ?? UIColor.white
                
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
            
            actionController.addAction(Action("Sort by date", style: .default, handler: { action in
                self.defaults.set("date", forKey: "sortBy")
                self.fetchNotesFromCoreData()
                self.animateCells()
                
            }))
            actionController.addAction(Action("Sort by color", style: .default, handler: { action in
                self.defaults.set("color", forKey: "sortBy")
                self.fetchNotesFromCoreData()
                self.animateCells()
                
            }))
            actionController.addAction(Action("Sort by content", style: .default, handler: { action in
                self.defaults.set("content", forKey: "sortBy")
                self.fetchNotesFromCoreData()
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
                
            }
            fetchNotesFromCoreData()
            animateCells()
        }
    }
    
    @objc func handleLeftButton() {
        feedbackOnPress()
        navigationController?.pushViewController(SettingsController(style: .grouped), animated: true)
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
            filteredNotes = notes.filter({( note : Note) -> Bool in
                return (note.content?.lowercased().contains(searchText.lowercased()) ?? false)
            })
            
            collectionView.reloadData()
            
        } else if searchController.searchBar.selectedScopeButtonIndex == 1 {
            filteredNotes = notes.filter({( note : Note) -> Bool in
                return (note.dateString?.lowercased().contains(searchText.lowercased()) ?? false)
            })
            
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
            sortDescriptor = NSSortDescriptor(key: "date", ascending: false)
            
        } else if sortBy == "color" {
            sortDescriptor = NSSortDescriptor(key: "color", ascending: false)
            
        }

        fetchRequest.sortDescriptors = [sortDescriptor] as? [NSSortDescriptor]
        
        do {
            notes = try managedContext.fetch(fetchRequest) as! [Note]
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
            
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
    func animateCells() {
        collectionView?.reloadData()
        collectionView?.performBatchUpdates({
            UIView.animate(views: self.collectionView!.orderedVisibleCells, animations: loadingAnimations, completion: {
            })
        }, completion: nil)
    }
    
    @objc func tapHandler(_ sender: UITapGestureRecognizer) {
        print("Tap triggered")

        let location = sender.location(in: self.collectionView)
        let indexPath = self.collectionView.indexPathForItem(at: location)
        let rowNumber : Int = indexPath?.row ?? 0

        let noteDetailController = NoteDetailController()

        var note = notes[indexPath?.row ?? 0]

        if isFiltering() {
            note = filteredNotes[indexPath?.row ?? 0]
            noteDetailController.filteredNotes = filteredNotes
            noteDetailController.isFiltering = true

        } else {
            note = notes[indexPath?.row ?? 0]
            noteDetailController.notes = notes
        }

        let date = note.value(forKey: "date")
        let color = note.value(forKey: "color") as! String
        let content = note.value(forKey: "content") as! String

        let updateDate = Date(timeIntervalSinceReferenceDate: date as! TimeInterval)
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.long //Set date style
        dateFormatter.timeZone = .current
        let dateString = dateFormatter.string(from: updateDate)

        noteDetailController.navigationController?.navigationItem.title = dateString
        noteDetailController.navigationTitle = dateString

        var cellColor: UIColor = .white
        cellColor = Colors.colorFromString(string: color)
        
        noteDetailController.backgroundColor = cellColor
        noteDetailController.detailText = content
        noteDetailController.index = rowNumber
        
        navigationController?.pushViewController(noteDetailController, animated: true)
    }
    
    @objc func longTouchHandler(sender: UILongPressGestureRecognizer) {
        
        let location = sender.location(in: self.collectionView)
        let indexPath = self.collectionView.indexPathForItem(at: location)
        let rowNumber : Int = indexPath?.row ?? 0
        
        let note = notes[indexPath?.row ?? 0]
        let color = note.value(forKey: "color") as! String
        let content = note.value(forKey: "content") as! String
        var cellColor = UIColor(red: 18/255.0, green: 165/255.0, blue: 244/255.0, alpha: 1.0)
        cellColor = Colors.colorFromString(string: color)
        
        let actionController = SkypeActionController()
        
        if defaults.bool(forKey: "darkModeEnabled") == false {
            actionController.backgroundColor = cellColor
            
        } else if defaults.bool(forKey: "darkModeEnabled") == true {
            actionController.backgroundColor = InterfaceColors.actionSheetColor
        }
        
        actionController.addAction(Action("Delete note", style: .default, handler: { action in
            print("Delete note")
            
            if self.defaults.bool(forKey: "showAlertOnDelete") == true {
                let alert = UIAlertController(title: "Are you sure?", message: "This will permanently delete this note in both iCloud and locally on this device.", preferredStyle: .alert)
                
                alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { (UIAlertAction) in
                    self.deleteNote(indexPath: indexPath ?? [0, 0], int: rowNumber)
                    
                }))
                
                alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                self.present(alert, animated: true)
                
            } else if self.defaults.bool(forKey: "showAlertOnDelete") == false {
                self.deleteNote(indexPath: indexPath ?? [0, 0], int: rowNumber)

            }
            
            
            
        }))
        actionController.addAction(Action("Share note", style: .default, handler: { action in
            print("Share note")
            //add function for sharing the text of notes
            self.shareNote(text: content)
            
        }))
        actionController.addAction(Action("Cancel", style: .cancel, handler: nil))
        
        present(actionController, animated: true, completion: nil)
    }
    
    func shareNote(text: String) {
        UIGraphicsBeginImageContext(view.frame.size)
        view.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        let textToShare = text
        
        if let myWebsite = URL(string: "http://itunes.apple.com/app/idXXXXXXXXX") {//Enter link to your app here
            let objectsToShare = [textToShare, myWebsite, image ?? #imageLiteral(resourceName: "iconLarge")] as [Any]
            let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
            
            activityVC.excludedActivityTypes = [UIActivity.ActivityType.airDrop, UIActivity.ActivityType.addToReadingList]
            
            self.present(activityVC, animated: true, completion: nil)
        }
    }
    
    func deleteNote(indexPath: IndexPath, int: Int) {
        let note = notes[indexPath.row]
        
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        
        managedContext.delete(note)
        
        notes.remove(at: int)
        
        appDelegate.saveContext()
        
        DispatchQueue.main.async {
            self.collectionView.reloadData()
            self.animateCells()
        }
    }
    
    func feedbackOnPress() {
        if UIDevice.current.hasTapticEngine == true {
            //iPhone 6s and iPhone 6s Plus
            let peek = SystemSoundID(1519)
            AudioServicesPlaySystemSoundWithCompletion(peek, nil)
            
        } else if UIDevice.current.hasHapticFeedback == true {
            //iPhone 7 and newer
            let generator = UIImpactFeedbackGenerator(style: .medium)
            generator.impactOccurred()
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if notes.count == 0 {
            self.collectionView.setEmptyView()
        } else {
            self.collectionView.restore()
            if isFiltering() {
                return filteredNotes.count
            } else {
                return notes.count
            }
        }
        return notes.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SavedNoteCell", for: indexPath) as? SavedNoteCell else {fatalError("Wrong cell class dequeued")}
        
        var note = notes[indexPath.row]
        
        if isFiltering() {
            note = filteredNotes[indexPath.row]
        } else {
            note = notes[indexPath.row]
        }
        
        let content = note.value(forKey: "content") as? String
        let color = note.value(forKey: "color") as? String ?? "white"
        let date = note.value(forKey: "date") as? Double ?? 0
        
        cell.textLabel.text = content
        cell.textLabel.textColor = UIColor.white
        cell.dateLabel.textColor = UIColor.white

        let updateDate = Date(timeIntervalSinceReferenceDate: date)
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
        
        cell.contentView.layer.cornerRadius = 5
        
        if defaults.bool(forKey: "darkModeEnabled") == true {
            
            if defaults.bool(forKey: "vibrantDarkModeEnabled") == true {
                cell.contentView.backgroundColor = cellColor
                
            } else if defaults.bool(forKey: "pureDarkModeEnabled") == true {
                cell.contentView.backgroundColor = UIColor.cellBlack
            }
            
        } else {
            cell.contentView.backgroundColor = cellColor
        }

        cell.layer.shouldRasterize = true
        cell.layer.rasterizationScale = UIScreen.main.scale
        cell.layer.addShadow(color: UIColor.darkGray)
        
        cell.contentView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapHandler(_:))))
        cell.contentView.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(longTouchHandler(sender:))))
        
        return cell
    }
}

extension SavedNoteController: CollectionViewFlowLayoutDelegate {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        let height: CGFloat = 110

        return CGSize(width: UIScreen.main.bounds.width, height: height)
    }
}

extension SavedNoteController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
}
