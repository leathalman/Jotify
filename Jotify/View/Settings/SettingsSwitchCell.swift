//
//  SettingsSwitchCell.swift
//  Jotify
//
//  Created by Harrison Leath on 2/1/21.
//

import UIKit

class SettingsSwitchCell: UITableViewCell {
    let detailText = UILabel()
    let switchButton = UISwitch()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(detailText)
        contentView.addSubview(switchButton)
        
        detailText.translatesAutoresizingMaskIntoConstraints = false
        switchButton.translatesAutoresizingMaskIntoConstraints = false
        
        detailText.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        detailText.widthAnchor.constraint(equalTo: contentView.widthAnchor, constant: -10).isActive = true
        detailText.heightAnchor.constraint(equalTo: contentView.heightAnchor, constant: -10).isActive = true
        
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
