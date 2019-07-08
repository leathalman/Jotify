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
    
    public var screenWidth: CGFloat {
        return UIScreen.main.bounds.width
    }
    
    public var screenHeight: CGFloat {
        return UIScreen.main.bounds.height
    }
    
    lazy var inputTextView: MultilineTextField = {
        let frame = CGRect(x: 0, y: 100, width: screenWidth, height: screenHeight - 100)
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
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        clipsToBounds = true
        getRandomColor()
        
        addSubview(inputTextView)
        insertSubview(colorView, belowSubview: inputTextView)
    }
    
    func getRandomColor() {
        let colorTheme = UserDefaults.standard.string(forKey: "noteColorTheme")
        var randomColor = UIColor()
        
        if colorTheme == "default" {
            randomColor = Colors.defaultColors.randomElement() ?? UIColor.white
            
        } else if colorTheme == "sunset" {
            randomColor = Colors.sunsetColors.randomElement() ?? UIColor.white
            
        } else if colorTheme == "kypool" {
            randomColor = Colors.kypoolColors.randomElement() ?? UIColor.white

        } else if colorTheme == "celestial" {
            randomColor = Colors.celestialColors.randomElement() ?? UIColor.white
        }
        
        //set global value to equal generated value
        StoredColors.noteColor = randomColor
        colorView.backgroundColor = randomColor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


