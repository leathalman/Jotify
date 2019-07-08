//
//  SettingsSwitchCell.swift
//  Jotify
//
//  Created by Harrison Leath on 7/7/19.
//  Copyright © 2019 Harrison Leath. All rights reserved.
//

import UIKit

class SettingsSwitchCell: UITableViewCell {
    
//    let iconView = UIImageView()
    let detailText = UILabel()
    let switchButton = UISwitch()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
//        contentView.addSubview(iconView)
        contentView.addSubview(detailText)
        contentView.addSubview(switchButton)
        
        //temporary placeholder image
//        iconView.image = UIImage(named: "AppIcon")
//        iconView.layer.cornerRadius = 16
//        iconView.layer.masksToBounds = true
//        iconView.contentMode = .scaleAspectFill
//        iconView.translatesAutoresizingMaskIntoConstraints = false
        
        detailText.translatesAutoresizingMaskIntoConstraints = false
        
        switchButton.translatesAutoresizingMaskIntoConstraints = false
        
//        iconView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 10).isActive = true
//        iconView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
//        iconView.widthAnchor.constraint(equalToConstant: 32).isActive = true
//        iconView.heightAnchor.constraint(equalToConstant: 32).isActive = true
        
//        detailText.leftAnchor.constraint(equalTo: iconView.rightAnchor, constant: 10).isActive = true
        detailText.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        detailText.widthAnchor.constraint(equalTo: contentView.widthAnchor, constant: -10).isActive = true
        detailText.heightAnchor.constraint(equalTo: contentView.heightAnchor, constant: -10).isActive = true
        //use detailText instead of textLabel if using iconView in cell
        
        switchButton.leftAnchor.constraint(equalTo: contentView.rightAnchor, constant: -70).isActive = true
        switchButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        switchButton.widthAnchor.constraint(equalToConstant: 30).isActive = true
        switchButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
