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
        operation.desiredKeys = ["content"]
        operation.resultsLimit = 50
        
        var newNotes = [Note]()
        
        operation.recordFetchedBlock = { record in
            let note = Note()
            note.recordID = record.recordID
            note.content = record["content"]
            newNotes.append(note)
//            print(newNotes.count)
        }
        
        operation.queryCompletionBlock = { [unowned self] (cursor, error) in
            DispatchQueue.main.async {
                if error == nil {
                    self.notes = newNotes
                    self.collectionView.reloadData()
                } else {
                    let ac = UIAlertController(title: "Fetch failed", message: "There was a problem fetching the list of notes; please try again: \(error!.localizedDescription)", preferredStyle: .alert)
                    ac.addAction(UIAlertAction(title: "OK", style: .default))
                    self.present(ac, animated: true)
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
    
    func setupView() {
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return notes.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SavedNoteCell", for: indexPath) as? SavedNoteCell else {fatalError("Wrong cell class dequeued")}
    
        let content = notes[indexPath.row]
        let text = content.content

        cell.contentView.backgroundColor = .white
        cell.contentView.layer.cornerRadius = 10
        cell.textLabel.text = text
        
        cell.layer.addShadow(color: UIColor.darkGray)
        
        //        cell.textLabel.text = Note.text
        
        return cell
    }
}

extension SavedNoteController: CollectionViewFlowLayoutDelegate {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SavedNoteCell", for: indexPath) as? SavedNoteCell else {fatalError("Wrong cell class dequeued")}
        
        //TODO find more elegant soultion for sizing of cells... hard coding is not recommended
        let size = CGSize(width: 0, height: 87)
//        let numChars = cell.textLabel.text?.count ?? 38
//        let line = 38
        
//        if numChars <= line {
//            //            print("Less than or equal to 38 char")
//            size = CGSize(width: 0, height: 87)
//        } else if numChars <= line*2 {
//            //            print("Less than or equal to 76")
//            size = CGSize(width: 0, height: 87)
//
//        } else if numChars <= line*3 {
//            size = CGSize(width: 0, height: 87)
//
//        } else if numChars <= line*4 {
//            size = CGSize(width: 0, height: 120)
//
//        } else if numChars <= line*5 {
//            size = CGSize(width: 0, height: 140)
//
//        } else if numChars <= line*6 {
//            size = CGSize(width: 0, height: 160)
//
//        } else if numChars <= line*7 {
//            size = CGSize(width: 0, height: 180)
//
//        } else if numChars <= line*8 {
//            size = CGSize(width: 0, height: 200)
//
//        } else if numChars <= line*9 {
//            size = CGSize(width: 0, height: 220)
//
//        } else if numChars <= line*10 {
//            size = CGSize(width: 0, height: 240)
//
//        } else if numChars <= line*11 {
//            size = CGSize(width: 0, height: 260)
//
//        } else if numChars <= line*12 {
//            size = CGSize(width: 0, height: 280)
//
//        } else if numChars <= line*13 {
//            size = CGSize(width: 0, height: 300)
//
//        } else if numChars <= line*14 {
//            size = CGSize(width: 0, height: 320)
//
//        } else if numChars <= line*15 {
//            size = CGSize(width: 0, height: 340)
//
//        } else {
//            size = CGSize(width: 0, height: 360)
//        }
//
//        //        print(size)
        return size
    }
}
