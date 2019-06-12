//
//  WriteNoteController.swift
//  Sticky Notes
//
//  Created by Harrison Leath on 5/12/19.
//  Copyright © 2019 Harrison Leath. All rights reserved.
//

import UIKit
import MultilineTextField
import CloudKit

class WriteNoteController: UIViewController, UITextViewDelegate, UITextFieldDelegate {
    
    public var screenWidth: CGFloat {
        return UIScreen.main.bounds.width
    }
    
    public var screenHeight: CGFloat {
        return UIScreen.main.bounds.height
    }
    
    let database = CKContainer.default().privateCloudDatabase
        
    lazy var inputTextView: UITextView = {
        let frame = CGRect(x: 0, y: 100, width: screenWidth, height: screenHeight)
        let textField = UITextView(frame: frame)
        textField.backgroundColor = .clear
        textField.isScrollEnabled = true
//        textField.placeholderColor = .white
        textField.textColor = .white
        textField.isEditable = true
//        textField.isPlaceholderScrollEnabled = true
//        textField.leftViewOrigin = CGPoint(x: 8, y: 8)
        textField.font = UIFont.boldSystemFont(ofSize: 32)
        textField.textContainerInset = UIEdgeInsets(top: 10, left: 15, bottom: 10, right: 15)
        
//        if screenWidth < 650 {
//            textField.placeholder = "Write it down..."
//        } else {
//            textField.placeholder = "What's on your mind..."
//        }
        
        return textField
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }
    
    func setupView() {
        view.clipsToBounds = true
        inputTextView.delegate = self
        
        let gradientView = GradientAnimator(frame: self.view.frame, theme: GradientThemes.BlueLagoon, _startPoint: GradientPoints.bottomLeft, _endPoint: GradientPoints.topRight, _animationDuration: 2.0)
        self.view.insertSubview(gradientView, at: 0)
        gradientView.startAnimate()
        
        view.addSubview(inputTextView)
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
            saveNote(note: inputTextView.text)
            inputTextView.text = ""
        }
    }
    
    func saveNote(note: String) {
        let newNote = CKRecord(recordType: "note")
        newNote.setValue(note, forKey: "content")
        
        database.save(newNote) { (record, error) in
            guard record != nil else { return }
            print("saved record with note \(String(describing: record?.object(forKey: "content")))")
//            print(record?.recordID)
        }
    }
    
//    func deleteRecords() {
//
//        let recordID = record.recordID
//        database.delete(withRecordID: recordID) { (recordID, error) in
//            guard let recordID = recordID else {
//                print(error!.localizedDescription)
//                return
//            }
//            print("Record \(recordID) was successfully deleted")
//        }
//    }
    
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
