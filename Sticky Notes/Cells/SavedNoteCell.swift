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
        let label = UILabel(frame: CGRect(x:100, y: 30, width: UIScreen.main.bounds.width , height: 40))
        label.textAlignment = .left
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.text = ""
        return label
    }()

    override init(frame : CGRect) {
        super.init(frame : frame)
        
        contentView.widthAnchor.constraint(equalToConstant: frame.width).isActive = true
        contentView.heightAnchor.constraint(equalToConstant: 87).isActive = true
        
        contentView.addSubview(textLabel)
    }
    
    override func layoutSubviews() {
        textLabel.frame = bounds
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
