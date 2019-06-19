//
//  SavedNoteController.swift
//  Sticky Notes
//
//  Created by Harrison Leath on 5/13/19.
//  Copyright © 2019 Harrison Leath. All rights reserved.
//

import UIKit
import Blueprints
import CloudKit

class Note: NSObject {
    var recordID: CKRecord.ID!
    var content: String!
    var timeCreated: Double!
    var color: String!
}

class SavedNoteController: UICollectionViewController, UINavigationBarDelegate {
    
    var notes = [Note]()
    
    let blueprintLayout = VerticalBlueprintLayout(
        itemsPerRow: 2.0,
        minimumInteritemSpacing: 10,
        minimumLineSpacing: 15,
        sectionInset: EdgeInsets(top: 10, left: 10, bottom: 10, right: 10),
        stickyHeaders: true,
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
        view.backgroundColor = UIColor.white
        
        title = "Notes"
        
        self.navigationController?.navigationBar.prefersLargeTitles = true
        
        collectionView.frame = self.view.frame
        collectionView.setCollectionViewLayout(blueprintLayout, animated: true)
        collectionView.backgroundColor = .white
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(SavedNoteCell.self, forCellWithReuseIdentifier: "SavedNoteCell")
        view.addSubview(collectionView)
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
        
        return notes.count
    }
    
    //TODO use instruments to find out how to optimize loading, this is a temporary fix
    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SavedNoteCell", for: indexPath) as? SavedNoteCell else {fatalError("Wrong cell class dequeued")}
    
        let notesData = notes[indexPath.row]
        let noteText = notesData.content
        cell.textLabel.text = noteText
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

extension SavedNoteController: CollectionViewFlowLayoutDelegate {
    
    private func estimateFrameForText(text: String) -> CGRect {
        //we make the height arbitrarily large so we don't undershoot height in calculation
        let height: CGFloat = 0

        let size = CGSize(width: screenWidth, height: height)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        let attributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18, weight: UIFont.Weight.bold)]

        return NSString(string: text).boundingRect(with: size, options: options, attributes: attributes, context: nil)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        var height: CGFloat = 0

        //we are just measuring height so we add a padding constant to give the label some room to breathe!
        let padding: CGFloat = 100

        //estimate each cell's height
        if let text = notes[indexPath.item].content {
            height = estimateFrameForText(text: text).height + padding
        }
        return CGSize(width: screenWidth, height: height)

    }
}
