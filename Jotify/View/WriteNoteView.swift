//
//  WriteNoteView.swift
//  Jotify
//
//  Created by Harrison Leath on 7/2/19.
//  Copyright © 2019 Harrison Leath. All rights reserved.
//

import MultilineTextField
import UIKit

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
        textField.leftViewOrigin = CGPoint(x: 8, y: 8)
        textField.font = UIFont.boldSystemFont(ofSize: 32)
        textField.textContainerInset = UIEdgeInsets(top: 10, left: 15, bottom: 10, right: 15)
        
        return textField
    }()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        clipsToBounds = true
        
        handleRandomColorsEnabled()
        
        addSubview(inputTextView)
    }
    
    func handleRandomColorsEnabled() {
        if UserDefaults.standard.bool(forKey: "useRandomColor") == true {
            getRandomColor(previousColor: backgroundColor ?? UIColor.white)
        } else if UserDefaults.standard.bool(forKey: "useRandomColor") == false {
            let color = UserDefaults.standard.color(forKey: "staticNoteColor")
            backgroundColor = color
            StoredColors.noteColor = color ?? UIColor.white
        }
    }
    
    func getRandomColor(previousColor: UIColor) {
        let colorTheme = UserDefaults.standard.string(forKey: "noteColorTheme")
        var randomColor: UIColor = .white
        
        randomColor = pickRandomColorFromTheme(colorTheme: colorTheme ?? "default")
        
        // continually pick a color until it is different from the last color
        // used to never repeat colors
        while randomColor == previousColor {
            randomColor = pickRandomColorFromTheme(colorTheme: colorTheme ?? "default")
        }
        
        // set global value to equal generated value
        StoredColors.noteColor = randomColor
        
        if UserDefaults.standard.bool(forKey: "darkModeEnabled") == false {
            backgroundColor = randomColor
        } else if UserDefaults.standard.bool(forKey: "darkModeEnabled") == true {
            if UserDefaults.standard.bool(forKey: "vibrantDarkModeEnabled") == true {
                backgroundColor = Colors.grayBackground
            } else if UserDefaults.standard.bool(forKey: "pureDarkModeEnabled") == true {
                backgroundColor = .black
            }
        }
    }
    
    func pickRandomColorFromTheme(colorTheme: String) -> UIColor {
        var randomColor = UIColor.white
        
        if colorTheme == "default" {
            randomColor = Colors.defaultColors.randomElement() ?? UIColor.white
            
        } else if colorTheme == "sunset" {
            randomColor = Colors.sunsetColors.randomElement() ?? UIColor.white
            
        } else if colorTheme == "kypool" {
            randomColor = Colors.kypoolColors.randomElement() ?? UIColor.white
            
        } else if colorTheme == "celestial" {
            randomColor = Colors.celestialColors.randomElement() ?? UIColor.white
            
        } else if colorTheme == "appleVibrant" {
            randomColor = Colors.appleVibrantColors.randomElement() ?? UIColor.white
        } else if colorTheme == "scarletAzure" {
            randomColor = Colors.scarletAzureColors.randomElement() ?? UIColor.white
        }
        
        return randomColor
    }
 
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
