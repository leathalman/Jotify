//
//  WriteNoteController.swift
//  Sticky Notes
//
//  Created by Harrison Leath on 5/12/19.
//  Copyright © 2019 Harrison Leath. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore
import FirebaseAuth
import MultilineTextField

class WriteNoteController: UIViewController, UITextViewDelegate, UITextFieldDelegate {
    
    let db = Firestore.firestore()
        
    public var screenWidth: CGFloat {
        return UIScreen.main.bounds.width
    }
    
    public var screenHeight: CGFloat {
        return UIScreen.main.bounds.height
    }
    
    lazy var inputTextView: MultilineTextField = {
        let frame = CGRect(x: 0, y: 100, width: screenWidth, height: screenHeight)
        let textField = MultilineTextField(frame: frame)
        textField.backgroundColor = .clear
        textField.placeholderColor = Colors.darkBlue
        textField.textColor = .white
        textField.isPlaceholderScrollEnabled = true
        textField.leftViewOrigin = CGPoint(x: 8, y: 8)
        textField.font = UIFont.boldSystemFont(ofSize: 32)
        textField.textContainerInset = UIEdgeInsets(top: 10, left: 15, bottom: 10, right: 15)
        
        if screenWidth < 650 {
            textField.placeholder = "Write it down..."
        } else {
            textField.placeholder = "What's on your mind..."
        }
        
        return textField
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        checkIfUserIsLoggedIn()
        setupView()
        setupSwipes()
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
    
    @objc func handleSwipes(_ gesture: UISwipeGestureRecognizer) {
        if gesture.direction == .left {
            tabBarController?.selectedIndex = 2
        } else if gesture.direction == .right {
            tabBarController?.selectedIndex = 0
        }
    }
    
    func setupView() {
        title = "Write"
        
        view.clipsToBounds = true
        inputTextView.delegate = self

        view.addSubview(inputTextView)
        addGradient()
    }
    
    func addGradient() {
        view.backgroundColor = UIColor.clear
        let backgroundLayer = Colors().blueGradient
        backgroundLayer?.frame = view.frame
        view.layer.insertSublayer(backgroundLayer!, at: 0)
    }
    
    @objc func handleSend() {
        
        if inputTextView.text == "" {
            
        } else {
            saveNote(text: inputTextView.text)
            inputTextView.text = ""
        }
    }
    
    func saveNote(text: String) {
        
        let uid = Auth.auth().currentUser?.uid
        let timestamp = (NSDate().timeIntervalSince1970)
        var ref: DocumentReference? = nil
        ref = db.collection("notes").addDocument(data: [
            "text": text,
            "timestamp": timestamp,
            "userId": uid!
        ]) { err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                print("Document added with ID: \(ref!.documentID)")
                
//                let note = Note()
//                note.text = text
//                note.noteId = ref!.documentID
//                note.userId = uid!
//
//                self.notes.append(note)
//                print(self.notes)
                
                let savedNoteController = SavedNoteController()
                savedNoteController.fetchNotes()
            }
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if (text as NSString).rangeOfCharacter(from: CharacterSet.newlines).location == NSNotFound {
            return true
        }
        
        //dismiss keyboard on return key
        textView.resignFirstResponder()
        handleSend()
        
        return false
    }
    
    func checkIfUserIsLoggedIn() {
        //user is not logged in
        if Auth.auth().currentUser?.uid == nil {
            perform(#selector(handleLogout), with: nil, afterDelay: 0)
            handleLogout()
            
        } else {
            print("Logged in")
        }
    }
    
    @objc func handleLogout() {
        
        do {
            try Auth.auth().signOut()
        } catch _ {
            print("Logout Error!")
            
        }
        
        let loginController = LoginController()
        loginController.writeNoteContoller = self
        present(loginController, animated: true, completion: nil)
    }
}
