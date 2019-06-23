//
//  SavedNoteController.swift
//  Sticky Notes
//
//  Created by Harrison Leath on 5/13/19.
//  Copyright © 2019 Harrison Leath. All rights reserved.
//

import UIKit
import CloudKit
import Blueprints

class Note: NSObject {
    var recordID: CKRecord.ID!
    var content: String!
    var timeCreated: Double!
    var color: String!
}

class SavedNoteController: UICollectionViewController, UINavigationBarDelegate {
    
    var notes = [Note]()
    var filteredNotes = [Note]()
    
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
        fetchNotes()
    }
    
    func setupView() {
        navigationItem.title = "Saved Notes"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        collectionView.frame = self.view.frame
        collectionView.backgroundColor = UIColor(named: "viewBackgroundColor")
        collectionView.setCollectionViewLayout(blueprintLayout, animated: true)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        //TODO: add prefetching for better loading experience
        collectionView.prefetchDataSource = self
        collectionView.isPrefetchingEnabled = true
        
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
        // Returns true if the text is empty or nil
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    // MARK: - Filter Search Results
    // MARK: - Current Rule "Content"
    func filterContentForSearchText(_ searchText: String, scope: String = "All") {
        filteredNotes = notes.filter({( note : Note) -> Bool in
            return note.content.lowercased().contains(searchText.lowercased())
        })
        collectionView.reloadData()
    }
    
    func isFiltering() -> Bool {
        return searchController.isActive && !searchBarIsEmpty()
    }
    
    func fetchNotes() {
        let pred = NSPredicate(value: true)
        let sort = NSSortDescriptor(key: "creationDate", ascending: false)
        let query = CKQuery(recordType: "note", predicate: pred)
        query.sortDescriptors = [sort]
        
        let operation = CKQueryOperation(query: query)
        operation.desiredKeys = ["content", "timeCreated", "color"]
        operation.resultsLimit = 50
        
        var newNotes = [Note]()
        
        if newNotes.count == 0 {
            
            operation.recordFetchedBlock = { record in
                let note = Note()
                note.recordID = record.recordID
                note.content = record["content"]
                note.timeCreated = record["timeCreated"]
                note.color = record["color"]
                newNotes.append(note)
            }
            
            operation.queryCompletionBlock = { [weak self] (cursor, error) in
                DispatchQueue.main.sync {
                    if error == nil {
                        self?.notes = newNotes
                        self?.collectionView.reloadData()
                        self?.collectionView.collectionViewLayout.invalidateLayout()
                        self?.collectionView.layoutSubviews()
                    } else {
                        let alert = UIAlertController(title: "Fetch failed", message: "There was a problem fetching the list of notes; please try again: \(error!.localizedDescription)", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .default))
                        self?.present(alert, animated: true)
                    }
                }
            }
            CKContainer.default().privateCloudDatabase.add(operation)
            
        } else {
            print("notes already fetched")
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
    
    func deleteNote(recordID: CKRecord.ID) {
        
        let recordID = recordID
        CKContainer.default().privateCloudDatabase.delete(withRecordID: recordID) { (recordID, error) in
            guard let recordID = recordID else {
                print(error!.localizedDescription)
                return
            }
            print("Record \(recordID) was successfully deleted")
        }
    }
    
    @objc func tap(_ sender: UITapGestureRecognizer) {
        
        let location = sender.location(in: self.collectionView)
        let indexPath = self.collectionView.indexPathForItem(at: location)
        let notesData = notes[indexPath?.row ?? 0]
        guard let recordID = notesData.recordID else { return }
        
        if let index = indexPath {
            print("Got clicked on index: \(index)!")
            deleteNote(recordID: recordID)
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
    
    //TODO use instruments to find out how to optimize loading, this is a temporary fix
    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SavedNoteCell", for: indexPath) as? SavedNoteCell else {fatalError("Wrong cell class dequeued")}
    
        let notesData: Note
        
        if isFiltering() {
            notesData = filteredNotes[indexPath.row]
        } else {
            notesData = notes[indexPath.row]
        }

        let noteText = notesData.content
        cell.textLabel.text = noteText?.trunc(length: 50)
        cell.textLabel.textColor = UIColor.white
        
        let rawTime = notesData.timeCreated ?? 0
        let date = Date(timeIntervalSinceReferenceDate: rawTime)
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.long //Set date style
        dateFormatter.timeZone = .current
        let localDate = dateFormatter.string(from: date)
        cell.dateLabel.text = localDate
        cell.dateLabel.textColor = UIColor.white
        let color = notesData.color
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

extension SavedNoteController: CollectionViewFlowLayoutDelegate, UICollectionViewDataSourcePrefetching{

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let height: CGFloat = 110
        
        return CGSize(width: screenWidth, height: height)
    }

    //TODO: add prefetching for a better loading experience
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {

    }
}

extension SavedNoteController: UISearchResultsUpdating {
    // MARK: - UISearchResultsUpdating Delegate
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
}
