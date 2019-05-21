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
import DrawerView
import VegaScrollFlowLayout

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
        
        navigationItem.title = "Settings"
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(handleDismiss))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handleDismiss))

        setupView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        fetchNotes()
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
    
    func setupView() {
        view.backgroundColor = .white
        
        let layout = VegaScrollFlowLayout()
        layout.minimumLineSpacing = 20
        layout.sectionInset = UIEdgeInsets(top: 110, left: 0, bottom: 10, right: 0)
        
        let collectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
        layout.itemSize = CGSize(width: collectionView.frame.width - 20, height: 87)
        collectionView.backgroundColor = .white
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(SavedNoteCell.self, forCellWithReuseIdentifier: "SavedNoteCell")
        self.view.addSubview(collectionView)
        
        
//        let frame = CGRect(x: 0, y: 0, width: screenWidth, height: 100)
//        let navbar = UINavigationBar(frame: frame)
//        navbar.backgroundColor = .white
//        navbar.delegate = self
//        navbar.prefersLargeTitles = true
//
//        let navItem = UINavigationItem()
//        navItem.title = "Saved Notes"
//        navbar.items = [navItem]
//
//        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelTapped))

        
//        view.addSubview(navbar)
        
        //        let drawer = addDrawerView(withViewController: WriteNoteController(), parentView: view)
        //        drawer.position = .open
    }
    
//    @objc func removeTapped () {
//        db.collection("notes").document("ref").delete() { err in
//            if let err = err {
//                print("Error removing document: \(err)")
//            } else {
//                print("Document successfully removed!")
//            }
//        }
//    }
    
    @objc func cancelTapped() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func handleDismiss() {
        dismiss(animated: true, completion: nil)
    }
    
}

extension SavedNoteController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return notes.count
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
