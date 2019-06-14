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
}

class SavedNoteController: UICollectionViewController, UINavigationBarDelegate {
    
    var notes = [Note]()
    
    let blueprintLayout = VerticalBlueprintLayout(
        itemsPerRow: 1.0,
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
        
        view.backgroundColor = Colors.lightGray
        
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
    
    override func viewDidAppear(_ animated: Bool) {
        fetchNotes()
    }
    
    func fetchNotes() {
        let pred = NSPredicate(value: true)
        let sort = NSSortDescriptor(key: "creationDate", ascending: false)
        let query = CKQuery(recordType: "note", predicate: pred)
        query.sortDescriptors = [sort]
        
        let operation = CKQueryOperation(query: query)
        operation.desiredKeys = ["content", "timeCreated"]
        operation.resultsLimit = 50
        
        var newNotes = [Note]()
        
        operation.recordFetchedBlock = { record in
            let note = Note()
            note.recordID = record.recordID
            note.content = record["content"]
            note.timeCreated = record["timeCreated"]
            newNotes.append(note)
        }
        
        operation.queryCompletionBlock = { [weak self] (cursor, error) in
            DispatchQueue.main.async {
                if error == nil {
                    self?.notes = newNotes
                    self?.collectionView.reloadData()
                } else {
                    let ac = UIAlertController(title: "Fetch failed", message: "There was a problem fetching the list of notes; please try again: \(error!.localizedDescription)", preferredStyle: .alert)
                    ac.addAction(UIAlertAction(title: "OK", style: .default))
                    self?.present(ac, animated: true)
                }
            }
        }
        CKContainer.default().privateCloudDatabase.add(operation)
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
        
        let rawTime = notesData.timeCreated!
        let date = Date(timeIntervalSinceReferenceDate: rawTime)
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.long //Set date style
        dateFormatter.timeZone = .current
        let localDate = dateFormatter.string(from: date)
        cell.dateLabel.text = localDate

        cell.contentView.backgroundColor = .white
        cell.contentView.layer.cornerRadius = 10
        cell.layer.addShadow(color: UIColor.darkGray)
        
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
        let padding: CGFloat = 60
        
        //estimate each cell's height
        if let text = notes[indexPath.item].content {
            height = estimateFrameForText(text: text).height + padding
        }
        return CGSize(width: screenWidth, height: height)

    }
}
