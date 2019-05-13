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

struct Note {
    let text: String
}

class SavedNoteController: UIViewController, UICollectionViewDelegateFlowLayout {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let text = UITextView()
        text.text = "Note Collection"
        view.backgroundColor = .white
        let drawer = addDrawerView(withViewController: WriteNoteController(), parentView: view)
        drawer.position = .open
    }
    
    override func viewDidAppear(_ animated: Bool) {
        fetchNotes()
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
                    print(text)
                    //                    Note.init(text: text)
                    
                    //                    self.items.removeAll()
                    //                    self.items.append(Note.init(text: text))
                    
                }
            }
        }
    }
    
}

