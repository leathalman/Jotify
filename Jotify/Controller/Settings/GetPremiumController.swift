//
//  GetPremiumController.swift
//  Jotify
//
//  Created by Harrison Leath on 8/14/19.
//  Copyright © 2019 Harrison Leath. All rights reserved.
//

import UIKit

class GetPremiumController: UIViewController {
    
    public var screenWidth: CGFloat {
        return UIScreen.main.bounds.width
    }
    
    public var screenHeight: CGFloat {
        return UIScreen.main.bounds.height
    }
    
    lazy var colorView: UIView = {
        let view = UIView()
        let frame = CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight)
        view.frame = frame
        
        return view
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Get Premium."
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 50)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    lazy var detailLabel: UILabel = {
        let label = UILabel()
        label.text = "Unlock dark mode, note themes, color customization, and more."
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.numberOfLines = 0
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    func setupView() {
        colorView.backgroundColor = randomColorFromTheme()
        
        view.addSubview(colorView)
        view.addSubview(titleLabel)
        view.addSubview(detailLabel)
        
        titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 40).isActive = true
//        titleLabel.widthAnchor.constraint(equalToConstant: 150).isActive = true
//        titleLabel.heightAnchor.constraint(equalToConstant: 52).isActive = true
        
        detailLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        detailLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10).isActive = true
        detailLabel.widthAnchor.constraint(equalToConstant: screenWidth / 1.15).isActive = true
//        detailLabel.heightAnchor.constraint(equalToConstant: 52).isActive = true
        
    }
    
    func randomColorFromTheme() -> UIColor {
        let colorTheme = UserDefaults.standard.string(forKey: "noteColorTheme")
        var randomColor: UIColor = .white
        
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
        }
        
        return randomColor
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .darkContent
    }
    
}
