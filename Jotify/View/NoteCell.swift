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
    
    let reminderIcon: UIImageView = {
        let view = UIImageView ()
        view.image = UIImage(systemName: "timer")
        view.translatesAutoresizingMaskIntoConstraints = false
        view.alpha = 0
        return view
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
        contentView.addSubview(reminderIcon)
        
        textLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 10).isActive = true
        textLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -10).isActive = true
        textLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0).isActive = true
        textLabel.heightAnchor.constraint(equalTo: contentView.heightAnchor, constant: -35).isActive = true
        
        dateLabel.leftAnchor.constraint(equalTo: textLabel.leftAnchor).isActive = true
        dateLabel.topAnchor.constraint(equalTo: textLabel.bottomAnchor, constant: 5).isActive = true
        dateLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        dateLabel.widthAnchor.constraint(equalTo: textLabel.widthAnchor, constant: -30).isActive = true
        
        reminderIcon.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -10).isActive = true
        reminderIcon.topAnchor.constraint(equalTo: textLabel.bottomAnchor, constant: 5).isActive = true
        reminderIcon.heightAnchor.constraint(equalToConstant: 20).isActive = true
        reminderIcon.widthAnchor.constraint(equalToConstant: 20).isActive = true
    }
    
    func shake() {
        let shakeAnimation = CABasicAnimation(keyPath: "transform.rotation")
        shakeAnimation.duration = 0.05
        shakeAnimation.repeatCount = 2
        shakeAnimation.autoreverses = true
        let startAngle: Float = (-2) * 3.14159/180
        let stopAngle = -startAngle
        shakeAnimation.fromValue = NSNumber(value: startAngle as Float)
        shakeAnimation.toValue = NSNumber(value: 3 * stopAngle as Float)
        shakeAnimation.autoreverses = true
        shakeAnimation.duration = 0.2
        shakeAnimation.repeatCount = 10000
        shakeAnimation.timeOffset = 290 * drand48()
        
        let layer: CALayer = self.layer
        layer.add(shakeAnimation, forKey:"shaking")
   }
    
    func stopShaking() {
        let layer: CALayer = self.layer
        layer.removeAnimation(forKey: "shaking")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
