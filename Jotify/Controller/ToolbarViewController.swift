//
//  ToolbarViewController.swift
//  Jotify
//
//  Created by Harrison Leath on 6/21/21.
//

import UIKit
import MultilineTextField

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
    
    override func viewDidLoad() {
        setupToolbar()
    }
    
    //toolbar for
    func setupToolbar() {
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        let multiline = UIBarButtonItem(image: UIImage(systemName: "text.badge.plus"), style: .plain, target: self, action: #selector(addBullet))
        let colorpicker = UIBarButtonItem(image: UIImage(systemName: "eyedropper"), style: .plain, target: self, action: nil)
        let list = UIBarButtonItem(image: UIImage(systemName: "list.bullet"), style: .plain, target: self, action: nil)
        let timer = UIBarButtonItem(image: UIImage(systemName: "timer"), style: .plain, target: self, action: nil)
        let help = UIBarButtonItem(image: UIImage(systemName: "questionmark.circle"), style: .plain, target: self, action: nil)
        keyboardToolbar.items = [multiline, spacer, list, spacer, timer, spacer, colorpicker, spacer, help]
        keyboardToolbar.sizeToFit()
        field.inputAccessoryView = keyboardToolbar
    }
    
    @objc func addBullet() {
        let style = NSMutableParagraphStyle()
        style.alignment = .left
        style.headIndent = 20
        
        let title = NSMutableAttributedString(string: "\u{2022} I need to add bulleted text to textView in iOS app. I am looking at this link and this one and following their ideas. This is my code:", attributes: [NSAttributedString.Key.paragraphStyle: style, NSAttributedString.Key.foregroundColor:UIColor.blue])
        
        let titleStr = NSMutableAttributedString(string: "\n\n\u{2022} I need to add bulleted text to textView in iOS app. I am looking at this link and this one and following their ideas. This is my code:", attributes: [NSAttributedString.Key.paragraphStyle: style, NSAttributedString.Key.foregroundColor:UIColor.blue])
        
        title.append(titleStr)
        field.attributedText = title
    }
}
