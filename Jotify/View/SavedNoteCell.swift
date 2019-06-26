//
//  SavedNoteCell.swift
//  Sticky Notes
//
//  Created by Harrison Leath on 5/15/19.
//  Copyright © 2019 Harrison Leath. All rights reserved.
//

import UIKit

class SavedNoteCell: UICollectionViewCell {
    
    var textLabel: UITextView = {
        let label = UITextView()
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        label.textColor = UIColor.darkGray
        label.text = "Loading..."
        label.isUserInteractionEnabled = false
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = UIColor.clear
        return label
    }()
    
    let dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = UIColor.darkGray
        label.text = "January 1, 2019"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame : CGRect) {
        super.init(frame : frame)
        addViews()
    }
    
    func addViews(){
        contentView.addSubview(textLabel)
        contentView.addSubview(dateLabel)
        
        textLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 5).isActive = true
        textLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0).isActive = true
        textLabel.heightAnchor.constraint(equalTo: heightAnchor).isActive = true
        textLabel.widthAnchor.constraint(equalTo: widthAnchor, constant: -10).isActive = true
        textLabel.bottomAnchor.constraint(equalTo: dateLabel.topAnchor, constant: 35).isActive = true
        
        dateLabel.leftAnchor.constraint(equalTo: textLabel.leftAnchor, constant: 5).isActive = true
        dateLabel.topAnchor.constraint(equalTo: textLabel.bottomAnchor, constant: 10).isActive = true
        dateLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        dateLabel.widthAnchor.constraint(equalTo: textLabel.widthAnchor).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
