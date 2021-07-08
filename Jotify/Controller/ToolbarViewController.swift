//
//  ToolbarViewController.swift
//  Jotify
//
//  Created by Harrison Leath on 6/21/21.
//

import UIKit
import SPIndicator

class ToolbarViewController: UIViewController {
    
    lazy var field: UITextView = {
        let f = UITextView()
        f.backgroundColor = .clear
        f.textColor = .white
        f.tintColor = .white
        f.isEditable = true
        f.font = UIFont.boldSystemFont(ofSize: 32)
        f.textContainerInset = UIEdgeInsets(top: 10, left: 15, bottom: 10, right: 15)
        f.translatesAutoresizingMaskIntoConstraints = false
        return f
    }()
    
    var keyboardToolbar = UIToolbar()
    
    var isBulletedList: Bool = false  
    var isMultiline: Bool = false
    
    let placeholder: String = "Start typing or swipe right for saved notes..."
    
    override func viewDidLoad() {
        setupToolbar()
        SPIndicatorConfiguration.duration = 1
        
        //setup notifications for keyboard
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    //toolbar UI setup
    func setupToolbar() {
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        let multiline = UIBarButtonItem(image: UIImage(systemName: "line.horizontal.2.decrease.circle"), style: .plain, target: self, action: #selector(toggleMultilineInput))
        let colorpicker = UIBarButtonItem(image: UIImage(systemName: "eyedropper"), style: .plain, target: self, action: nil)
        let list = UIBarButtonItem(image: UIImage(systemName: "list.bullet"), style: .plain, target: self, action: #selector(addBullet))
        let timer = UIBarButtonItem(image: UIImage(systemName: "timer"), style: .plain, target: self, action: nil)
        let help = UIBarButtonItem(image: UIImage(systemName: "arrow.down.app"), style: .plain, target: self, action: #selector(keyboardSaveNote))
        keyboardToolbar.items = [multiline, spacer, list, spacer, timer, spacer, colorpicker, spacer, help]
        keyboardToolbar.sizeToFit()
        field.inputAccessoryView = keyboardToolbar
    }
    
    //toolbar action cofiguration
    @objc func toggleMultilineInput() {
        if isMultiline {
            isMultiline = false
            SPIndicator.present(title: "Multiline Input Disabled", preset: .error)
        } else {
            isMultiline = true
            SPIndicator.present(title: "Multiline Input Enabled", preset: .done)
        }
    }
    
    @objc func addBullet() {
        if isBulletedList {
            isBulletedList = false
            SPIndicator.present(title: "Bulleted List Disabled", preset: .error)
        } else {
            isBulletedList = true
            isMultiline = true
            SPIndicator.present(title: "Bulleted List Enabled", preset: .done)
            field.addBullet()
        }
    }
    
    @objc func keyboardSaveNote () { return }
    
    //handle keyboard interaction with view
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            let insets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height, right: 0)
            field.contentInset = insets
            field.scrollIndicatorInsets = insets
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        let insets = UIEdgeInsets.zero
        field.contentInset = insets
        field.scrollIndicatorInsets = insets
    }
}
