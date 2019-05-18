//
//  WriteNoteController.swift
//  Sticky Notes
//
//  Created by Harrison Leath on 5/12/19.
//  Copyright © 2019 Harrison Leath. All rights reserved.
//

import UIKit
import Firebase
import MultilineTextField

struct Note {
    static var text: String = "Default Text"
    static var noteId: String = "Default Id"
}

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
    
    lazy var tabImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "Tab")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.isUserInteractionEnabled = false
        return imageView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        checkIfUserIsLoggedIn()
        setupView()
        setupSwipeDown()
    }
    
    func setupSwipeDown() {
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(self.handleSwipeDown(_:)))
        swipeDown.direction = .down
        view.addGestureRecognizer(swipeDown)
        view.isUserInteractionEnabled = true
    }
    
    @objc func handleSwipeDown(_ sender: UITapGestureRecognizer) {
        present(SavedNoteController(), animated: true, completion: nil)
    }
    
    func setupView() {
        view.clipsToBounds = true
        view.layer.cornerRadius = 10
        inputTextView.delegate = self

        view.addSubview(inputTextView)
        view.addSubview(tabImageView)
        setupContraints()
        addGradient()
    }
    
    func setupContraints() {
//        tabImageView.heightAnchor.constraint(equalToConstant: 0).isActive = true
        tabImageView.centerYAnchor.constraint(equalTo: inputTextView.topAnchor, constant: -85).isActive = true
        tabImageView.centerXAnchor.constraint(equalTo: inputTextView.centerXAnchor).isActive = true
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
        
        var ref: DocumentReference? = nil
        ref = db.collection("notes").addDocument(data: [
            "text": text,
            "timestamp": "Timestamp",
        ]) { err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                print("Document added with ID: \(ref!.documentID)")
         //This is where you would make a struct and add the DocumentID to retrieve later
                Note.text = text
                Note.noteId = ref!.documentID
                print("This is note text: \(Note.text)")
                print("This is note id: \(Note.noteId)")
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
//        self.inputTextView.text = ""
        return false
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        handleSend()
        inputTextView.text = ""
        return true
    }
    
    @objc private func logoutTapped() {
        handleLogout()
    }
    
    @objc private func sendTapped() {
        handleSend()
    }
    
    @objc private func removeTapped() {
        db.collection("notes").document("DC").delete() { err in
            if let err = err {
                print("Error removing document: \(err)")
            } else {
                print("Document successfully removed!")
            }
        }
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
