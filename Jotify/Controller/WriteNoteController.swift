//
//  WriteNoteContrller.swift
//  Zurich
//
//  Created by Harrison Leath on 1/12/21.
//

import UIKit

class WriteNoteController: UIViewController, UITextViewDelegate {
    let draftView = DraftView()
    
    //used within timer logic to determine and save current note dynamically
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
    
    //whenever the area around the textView is tapped, bring up the keyboard
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        draftView.textField.becomeFirstResponder()
    }
    
    //invalidate timer, reset timer-related variables, and do a final update on the document
    //clean up the UI by emptying the textView and resigning keyboard
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
            }
        }
    }
    
    //whenever user types, update the document and reset the timer
    func textViewDidChange(_ textView: UITextView) {
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
