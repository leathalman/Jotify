//
//  WriteNoteController.swift
//  Sticky Notes
//
//  Created by Harrison Leath on 5/12/19.
//  Copyright © 2019 Harrison Leath. All rights reserved.
//

import UIKit
import MultilineTextField
//import GradientAnimator

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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
    }
    
    func setupView() {
//        title = "Write"
//
//        self.navigationController?.navigationBar.prefersLargeTitles = true
//        self.navigationController?.navigationBar.backgroundColor = .white
        

        view.clipsToBounds = true
        inputTextView.delegate = self
        
        let gradientView = GradientAnimator(frame: self.view.frame, theme: GradientThemes.Sunrise, _startPoint: GradientPoints.bottomLeft, _endPoint: GradientPoints.topRight, _animationDuration: 3.0)
        self.view.insertSubview(gradientView, at: 0)
        gradientView.startAnimate()

        view.addSubview(inputTextView)
//        addGradient()
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
