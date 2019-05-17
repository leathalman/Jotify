//
//  SavedNoteController.swift
//  Sticky Notes
//
//  Created by Harrison Leath on 5/13/19.
//  Copyright © 2019 Harrison Leath. All rights reserved.
//

import UIKit
import Firebase
import DrawerView
import VegaScrollFlowLayout

struct Note {
    let text: String
}

class SavedNoteController: UIViewController, UICollectionViewDelegate, UINavigationBarDelegate {
    
    let cellId = "SavedNoteCell"

    let db = Firestore.firestore()
    
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
//        fetchNotes()
    }
    
    func fetchNotes() {
        db.collection("notes").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    print("\(document.documentID) => \(document.data())")
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
        layout.itemSize = CGSize(width: collectionView.frame.width, height: 87)
        collectionView.backgroundColor = .white
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: cellId)
        self.view.addSubview(collectionView)
        
        let frame = CGRect(x: 0, y: 0, width: screenWidth, height: 100)
        let navbar = UINavigationBar(frame: frame)
        navbar.backgroundColor = .white
        navbar.delegate = self
        navbar.prefersLargeTitles = true
        
        let navItem = UINavigationItem()
        navItem.title = "Saved Notes"
        navbar.items = [navItem]
        
        view.addSubview(navbar)

//        let drawer = addDrawerView(withViewController: WriteNoteController(), parentView: view)
//        drawer.position = .open
    }
    
    @objc func removeTapped () {
        db.collection("notes").document("ref").delete() { err in
            if let err = err {
                print("Error removing document: \(err)")
            } else {
                print("Document successfully removed!")
            }
        }
    }
    
//    func fetchNotes() {
//        let ref = Database.database().reference()
//        let query = ref.child("notes").queryOrdered(byChild: "userId")
//        query.observe(.value) { (snapshot) in
//            for child in snapshot.children.allObjects as! [DataSnapshot] {
//                if let value = child.value as? NSDictionary {
//                    //                    let timestamp = value["timestamp"] as? String ?? "Timestamp not found"
//                    //                    let userId = value["userId"] as? String ?? "UserId not found"
//                    let text = value["text"] as? String ?? "Text not found"
//                    print(text)
//                    //                    Note.init(text: text)
//                    
//                    //                    self.items.removeAll()
//                    //                    self.items.append(Note.init(text: text))
//                    
//                }
//            }
//        }
//    }
    
}

extension SavedNoteController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 12
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath)
        
        cell.contentView.backgroundColor = .white
        cell.contentView.layer.cornerRadius = 10
        cell.contentView.layer.borderWidth = 1
        cell.contentView.layer.borderColor = UIColor.lightGray.cgColor
        cell.contentView.layer.masksToBounds = true
        
        cell.layer.shadowColor = UIColor.lightGray.cgColor
        cell.layer.shadowOffset = CGSize(width:0,height: 2)
        cell.layer.shadowRadius = 2
        cell.layer.shadowOpacity = 1
        cell.layer.masksToBounds = false
        cell.layer.shadowPath = UIBezierPath(roundedRect:cell.bounds, cornerRadius:cell.contentView.layer.cornerRadius).cgPath
        
        return cell
    }
    
}
