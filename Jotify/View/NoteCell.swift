//
//  NoteCell.swift
//  Zurich
//
//  Created by Harrison Leath on 1/12/21.
//

import UIKit

struct CellState {
    static var shouldSelectMultiple = Bool()
}

class SavedNoteCell: UICollectionViewCell {
    private var initialFrame: CGRect?
    private var initialCornerRadius: CGFloat?
    
    var textLabel: VerticalAlignLabel = {
        let label = VerticalAlignLabel()
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        label.textColor = .white
        label.text = "Loading..."
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = UIColor.clear
        label.numberOfLines = 3
        label.lineBreakMode = .byTruncatingTail
        label.sizeToFit()
        label.verticalAlignment = .top
        return label
    }()
    
    let dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .white
        label.text = "January 1, 2020"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addViews()
    }
    
    func addViews() {
        if UIDevice.current.userInterfaceIdiom == .pad {
            textLabel.numberOfLines = 4
            textLabel.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        }
        
        contentView.addSubview(textLabel)
        contentView.addSubview(dateLabel)
        
        textLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 10).isActive = true
        textLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -10).isActive = true
        textLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0).isActive = true
        textLabel.heightAnchor.constraint(equalTo: contentView.heightAnchor, constant: -35).isActive = true
        
        dateLabel.leftAnchor.constraint(equalTo: textLabel.leftAnchor).isActive = true
        dateLabel.topAnchor.constraint(equalTo: textLabel.bottomAnchor, constant: 5).isActive = true
        dateLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        dateLabel.widthAnchor.constraint(equalTo: textLabel.widthAnchor).isActive = true
    }
    
    override var isSelected: Bool {
        didSet {
            let noteColor = self.backgroundColor
            if CellState.shouldSelectMultiple {
                self.contentView.backgroundColor = isSelected ? UIColor.darkGray : noteColor
            }
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
