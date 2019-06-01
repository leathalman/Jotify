//
//  SettingsSwitchCell.swift
//  Jotify
//
//  Created by Harrison Leath on 5/31/19.
//  Copyright © 2019 Harrison Leath. All rights reserved.
//

import UIKit

class SettingsSwitchCell: UITableViewCell {
    
    let labelText = UILabel()
    let switchButton = UISwitch()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(labelText)
        contentView.addSubview(switchButton)
        
        labelText.translatesAutoresizingMaskIntoConstraints = false
        switchButton.translatesAutoresizingMaskIntoConstraints = false
        
        labelText.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 15).isActive = true
        labelText.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        labelText.widthAnchor.constraint(equalTo: contentView.widthAnchor, constant: -10).isActive = true
        labelText.heightAnchor.constraint(equalTo: contentView.heightAnchor, constant: -10).isActive = true
        
        switchButton.leftAnchor.constraint(equalTo: contentView.rightAnchor, constant: -70).isActive = true
        switchButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        switchButton.widthAnchor.constraint(equalToConstant: 30).isActive = true
        switchButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

