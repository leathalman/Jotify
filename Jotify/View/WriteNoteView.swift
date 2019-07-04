//
//  WriteNoteView.swift
//  Jotify
//
//  Created by Harrison Leath on 7/2/19.
//  Copyright © 2019 Harrison Leath. All rights reserved.
//

import UIKit
import MultilineTextField

class WriteNoteView: UIView {
    
    let iconSize: CGFloat = 50
    
    public var screenWidth: CGFloat {
        return UIScreen.main.bounds.width
    }
    
    public var screenHeight: CGFloat {
        return UIScreen.main.bounds.height
    }
    
    lazy var inputTextView: MultilineTextField = {
        let frame = CGRect(x: 0, y: 75, width: screenWidth, height: screenHeight)
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
    
    lazy var colorView: UIView = {
        let view = UIView()
        let frame = CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight)
        view.frame = frame
        
        return view
    }()
    
    
    lazy var collectionButton: UIButton = {
        let button = UIButton()
        let frame = CGRect(x: screenWidth * 0.1, y: screenHeight * 0.1, width: iconSize, height: iconSize)
        button.frame = frame
        let image = UIImage(named: "collection3")
        button.setImage(image, for: .normal)
        
        return button
    }()
    
    lazy var settingButton: UIButton = {
        let button = UIButton()
        let frame = CGRect(x: screenWidth * 0.7, y: screenHeight * 0.8, width: iconSize, height: iconSize)
        button.frame = frame
        let image = UIImage(named: "gear1")
        button.setImage(image, for: .normal)
        
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        clipsToBounds = true
        getRandomColor()
        
        addSubview(inputTextView)
        insertSubview(colorView, belowSubview: inputTextView)
        //        addSubview(collectionButton)
        //        addSubview(settingButton)
    }
    
    func getRandomColor() {
        let randomColor = Colors.softColors.randomElement()
        //set global value to equal generated value
        StoredColors.noteColor = randomColor!
        colorView.backgroundColor = randomColor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


