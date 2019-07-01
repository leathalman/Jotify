//
//  WriteNoteController.swift
//  Sticky Notes
//
//  Created by Harrison Leath on 5/12/19.
//  Copyright © 2019 Harrison Leath. All rights reserved.
//

import UIKit
import MultilineTextField
import CoreData

class WriteNoteController: UIViewController, UITextViewDelegate, UITextFieldDelegate {
    
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
        textField.placeholderColor = .white
        textField.textColor = .white
        textField.isEditable = true
        textField.isPlaceholderScrollEnabled = true
        textField.leftViewOrigin = CGPoint(x: 8, y: 8)
        textField.font = UIFont.boldSystemFont(ofSize: 32)
        textField.textContainerInset = UIEdgeInsets(top: 10, left: 15, bottom: 10, right: 15)
        textField.placeholder = "Write it down..."
        
        return textField
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }
    
    func addColoredBackground() {
        let colorView = UIView()
        let frame = CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight)
        colorView.frame = frame
        colorView.tag = 100
        
        let randomColor = Colors.softColors.randomElement()
        
        //set global value to equal generated value
        StoredColors.noteColor = randomColor!
        
        colorView.backgroundColor = randomColor
        view.insertSubview(colorView, belowSubview: inputTextView)
    }
    
    func setupView() {
        view.clipsToBounds = true
        inputTextView.delegate = self
        
        view.addSubview(inputTextView)
        
        addColoredBackground()
        setupSwipes()
    }
    
    @objc func handleSwipes(_ gesture: UISwipeGestureRecognizer) {
        if gesture.direction == .left {
            tabBarController?.selectedIndex = 2
            
        } else if gesture.direction == .right {
            tabBarController?.selectedIndex = 0
            
        }
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
    
    @objc func handleSend() {
        
        if inputTextView.text == "" {
            
        } else {
            
            StoredColors.noteColorString = Colors.stringFromColor(color: StoredColors.noteColor)
            
            let date = Date.timeIntervalSinceReferenceDate
            saveNote(content: inputTextView.text, color: StoredColors.noteColorString, date: date)
            inputTextView.text = ""
            
            let colorView = self.view.viewWithTag(100)
            colorView?.removeFromSuperview()
            
            addColoredBackground()
        }
    }
    
    func saveNote(content: String, color: String, date: Double) {
        
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Note", in: managedContext)!
        let note = NSManagedObject(entity: entity, insertInto: managedContext)
        
        note.setValue(content, forKeyPath: "content")
        note.setValue(color, forKey: "color")
        note.setValue(date, forKey: "date")
        
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
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
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}
