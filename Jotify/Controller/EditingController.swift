//
//  EditingController.swift
//  Jotify
//
//  Created by Harrison Leath on 1/18/21.
//

import UIKit

class EditingController: ToolbarViewController, UITextViewDelegate {
    
    var note: FBNote?
    var noteColor: UIColor?
    var noteCollection: NoteCollection?
    
    var timer: Timer?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        //change status bar style to white
        setStatusBarStyle(style: noteColor?.isDarkColor ?? false ? .lightContent : .darkContent)
    }
    
    //life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        noteColor = note?.color.getNewColor()
        setupView()
        setupNavBar()
        setupNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        updateContent(content: field.text)
    }
    
    //view configuration
    func setupView() {
        //color customization to support white/black dynamic type
        field.backgroundColor = noteColor
        field.textColor = noteColor?.isDarkColor ?? false ? .white : .black
        field.tintColor = noteColor?.isDarkColor ?? false ? .white : .black
        
        field.text = note?.content
        field.placeholder = ""
        field.delegate = self
        field.font = UIFont.boldSystemFont(ofSize: 18)
        field.frame = CGRect(x: 0, y: 15, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        
        view.addSubview(field)
        
        //remove multiline input icon
        keyboardToolbar.items?.remove(at: 0)
        //remove save note icon
        keyboardToolbar.items?.removeLast()
        
        setStatusBarStyle(style: noteColor?.isDarkColor ?? false ? .lightContent : .darkContent)
    }
    
    func setupNavBar() {
        //setup navigationbar elements
        navigationItem.title = note?.timestamp.getDate()
        navigationController?.configure(bgColor: noteColor ?? .systemBlue)
        navigationController?.navigationBar.standardAppearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor : noteColor?.isDarkColor ?? false ? UIColor.white : .black]
        navigationItem.setHidesBackButton(true, animated: true)
        
        //define image and action for each navigation button
        let timer = UIBarButtonItem(image: UIImage(systemName: "timer"), style: .plain, target: self, action: #selector(handleCancel))
        let ellipsis = UIBarButtonItem(image: UIImage(systemName: "ellipsis.circle"), style: .plain, target: self, action: #selector(handleCancel))
        let cancel = UIBarButtonItem(image: UIImage(systemName: "xmark.circle"), style: .plain, target: self, action: #selector(handleCancel))

        //handle tint color of each button based on view background color
        timer.tintColor = noteColor?.isDarkColor ?? false ? .white : .black
        ellipsis.tintColor = noteColor?.isDarkColor ?? false ? .white : .black
        cancel.tintColor = noteColor?.isDarkColor ?? false ? .white : .black
        
        navigationItem.leftBarButtonItems = [timer, ellipsis]
        navigationItem.rightBarButtonItem = cancel
    }
   
    //action handlers
    @objc func handleCancel() {
        self.playHapticFeedback()
        navigationController?.popViewController(animated: true)
    }
    
    //datamanager interface
    func updateContent(content: String) {
        if field.text != note?.content {
            DataManager.updateNoteContent(content: field.text, uid: note?.id ?? "") { (success) in
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
        updateContent(content: field.text)
    }
    
    func textViewDidChange(_ textView: UITextView) {
        resetTimer()
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if (text as NSString).rangeOfCharacter(from: CharacterSet.newlines).location == NSNotFound {
            return true
        }
        if isBulletedList {
            //make new line and add bullet where cursor is
            field.addBulletOnReturn()
        } else {
            //make new line where cursor is
            field.addNewLineOnReturn()
        }
        
        return false
    }
}
