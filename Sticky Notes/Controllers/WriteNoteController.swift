//
//  WriteNoteController.swift
//  Sticky Notes
//
//  Created by Harrison Leath on 5/12/19.
//  Copyright © 2019 Harrison Leath. All rights reserved.
//

import UIKit
import Firebase

extension UITextField {
    func setLeftPaddingPoints(_ amount:CGFloat){
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    func setRightPaddingPoints(_ amount:CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.rightView = paddingView
        self.rightViewMode = .always
    }
}

class WriteNoteController: UIViewController, UITextViewDelegate, UITextFieldDelegate {
    
    public var screenWidth: CGFloat {
        return UIScreen.main.bounds.width
    }
    
    public var screenHeight: CGFloat {
        return UIScreen.main.bounds.height
    }
    
//    lazy var inputTextView: UITextView = {
//        let textView =  UITextView(frame: CGRect(x: 0, y: 100, width: screenWidth, height: screenHeight))
//
//        if screenWidth < 650 {
//            textView.text = "Write it down..."
//        } else {
//            textView.text = "What's on your mind..."
//        }
//
//        textView.textContainerInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
//        textView.isEditable = false
//        textView.clearsOnInsertion = true
//        textView.textColor = UIColor.lightGray
//        textView.font = UIFont.boldSystemFont(ofSize: 32)
//        textView.autocorrectionType = UITextAutocorrectionType.no
//        textView.backgroundColor = UIColor.clear
//        return textView
//    }()
    
    lazy var inputTextField: UITextField = {
        let textField =  UITextField(frame: CGRect(x: 0, y: screenHeight - screenHeight*1.35, width: screenWidth, height: screenHeight))
    
        if screenWidth < 650 {
            textField.placeholder = "Write it down..."
        } else {
            textField.placeholder = "What's on your mind..."
        }
    
        textField.clearsOnInsertion = true
        textField.textColor = UIColor.white
        textField.borderStyle = .none
        textField.font = UIFont.boldSystemFont(ofSize: 32)
        textField.autocorrectionType = UITextAutocorrectionType.no
        textField.clearButtonMode = UITextField.ViewMode.whileEditing
        textField.contentVerticalAlignment = UIControl.ContentVerticalAlignment.center
        textField.backgroundColor = UIColor.clear
        textField.setLeftPaddingPoints(20)
        textField.setRightPaddingPoints(20)
        return textField
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        checkIfUserIsLoggedIn()
        setupView()
//        setupSwiftDown()
    }
    
    override func viewDidAppear(_ animated: Bool) {
//        inputTextView.isEditable = true
    }
    
    func setupSwiftDown() {
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(self.handleSwipeDown(_:)))
        swipeDown.direction = .down
        view.addGestureRecognizer(swipeDown)
        view.isUserInteractionEnabled = true
    }
    
    @objc func handleSwipeDown(_ sender: UITapGestureRecognizer) {
        present(SettingsController(), animated: false, completion: nil)
    }
    
    func setupView() {
//        self.inputTextView.delegate = self
        
        self.view.clipsToBounds = true
        self.view.layer.cornerRadius = 10
        self.inputTextField.delegate = self

//        self.view.addSubview(inputTextView)
        self.view.addSubview(inputTextField)
        addGradient()
    }
    
    func addGradient() {
        view.backgroundColor = UIColor.clear
        let backgroundLayer = Colors().blueGradient
        backgroundLayer?.frame = view.frame
        view.layer.insertSublayer(backgroundLayer!, at: 0)
    }
    
    @objc func handleSend() {
        
        if inputTextField.text == "" {
            
        } else {
//            let properties = ["text": inputTextView.text!]
            let properties = ["text": inputTextField.text!]
            saveNote(properties: properties)
        }
    }
    
    private func saveNote(properties: [String: Any]) {
        let ref = Database.database().reference().child("notes")
        let childRef = ref.childByAutoId()
        let userId = Auth.auth().currentUser!.uid
        let timestamp = (NSDate().timeIntervalSince1970)
        
        var values: [String: Any] = ["userId": userId, "timestamp": timestamp] as [String : Any]
        
        properties.forEach({values[$0.0] = $0.1})
        
        childRef.updateChildValues(values) { (error, ref ) in
            if error != nil {
                print(error ?? "error updating child values")
                return
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
        inputTextField.text = ""
        return true
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        //spoofing placeholder text for UITextView
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.white
        }
    }
    
    @objc private func logoutTapped() {
        handleLogout()
    }
    
    @objc private func sendTapped() {
        handleSend()
    }
    
    @objc private func removeTapped() {
        let ref = Database.database().reference().child("notes")
        ref.removeValue()
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
