//
//  SettingsSwitchCell.swift
//  Jotify
//
//  Created by Harrison Leath on 2/1/21.
//

import UIKit

class SettingsSwitchCell: UITableViewCell {
    let switchButton = UISwitch()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        //set style to subtitle to allow for customization when selecting dates in ReminderController
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(switchButton)
        
        switchButton.translatesAutoresizingMaskIntoConstraints = false
        
        switchButton.leftAnchor.constraint(equalTo: contentView.rightAnchor, constant: -70).isActive = true
        switchButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        switchButton.widthAnchor.constraint(equalToConstant: 30).isActive = true
        switchButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
    }
    
    override func prepareForReuse() {
        switchButton.removeTarget(nil, action: nil, for: .allEvents)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
