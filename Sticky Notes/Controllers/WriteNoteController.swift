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
    
    lazy var inputTextView: MultilineTextField = {
        let frame = CGRect(x: 0, y: 100, width: screenWidth, height: screenHeight)
        let textField = MultilineTextField(frame: frame)
        textField.backgroundColor = .clear
        
        if screenWidth < 650 {
            textField.placeholder = "Write it down..."
        } else {
            textField.placeholder = "What's on your mind..."
        }
        
        textField.placeholderColor = Colors.gray
        textField.textColor = .white
        textField.isPlaceholderScrollEnabled = true
        textField.leftViewOrigin = CGPoint(x: 8, y: 8)
        textField.font = UIFont.boldSystemFont(ofSize: 32)
        return textField
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        checkIfUserIsLoggedIn()
        setupView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
    }
    
    @objc func handleSwipeDown(_ sender: UITapGestureRecognizer) {
        present(SettingsController(), animated: false, completion: nil)
    }
    
    func setupView() {
        
        view.clipsToBounds = true
        view.layer.cornerRadius = 10
        inputTextView.delegate = self

        self.view.addSubview(inputTextView)
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
            let properties = ["text": inputTextView.text!]
            saveNote(properties: properties)
            inputTextView.text = ""
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
//        textView.resignFirstResponder()
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
