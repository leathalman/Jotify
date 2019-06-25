//
//  SavedNoteController.swift
//  Sticky Notes
//
//  Created by Harrison Leath on 5/13/19.
//  Copyright © 2019 Harrison Leath. All rights reserved.
//

import UIKit
import CoreData
import Blueprints
import ViewAnimator

class SavedNoteController: UICollectionViewController, UINavigationBarDelegate {
    
    var notes: [Note] = []
    var filteredNotes: [Note] = []
    
    let searchController = UISearchController(searchResultsController: nil)
    
    let loadingAnimations = [AnimationType.from(direction: .bottom, offset: 30.0)]

    let blueprintLayout = VerticalBlueprintLayout(
        itemsPerRow: 2.0,
        minimumInteritemSpacing: 10,
        minimumLineSpacing: 15,
        sectionInset: EdgeInsets(top: 10, left: 10, bottom: 10, right: 10),
        stickyHeaders: false,
        stickyFooters: false)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        fetchNotesFromCoreData()
        animateCells()
    }
 
    func setupView() {
        navigationItem.title = "Saved Notes"
        navigationController?.navigationBar.prefersLargeTitles = false
        
        collectionView.frame = self.view.frame
        collectionView.backgroundColor = UIColor(named: "viewBackgroundColor")
        collectionView.setCollectionViewLayout(blueprintLayout, animated: true)
        collectionView.alwaysBounceVertical = true
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.register(SavedNoteCell.self, forCellWithReuseIdentifier: "SavedNoteCell")
        view.addSubview(collectionView)
        
        setupSearchBar()
        setupSwipes()
    }
    
    @objc func handleSwipes(_ gesture: UISwipeGestureRecognizer) {
        if gesture.direction == .left {
            tabBarController?.selectedIndex = 1
            
        } else if gesture.direction == .right {
        }
    }
    
    func setupSwipes() {
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(self.handleSwipes(_:)))
        swipeLeft.direction = .left
        view.addGestureRecognizer(swipeLeft)
        view.isUserInteractionEnabled = true
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(self.handleSwipes(_:)))
        swipeRight.direction = .right
        view.addGestureRecognizer(swipeRight)
        view.isUserInteractionEnabled = true
    }
    
    func setupSearchBar() {
        searchController.searchResultsUpdater = self as UISearchResultsUpdating
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Notes"
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
    
    func searchBarIsEmpty() -> Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    func filterContentForSearchText(_ searchText: String, scope: String = "All") {
        filteredNotes = notes.filter({( note : Note) -> Bool in
            return (note.content?.lowercased().contains(searchText.lowercased()) ?? false)
        })
        collectionView.reloadData()
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
        
        // MARK: - Sort Rules for CollectionView
        
        // implement sort by button with support for these sorting rules
        let sortDescriptorByDate = NSSortDescriptor(key: "date", ascending: false)
//        let sortDescriptorByColor = NSSortDescriptor(key: "color", ascending: false)
//        let sortDescriptorByContent = NSSortDescriptor(key: "content", ascending: true)

        fetchRequest.sortDescriptors = [sortDescriptorByDate]
        
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

        colorFromString(color, &cellColor)
        noteDetailController.backgroundColor = cellColor
        noteDetailController.detailText = content
        noteDetailController.index = rowNumber

//        present(noteDetailController, animated: true, completion: nil)
        navigationController?.pushViewController(noteDetailController, animated: true)
    }
    
    func longTouchHandler(sender: UILongPressGestureRecognizer) {
        print("Long Pressed")
    }
    
    @objc func forceTouchHandler(_ sender: ForceTouchGestureRecognizer) {
        UINotificationFeedbackGenerator().notificationOccurred(.success)
        print("Force touch triggered")
        
        let location = sender.location(in: self.collectionView)
        let indexPath = self.collectionView.indexPathForItem(at: location)
        let rowNumber : Int = indexPath?.row ?? 0
        
        //implement 3d touch with pressure here
        
        deleteNote(indexPath: indexPath ?? [0, 0], int: rowNumber)
    }
    
    func deleteNote(indexPath: IndexPath, int: Int) {
        let note = notes[indexPath.row]
        
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        //delete from Core Data storage
        managedContext.delete(note)
        
        //delete from array so that UICollectionView displays cells correctly
        notes.remove(at: int)
        
        appDelegate.saveContext()
        
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if isFiltering() {
            return filteredNotes.count
        } else {
            return notes.count
        }
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
        let color = note.value(forKey: "color") as? String ?? "systemTeal"
        let date = note.value(forKey: "date") as? Double ?? 0

        cell.textLabel.text = content?.trunc(length: 50)
        cell.textLabel.textColor = UIColor.white
        cell.dateLabel.textColor = UIColor.white

        let updateDate = Date(timeIntervalSinceReferenceDate: date)
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.long //Set date style
        dateFormatter.timeZone = .current
        let dateString = dateFormatter.string(from: updateDate)
        cell.dateLabel.text = dateString
        
        var cellColor = UIColor.white
        
        colorFromString(color, &cellColor)
        
        cell.contentView.layer.cornerRadius = 5
        cell.contentView.backgroundColor = cellColor
        cell.layer.addShadow(color: UIColor.darkGray)
        
        cell.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapHandler(_:))))
        cell.addGestureRecognizer(ForceTouchGestureRecognizer(target: self, action: #selector(forceTouchHandler(_:))))
        
        return cell
    }
    
    fileprivate func colorFromString(_ color: String, _ cellColor: inout UIColor) {
        if color == "systemTeal" {
            cellColor = UIColor.systemTeal
            
        } else if color == "systemGreen" {
            cellColor = UIColor.systemGreen
            
        } else if color == "systemRed" {
            cellColor = UIColor.systemRed
            
        } else if color == "systemBlue" {
            cellColor = UIColor.systemBlue
            
        } else if color == "systemPink" {
            cellColor = UIColor.systemPink
            
        } else if color == "systemOrange" {
            cellColor = UIColor.systemOrange
            
        } else if color == "systemPurple" {
            cellColor = UIColor.systemPurple
            
        } else if color == "systemTeal" {
            cellColor = UIColor.systemTeal
            
        } else if color == "systemYellow" {
            cellColor = UIColor.systemYellow
        }
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
