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

struct Note {
    static var text: String = "Default Text"
    static var noteId: String = "Default NoteId"
    static var timestamp: NSNumber = 0
}

//need to put all of the texts into an array and then can call the cell with IndexPath to get them to spit out in an order instead of overwriting each other, not sure how to use dictionaries but should probably figure out how to... need to get data, add it to struct and array as a single dictionary action and then use this array to create number of cells and text of cells... ugh, passing data is actually really hard, more to learn I guess

class SavedNoteController: UIViewController, UICollectionViewDelegate, UINavigationBarDelegate, UICollectionViewDelegateFlowLayout {
    
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
        
        fetchNotes()
        setupView()
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
        view.backgroundColor = .white
        
        title = "Notes"
        
        self.navigationController?.navigationBar.prefersLargeTitles = true

        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 20
        layout.sectionInset = UIEdgeInsets(top: 25, left: 0, bottom: 10, right: 0)
        
        let collectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
        layout.itemSize = CGSize(width: collectionView.frame.width - 20, height: 87)
        collectionView.backgroundColor = .white
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(SavedNoteCell.self, forCellWithReuseIdentifier: "SavedNoteCell")
        self.view.addSubview(collectionView)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
}

extension SavedNoteController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SavedNoteCell", for: indexPath) as? SavedNoteCell else {fatalError("Wrong cell class dequeued")}
        
        cell.contentView.backgroundColor = .white
        cell.contentView.layer.cornerRadius = 10
        cell.contentView.layer.borderWidth = 1
        cell.contentView.layer.borderColor = UIColor.clear.cgColor
        cell.contentView.layer.masksToBounds = true
        
        cell.layer.shadowColor = UIColor.lightGray.cgColor
        cell.layer.shadowOffset = CGSize(width:0,height: 2)
        cell.layer.shadowRadius = 2
        cell.layer.shadowOpacity = 1
        cell.layer.masksToBounds = false
        cell.layer.shadowPath = UIBezierPath(roundedRect:cell.bounds, cornerRadius:cell.contentView.layer.cornerRadius).cgPath
        
        
        cell.textLabel.text = Note.text
        
        return cell
    }
}
