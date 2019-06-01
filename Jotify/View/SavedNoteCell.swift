//
//  SavedNoteCell.swift
//  Sticky Notes
//
//  Created by Harrison Leath on 5/15/19.
//  Copyright © 2019 Harrison Leath. All rights reserved.
//

import UIKit

class SavedNoteCell: UICollectionViewCell {

    var textLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        label.textColor = UIColor.darkGray
        label.text = "Default Text! Another one here we go!"
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    let dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = UIColor.darkGray
        label.text = "May 26, 2019"
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

        textLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 10).isActive = true
        textLabel.topAnchor.constraint(equalTo: topAnchor, constant: -20).isActive = true
        textLabel.heightAnchor.constraint(equalTo: heightAnchor).isActive = true
        textLabel.widthAnchor.constraint(equalTo: widthAnchor, constant: -10).isActive = true
        
        dateLabel.leftAnchor.constraint(equalTo: textLabel.leftAnchor).isActive = true
        dateLabel.topAnchor.constraint(equalTo: textLabel.bottomAnchor, constant: -10).isActive = true
        dateLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        dateLabel.widthAnchor.constraint(equalTo: textLabel.widthAnchor).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
