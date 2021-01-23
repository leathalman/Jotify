//
//  WriteNoteContrller.swift
//  Zurich
//
//  Created by Harrison Leath on 1/12/21.
//

import UIKit

class WriteNoteController: UIViewController, UITextViewDelegate {
    let draftView = DraftView()
    var hasCreatedDocument = false
    var timer: Timer?
    var documentID: String?
    
    //life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        handleSend()
    }
    
    //view configuration
    func setupView() {
        view = draftView
        draftView.backgroundColor = .systemBlue
        draftView.textField.delegate = self
        draftView.textField.frame = CGRect(x: 0, y: 100, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height / 4)
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        view.addGestureRecognizer(tap)
    }
    
    //textview logic
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        draftView.textField.becomeFirstResponder()
    }
    
    //definitely some room for error here...
    //if not careful, im sure this documentID stuff can crash the app
    @objc func handleSend() {
        if !draftView.textField.text.isEmpty {
            DataManager.updateNote(content: draftView.textField.text, uid: documentID ?? "") { (success) in
                //handle success here
            }
            timer?.invalidate()
            hasCreatedDocument = false
            draftView.textField.text = ""
        }
        draftView.textField.resignFirstResponder()
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if (text as NSString).rangeOfCharacter(from: CharacterSet.newlines).location == NSNotFound {
            return true
        }
        handleSend()
        return false
    }
    
    //timer functions for "automatically" saving once a user stops typing
    func resetTimer() {
        timer?.invalidate()
        let nextTimer = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(handleIdleEvent), userInfo: nil, repeats: false)
        timer = nextTimer
    }
    
    @objc func handleIdleEvent() {
        if !draftView.textField.text.isEmpty {
            DataManager.updateNote(content: draftView.textField.text, uid: documentID ?? "") { (success) in
                //handle success here
                print("NOTE UPDATED WITH TEXT: \(self.draftView.textField.text)")
            }
        }
    }
    
    //this will act weird if if the user immediately leaves the app... so maybe add some character qualitifer??
    //like 2 letters or more to make the doc??
    //could probably add some function to check if the text is identical to prevent taht extra
    //write call, but we'll see
    //DOESNT account for edge case of writing note, and then deleting it from draftview
    func textViewDidChange(_ textView: UITextView) {
        //set var to true
        //create the note here
        //save the note if user resigns the app?
        //could use the same timer function to save after 2 seconds or something...
        //and then figure out how handling send needs to work... I guess you could just
        //upadate instead of creating, this added an additional write to the database...
        //but I think that doesnt REALLY matter too much
        if !hasCreatedDocument {
            documentID = DataManager.createNote(content: draftView.textField.text, timestamp: Date.timeIntervalSinceReferenceDate)
            hasCreatedDocument = true
        } else if !draftView.textField.text.isEmpty {
            resetTimer()
        }
    }
    
    //resize the textfield frame each time the window size changes
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        let frame = CGRect(x: 0, y: 100, width: size.width, height: size.height / 4)
        draftView.textField.frame = frame
    }
}
