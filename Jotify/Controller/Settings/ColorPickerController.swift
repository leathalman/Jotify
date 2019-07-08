//
//  ColorPickerController.swift
//  Jotify
//
//  Created by Harrison Leath on 7/7/19.
//  Copyright © 2019 Harrison Leath. All rights reserved.
//

import UIKit
import ChromaColorPicker

class ColorPickerController: UIViewController {
    
    lazy var colorPicker: ChromaColorPicker = {
        let colorPicker = ChromaColorPicker(frame: CGRect(x: 0, y: 0, width: 300, height: 300))
        colorPicker.delegate = self
        colorPicker.padding = 5
        colorPicker.stroke = 3
        colorPicker.hexLabel.textColor = UIColor.black
        colorPicker.center = self.view.center
        return colorPicker
    }()
    
    lazy var contentView: UIView = {
        let contentView = UIView()
        contentView.frame = CGRect(x: 0, y: 0, width: 350, height: 350)
        contentView.center = self.view.center
        contentView.backgroundColor = UIColor.grayBackground
        contentView.layer.cornerRadius = 15
        return contentView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.grayBlur
        
        view.addSubview(contentView)
        view.addSubview(colorPicker)
    }
    
}

extension ColorPickerController: ChromaColorPickerDelegate{
    
    func colorPickerDidChooseColor(_ colorPicker: ChromaColorPicker, color: UIColor) {
        view.backgroundColor = color
        
        //Perform zesty animation
        UIView.animate(withDuration: 0.2,
                       animations: {
                        self.view.transform = CGAffineTransform(scaleX: 1.05, y: 1.05)
        }, completion: { (done) in
            UIView.animate(withDuration: 0.2, animations: {
                self.view.transform = CGAffineTransform.identity
                
                self.colorPicker.hexLabel.textColor = UIColor.white

                self.contentView.backgroundColor = UIColor.grayBlur
                self.contentView.frame = CGRect(x: 0, y: 0, width: 300, height: 300)
                self.contentView.center = self.view.center
                
            })
        })
    }
}
