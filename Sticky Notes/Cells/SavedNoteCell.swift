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
        label.text = "Default Text! Another one here we go I'm adding a bunc"
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

        textLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 10).isActive = true
        textLabel.topAnchor.constraint(equalTo: topAnchor, constant: -20).isActive = true
        textLabel.heightAnchor.constraint(equalTo: heightAnchor).isActive = true
        textLabel.widthAnchor.constraint(equalTo: widthAnchor, constant: -10).isActive = true
        
//        dateLabel.leftAnchor.constraint(equalTo: leftAnchor., multiplier: <#T##CGFloat#>)

//        nameLabel.leftAnchor.constraint(equalTo: profileImageButton.rightAnchor, constant: 5).isActive = true
//        nameLabel.centerYAnchor.constraint(equalTo: profileImageButton.centerYAnchor, constant: -8).isActive = true
//        nameLabel.rightAnchor.constraint(equalTo: pricePerHourLabel.leftAnchor).isActive = true
//
//        distanceLabel.leftAnchor.constraint(equalTo: nameLabel.leftAnchor).isActive = true
//        distanceLabel.centerYAnchor.constraint(equalTo: profileImageButton.centerYAnchor, constant: 8).isActive = true
//        distanceLabel.widthAnchor.constraint(equalToConstant: 300)
//
//        pricePerHourLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -10).isActive = true
//        pricePerHourLabel.centerYAnchor.constraint(equalTo: nameLabel.centerYAnchor).isActive = true
//
//        // Distance depeneded on the priceLabel and distance Label
//        ratingLabel.rightAnchor.constraint(equalTo: pricePerHourLabel.rightAnchor).isActive = true
//        ratingLabel.centerYAnchor.constraint(equalTo: distanceLabel.centerYAnchor).isActive = true
//
//        showCaseImageView.topAnchor.constraint(equalTo: profileImageButton.bottomAnchor, constant: 10).isActive = true
//        showCaseImageView.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
//        showCaseImageView.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.width - 20).isActive = true
//
//        likesLabel.topAnchor.constraint(equalTo: showCaseImageView.bottomAnchor, constant: 10).isActive = true
//        likesLabel.leftAnchor.constraint(equalTo: profileImageButton.leftAnchor).isActive = true
//
//        topSeparatorView.topAnchor.constraint(equalTo: likesLabel.bottomAnchor, constant: 10).isActive = true
//        topSeparatorView.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
//        topSeparatorView.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
//
//        stackView.addArrangedSubview(likeButton)
//        stackView.addArrangedSubview(hireButton)
//        stackView.addArrangedSubview(messageButton)
//
//        stackView.topAnchor.constraint(equalTo: topSeparatorView.bottomAnchor, constant: 4).isActive = true
//        stackView.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
//        stackView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
//
//        bottomSeparatorView.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 4).isActive = true
//        bottomSeparatorView.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
//        bottomSeparatorView.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
//
//
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
