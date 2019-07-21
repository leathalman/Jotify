//
//  NoteDetailController.swift
//  Jotify
//
//  Created by Harrison Leath on 6/24/19.
//  Copyright © 2019 Harrison Leath. All rights reserved.
//

import UIKit

class NoteDetailController: UIViewController, UITextViewDelegate {
    
    var navigationTitle: String = ""
    var backgroundColor: UIColor = .white
    var detailText: String = ""
    var index: Int = 0
    
    let writeNoteView = WriteNoteView()
    
    var notes: [Note] = []
    var filteredNotes: [Note] = []
    var isFiltering: Bool = false
    
    var navigationBarHeight = CGFloat()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupPersistentNavigationBar()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationBarHeight = self.navigationController!.navigationBar.frame.height
        
        setupNotifications()
        setupView()
//        setupToolBar()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        let newDate = Date.timeIntervalSinceReferenceDate
        updateContent(index: index, newContent: writeNoteView.inputTextView.text, newDate: newDate)
        
        resetNavigationBarForTransition()
    }
    
    func setupToolBar() {
        let doneButton = UIBarButtonItem.init(barButtonSystemItem: UIBarButtonItem.SystemItem.done, target: writeNoteView.inputTextView, action: #selector(UIResponder.resignFirstResponder))
        
        let flexSpace: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: self, action: nil)
        
        let button: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.edit, target: self, action: #selector(addBulletToString))
        
        let toolbar = UIToolbar()
        toolbar.barStyle = UIBarStyle.default
        toolbar.isTranslucent = true
        toolbar.tintColor = backgroundColor
        toolbar.sizeToFit()
        toolbar.setItems([button, flexSpace, doneButton], animated: false)
        toolbar.isUserInteractionEnabled = true
        writeNoteView.inputTextView.inputAccessoryView = toolbar
    }
    
    @objc func addBulletToString() {
        let stringArray = writeNoteView.inputTextView.text.components(separatedBy: "\n")
                
        for items in stringArray {
            if !items.contains("•") {
                writeNoteView.inputTextView.attributedText = add(stringList: stringArray, font: UIFont.boldSystemFont(ofSize: 18), bullet: "•")
            }
        }
    }
    
    func add(stringList: [String],
             font: UIFont,
             bullet: String = "\u{2022}",
             indentation: CGFloat = 20,
             textColor: UIColor = .white,
             bulletColor: UIColor = .white) -> NSAttributedString {

        let textAttributes: [NSAttributedString.Key: Any] = [NSAttributedString.Key.font: font, NSAttributedString.Key.foregroundColor: textColor]
        let bulletAttributes: [NSAttributedString.Key: Any] = [NSAttributedString.Key.font: font, NSAttributedString.Key.foregroundColor: bulletColor]

        let bulletList = NSMutableAttributedString()
        for string in stringList {
            let formattedString = "\(bullet)\t\(string)\n"
            let attributedString = NSMutableAttributedString(string: formattedString)

            attributedString.addAttributes(range: NSMakeRange(0, attributedString.length))

            attributedString.addAttributes(
                textAttributes,
                range: NSMakeRange(0, attributedString.length))

            let string:NSString = NSString(string: formattedString)
            let rangeForBullet:NSRange = string.range(of: bullet)
            attributedString.addAttributes(bulletAttributes, range: rangeForBullet)
            bulletList.append(attributedString)
        }

        return bulletList
    }
    
    func setupPersistentNavigationBar() {
        guard self.navigationController?.topViewController === self else { return }
        self.transitionCoordinator?.animate(alongsideTransition: { [weak self](context) in
            self?.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
            self?.navigationController?.navigationBar.shadowImage = UIImage()
            self?.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
            self?.navigationController?.navigationBar.barStyle = .black
            
            if UserDefaults.standard.bool(forKey: "darkModeEnabled") == false {
                self?.navigationController?.navigationBar.backgroundColor = self?.backgroundColor
                self?.navigationController?.navigationBar.barTintColor = self?.backgroundColor
                
            } else {
                self?.navigationController?.navigationBar.backgroundColor = InterfaceColors.viewBackgroundColor
                self?.navigationController?.navigationBar.barTintColor = InterfaceColors.viewBackgroundColor
            }
            
            }, completion: nil)
    }
    
    func resetNavigationBarForTransition() {
        self.transitionCoordinator?.animate(alongsideTransition: { [weak self](context) in
            self?.navigationController?.navigationBar.setBackgroundImage(nil, for: UIBarMetrics.default)
            self?.navigationController?.navigationBar.backgroundColor = .white
            self?.navigationController?.navigationBar.barTintColor = .white
            self?.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
            }, completion: nil)
    }
    
    func setupView() {
        view = writeNoteView
        let textView = writeNoteView.inputTextView
        
        if UserDefaults.standard.bool(forKey: "darkModeEnabled") == false {
            writeNoteView.colorView.backgroundColor = backgroundColor
            textView.backgroundColor = backgroundColor
            
        } else {
            writeNoteView.colorView.backgroundColor = InterfaceColors.viewBackgroundColor
            textView.backgroundColor = InterfaceColors.viewBackgroundColor
        }
        
        textView.tintColor = .white
        textView.frame = CGRect(x: 0, y: 15, width: writeNoteView.screenWidth, height: writeNoteView.screenHeight)
        textView.text = detailText
        textView.font = UIFont.boldSystemFont(ofSize: 18)
        textView.placeholder = ""
        
        textView.alwaysBounceVertical = true
        textView.isUserInteractionEnabled = true
        textView.isScrollEnabled = true
        textView.isPlaceholderScrollEnabled = true
        
        navigationItem.title = navigationTitle
        navigationItem.setHidesBackButton(true, animated:true)
        
        var image = UIImage(named: "cancel")
        image = image?.withRenderingMode(.alwaysOriginal)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: image, style:.plain, target: self, action: #selector(handleCancel))
        
        self.hideKeyboardWhenTappedAround()
    }
    
    @objc func handleCancel() {
        navigationController?.popViewController(animated: true)
    }
    
    func updateContent(index: Int, newContent: String, newDate: Double){
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        
        if isFiltering == false {
            notes[index].content = newContent
            notes[index].date = newDate
            
        } else if isFiltering == true {
            filteredNotes[index].content = newContent
            filteredNotes[index].date = newDate
            
        }
        
        appDelegate.saveContext()
    }
    
    func setupNotifications() {
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    @objc func adjustForKeyboard(notification: Notification) {
        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        
        let keyboardScreenEndFrame = keyboardValue.cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)
        
        if notification.name == UIResponder.keyboardWillHideNotification {
            writeNoteView.inputTextView.contentInset = .zero
            
        } else {
            writeNoteView.inputTextView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height + navigationBarHeight + 20, right: 0)
        }
        
        writeNoteView.inputTextView.scrollIndicatorInsets = writeNoteView.inputTextView.contentInset
        
        let selectedRange = writeNoteView.inputTextView.selectedRange
        writeNoteView.inputTextView.scrollRangeToVisible(selectedRange)
    }
    
    
}
