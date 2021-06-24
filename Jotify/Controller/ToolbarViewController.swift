//
//  ToolbarViewController.swift
//  Jotify
//
//  Created by Harrison Leath on 6/21/21.
//

import UIKit
import MultilineTextField
import SPIndicator

class ToolbarViewController: UIViewController {
    
    //textfield for editing notes
    lazy var field: MultilineTextField = {
        let frame = CGRect(x: 0, y: 100, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - 100)
        let textField = MultilineTextField(frame: frame)
        textField.backgroundColor = .clear
        textField.placeholderColor = .white
        textField.textColor = .white
        textField.tintColor = .white
        textField.isEditable = true
        textField.leftViewOrigin = CGPoint(x: 8, y: 8)
        textField.font = UIFont.boldSystemFont(ofSize: 32)
        textField.textContainerInset = UIEdgeInsets(top: 10, left: 15, bottom: 10, right: 15)
        textField.placeholder = "Start typing or swipe right for saved notes..."
        return textField
    }()
    
    var keyboardToolbar = UIToolbar()
    
    var isBulletedList: Bool = false  
    var isMultiline: Bool = false
    
    
    override func viewDidLoad() {
        setupToolbar()
        SPIndicatorConfiguration.duration = 1
    }
    
    //toolbar for
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
}
