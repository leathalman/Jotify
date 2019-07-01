//
//  SavedNoteCell.swift
//  Sticky Notes
//
//  Created by Harrison Leath on 5/15/19.
//  Copyright © 2019 Harrison Leath. All rights reserved.
//

import UIKit

protocol Expandable {
    func collapse()
    func expand(in collectionView: UICollectionView)
}

class SavedNoteCell: UICollectionViewCell, Expandable {
    
    private var initialFrame: CGRect?
    private var initialCornerRadius: CGFloat?
    
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
    
    // MARK: - Showing/Hiding Logic
    
    func hide(in collectionView: UICollectionView, frameOfSelectedCell: CGRect) {
        initialFrame = self.frame
        
        let currentY = self.frame.origin.y
        let newY: CGFloat
        
        if currentY < frameOfSelectedCell.origin.y {
            let offset = frameOfSelectedCell.origin.y - currentY
            newY = collectionView.contentOffset.y - offset
        } else {
            let offset = currentY - frameOfSelectedCell.maxY
            newY = collectionView.contentOffset.y + collectionView.frame.height + offset
        }
        
        self.frame.origin.y = newY
        
        layoutIfNeeded()
    }
    
    func show() {
        self.frame = initialFrame ?? self.frame
        
        initialFrame = nil
        
        layoutIfNeeded()
    }
    
    // MARK: - Expanding/Collapsing Logic
    
    func expand(in collectionView: UICollectionView) {
        initialFrame = self.frame
        initialCornerRadius = self.contentView.layer.cornerRadius
        
        self.contentView.layer.cornerRadius = 0
        self.frame = CGRect(x: 0, y: collectionView.contentOffset.y, width: collectionView.frame.width, height: collectionView.frame.height)
        
        layoutIfNeeded()
    }
    
    func collapse() {
        self.contentView.layer.cornerRadius = initialCornerRadius ?? self.contentView.layer.cornerRadius
        self.frame = initialFrame ?? self.frame
        
        initialFrame = nil
        initialCornerRadius = nil
        
        layoutIfNeeded()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
