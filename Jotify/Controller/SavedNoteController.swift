//
//  SavedNoteController.swift
//  Sticky Notes
//
//  Created by Harrison Leath on 5/13/19.
//  Copyright © 2019 Harrison Leath. All rights reserved.
//

import UIKit
import CloudKit
import CoreData
import Blueprints

class SavedNoteController: UICollectionViewController, UINavigationBarDelegate {
    
    var notes = [NSManagedObject]()
    var filteredNotes = [NSManagedObject]()
    
    let searchController = UISearchController(searchResultsController: nil)
    
    let blueprintLayout = VerticalBlueprintLayout(
        itemsPerRow: 2.0,
        minimumInteritemSpacing: 10,
        minimumLineSpacing: 15,
        sectionInset: EdgeInsets(top: 10, left: 10, bottom: 10, right: 10),
        stickyHeaders: false,
        stickyFooters: false)
    
    public var screenWidth: CGFloat {
        return UIScreen.main.bounds.width
    }
    
    public var screenHeight: CGFloat {
        return UIScreen.main.bounds.height
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
        navigationController?.navigationBar.prefersLargeTitles = true
        
        collectionView.frame = self.view.frame
        collectionView.backgroundColor = UIColor(named: "viewBackgroundColor")
        collectionView.setCollectionViewLayout(blueprintLayout, animated: true)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.register(SavedNoteCell.self, forCellWithReuseIdentifier: "SavedNoteCell")
        view.addSubview(collectionView)
        
        setupSearchBar()
    }
    
    func setupSearchBar() {
        searchController.searchResultsUpdater = self as? UISearchResultsUpdating
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Notes"
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
    
    func searchBarIsEmpty() -> Bool {
        // Returns true if the text is empty or nil
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    // MARK: - Filter Search Results
    // MARK: - Current Rule "Content"
//    func filterContentForSearchText(_ searchText: String, scope: String = "All") {
//        filteredNotes = notes.filter({( note : Note) -> Bool in
//
//            return note.content?.lowercased().contains(searchText.lowercased())
//        })
//        collectionView.reloadData()
//    }
    
    func isFiltering() -> Bool {
        return searchController.isActive && !searchBarIsEmpty()
    }
    
    func fetchNotesFromCoreData() {
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        
        let managedContext =
            appDelegate.persistentContainer.viewContext
        
        let fetchRequest =
            NSFetchRequest<NSManagedObject>(entityName: "Note")
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
        
        do {
            notes = try managedContext.fetch(fetchRequest)
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
//    func deleteNote(recordID: CKRecord.ID) {
//
//        let recordID = recordID
//        CKContainer.default().privateCloudDatabase.delete(withRecordID: recordID) { (recordID, error) in
//            guard let recordID = recordID else {
//                print(error!.localizedDescription)
//                return
//            }
//            print("Record \(recordID) was successfully deleted")
//        }
//    }
    
    func deleteNote(_ note: NSManagedObject, at indexPath: IndexPath) {
        
    }
    
    func delete(cell: SavedNoteCell) {
        
        if let indexPath = collectionView?.indexPath(for: cell) {
            
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
            let context = appDelegate.persistentContainer.viewContext
            let itemToDelete = notes[indexPath.item]
            notes.remove(at: indexPath.item)
            context.delete(itemToDelete)
            collectionView!.deleteItems(at: [indexPath])
            appDelegate.saveContext()
        }
    }

    
    @objc func tap(_ sender: UITapGestureRecognizer) {
        
        let location = sender.location(in: self.collectionView)
        let indexPath = self.collectionView.indexPathForItem(at: location)

        if let index = indexPath {
            print("Got clicked on index: \(index)!")
            //will not actually refresh the view correctly because the array still contains the value even though the record is deleted
        }
    }
    
    @objc func handleSwipes(_ gesture: UISwipeGestureRecognizer) {
        if gesture.direction == .left {
            tabBarController?.selectedIndex = 1
            
        } else if gesture.direction == .right {
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
        
        let note = notes[indexPath.row]
        let content = note.value(forKey: "content") as? String
        let color = note.value(forKey: "color") as? String
        let date = note.value(forKey: "date") as? Double ?? 0
        
//        if isFiltering() {
//            notesData = filteredNotes[indexPath.row]
//        } else {
//            notesData = notes[indexPath.row]
//        }

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
        
        cell.contentView.layer.cornerRadius = 5
        cell.contentView.backgroundColor = cellColor
        cell.layer.addShadow(color: UIColor.darkGray)
        
        cell.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tap(_:))))
        
        return cell
    }
}

extension SavedNoteController: CollectionViewFlowLayoutDelegate {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let height: CGFloat = 110
        
        return CGSize(width: screenWidth, height: height)
    }
}

//extension SavedNoteController: UISearchResultsUpdating {
//    // MARK: - UISearchResultsUpdating Delegate
//    func updateSearchResults(for searchController: UISearchController) {
//        filterContentForSearchText(searchController.searchBar.text!)
//    }
//}
