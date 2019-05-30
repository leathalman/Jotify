//
//  SavedNoteController.swift
//  Sticky Notes
//
//  Created by Harrison Leath on 5/13/19.
//  Copyright © 2019 Harrison Leath. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore
import FirebaseAuth
import Blueprints

struct Note {
    static var text: String = "Default Text"
    static var noteId: String = "Default NoteId"
    static var timestamp: NSNumber = 0
}

//need to put all of the texts into an array and then can call the cell with IndexPath to get them to spit out in an order instead of overwriting each other, not sure how to use dictionaries but should probably figure out how to... need to get data, add it to struct and array as a single dictionary action and then use this array to create number of cells and text of cells... ugh, passing data is actually really hard, more to learn I guess

class SavedNoteController: UICollectionViewController, UINavigationBarDelegate {
    
    let blueprintLayout = VerticalBlueprintLayout(
        itemsPerRow: 1.0,
        height: 87,
        minimumInteritemSpacing: 10,
        minimumLineSpacing: 15,
        sectionInset: EdgeInsets(top: 10, left: 10, bottom: 10, right: 10),
        stickyHeaders: true,
        stickyFooters: false)
    
    let db = Firestore.firestore()
    var notes = [Any]()
    
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
        
        fetchNotes()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //        fetchNotes()
    }
    
    func fetchNotes() {
        let uid = Auth.auth().currentUser?.uid
        db.collection("notes").whereField("userId", isEqualTo: uid ?? "Defualt Uid")
            .getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    for document in querySnapshot!.documents {
                        //when note is successfully added to firestore execute the following
                        let data = document.data()
                        let text = data["text"]
                        let timestamp = data["timestamp"]
                        
                        self.notes.append(text ?? "empty note array")
                        
                        Note.text = text as! String
                        Note.timestamp = timestamp as! NSNumber
                        
                    }
                }
        }
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
        return 15
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SavedNoteCell", for: indexPath) as? SavedNoteCell else {fatalError("Wrong cell class dequeued")}
        
        cell.contentView.backgroundColor = .white
        cell.contentView.layer.cornerRadius = 10
        
        cell.layer.addShadow(color: UIColor.darkGray)
        
//        cell.textLabel.text = Note.text
        
        return cell
    }
}
