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
    
    var notes: [Note] = []
    var filteredNotes: [Note] = []
    
    let searchController = UISearchController(searchResultsController: nil)
    
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
            notes = try managedContext.fetch(fetchRequest) as! [Note]
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
    @objc func tap(_ sender: UITapGestureRecognizer) {
        
        let location = sender.location(in: self.collectionView)
        let indexPath = self.collectionView.indexPathForItem(at: location)
//        print(indexPath)
        
//        var indexPath : NSIndexPath = self.collectionView.indexPathForItemAtPoint(location)!
        
        let rowNumber : Int = indexPath?.row ?? 0

        let noteDetailController = NoteDetailController()
        
        let note = notes[indexPath?.row ?? 0]
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
        
        navigationController?.pushViewController(noteDetailController, animated: true)
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
        
        cell.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tap(_:))))
        
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
    // MARK: - UISearchResultsUpdating Delegate
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
}
