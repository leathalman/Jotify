//
//  AboutSettingsView.swift
//  Jotify
//
//  Created by Harrison Leath on 7/13/19.
//  Copyright © 2019 Harrison Leath. All rights reserved.
//

import UIKit

class AboutSettingsView: UIView {
    let iconSize: CGFloat = 200
    
    let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as! String
    
    lazy var icon: UIImageView = {
        var image = UIImage(named: "defaultLarge")
        
        let iconName = UIApplication.shared.alternateIconName
        if UIApplication.shared.supportsAlternateIcons {
            if iconName == "Golden2" {
                image = UIImage(named: "goldLarge")
                
            } else {
                image = UIImage(named: "defaultLarge")
            }
        }
        
        let iconView = UIImageView(image: image)
        iconView.translatesAutoresizingMaskIntoConstraints = false
        iconView.layer.cornerRadius = 28
        iconView.clipsToBounds = true
        
        return iconView
    }()
    
    lazy var versionLabel: UILabel = {
        let label = UILabel()
        label.text = "Verison: \(appVersion)"
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    lazy var iconText: UIImageView = {
        var image = UIImage(named: "defaultText")
        
        let iconName = UIApplication.shared.alternateIconName
        if UIApplication.shared.supportsAlternateIcons {
            if iconName == "Golden2", UserDefaults.standard.bool(forKey: "darkModeEnabled") == true {
                image = UIImage(named: "goldTextAlt")
                
            } else if iconName == "Golden2", UserDefaults.standard.bool(forKey: "darkModeEnabled") == false {
                image = UIImage(named: "goldText")
                
            } else {
                image = UIImage(named: "defaultText")
            }
        }
        let iconView = UIImageView(image: image)
        iconView.translatesAutoresizingMaskIntoConstraints = false
        
        return iconView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        clipsToBounds = true
        
        backgroundColor = UIColor.white
        setupView()
    }
    
    func setupView() {
        addSubview(icon)
        addSubview(iconText)
        addSubview(versionLabel)
        
        icon.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        icon.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -90).isActive = true
        icon.widthAnchor.constraint(equalToConstant: iconSize).isActive = true
        icon.heightAnchor.constraint(equalToConstant: iconSize).isActive = true
        
        iconText.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        iconText.topAnchor.constraint(equalTo: icon.bottomAnchor, constant: 20).isActive = true
        iconText.widthAnchor.constraint(equalToConstant: 150).isActive = true
        iconText.heightAnchor.constraint(equalToConstant: 52).isActive = true
        
        versionLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        versionLabel.topAnchor.constraint(equalTo: iconText.bottomAnchor, constant: 10).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
