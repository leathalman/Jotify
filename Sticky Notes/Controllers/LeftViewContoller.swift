//
//  LeftViewContoller.swift
//  Sticky Notes
//
//  Created by Harrison Leath on 5/8/19.
//  Copyright © 2019 Harrison Leath. All rights reserved.
//

import UIKit
import Firebase
import LBTATools

class NoteCell: LBTAListCell<Note> {
    
    let imageView = UIImageView(image: nil, contentMode: .scaleAspectFill)
    
    let noteNameLabel = UILabel(text: "Sample Note", font: .boldSystemFont(ofSize: 14), textColor: .white)
    
    override var item: Note! {
        didSet {
            noteNameLabel.text = item.text
        }
    }
    
    override func setupViews() {
        super.setupViews()
        
        backgroundColor = .darkGray
        layer.cornerRadius = 20
        
        hstack(noteNameLabel)
    }
}

struct Note {
    let text: String
}

class LeftViewController: LBTAListController<NoteCell, Note>, UICollectionViewDelegateFlowLayout {
    
    var noteArray: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.backgroundColor = .white
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        fetchNotes()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: view.frame.width, height: 80)
    }

    func fetchNotes() {
        let ref = Database.database().reference()
        let query = ref.child("notes").queryOrdered(byChild: "userId")
        query.observe(.value) { (snapshot) in
            for child in snapshot.children.allObjects as! [DataSnapshot] {
                if let value = child.value as? NSDictionary {
//                    let timestamp = value["timestamp"] as? String ?? "Timestamp not found"
//                    let userId = value["userId"] as? String ?? "UserId not found"
                    let text = value["text"] as? String ?? "Text not found"
                    
//                    self.items.removeAll()
                    self.items.append(Note.init(text: text))

                }
            }
        }
    }
    
    
    
}
