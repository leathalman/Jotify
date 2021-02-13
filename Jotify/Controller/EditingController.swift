//
//  EditingController.swift
//  Jotify
//
//  Created by Harrison Leath on 1/18/21.
//

import UIKit

class EditingController: UIViewController, UITextViewDelegate {
    let draftView = DraftView()
    
    var note: Note?
    var noteCollection: NoteCollection?
    
    var timer: Timer?
    
    //life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupNavBar()
        setupNotifications()
        //check this out, seems to cause a bug TODO
//        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "disableSwipe"), object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        updateContent(content: draftView.textField.text)
//        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "enableSwipe"), object: nil)
    }
    
    //view configuration
    func setupView() {
        view = draftView
        draftView.backgroundColor = note?.color.getColor()
        draftView.textField.text = note?.content
        draftView.textField.placeholder = ""
        draftView.textField.delegate = self
        draftView.textField.font = UIFont.boldSystemFont(ofSize: 18)
        draftView.textField.frame = CGRect(x: 0, y: 15, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - (navigationController?.navigationBar.bounds.height ?? 0) - 30)
    }
    
    func setupNavBar() {
        navigationItem.title = note?.timestamp.getDate()
        navigationController?.enablePersistence()
        navigationController?.setColor(color: note?.color.getColor() ?? .systemBlue)
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white]
        navigationItem.setHidesBackButton(true, animated: true)
        
        var cancel = UIImage(named: "cancel")
        cancel = cancel?.withRenderingMode(.alwaysOriginal)
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: cancel, style: .plain, target: self, action: #selector(handleCancel))
    }
   
    //action handlers
    @objc func handleCancel() {
        self.playHapticFeedback()
        navigationController?.popViewController(animated: true)
    }
    
    //datamanager interface
    func updateContent(content: String) {
        if draftView.textField.text != note?.content {
            DataManager.updateNote(content: draftView.textField.text, uid: note?.uid ?? "") { (success) in
                //display error in UI
            }
        }
    }
    
    //timer functions for "automatically" saving once a user stops typing
    func resetTimer() {
        timer?.invalidate()
        let nextTimer = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(handleIdleEvent), userInfo: nil, repeats: false)
        timer = nextTimer
    }
    
    @objc func handleIdleEvent() {
        updateContent(content: draftView.textField.text)
    }
    
    func textViewDidChange(_ textView: UITextView) {
        resetTimer()
    }
}
