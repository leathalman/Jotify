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
        label.font = UIFontMetrics(forTextStyle: .subheadline)
            .scaledFont(for: .systemFont(ofSize: 15, weight: .bold))
        label.adjustsFontForContentSizeCategory = true
        label.textColor = .white
        label.text = "Loading..."
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = UIColor.clear
        label.numberOfLines = 3
        label.lineBreakMode = .byTruncatingTail
        label.verticalAlignment = .top
        return label
    }()

    let dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .footnote)
        label.adjustsFontForContentSizeCategory = true
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
        // Corner radius stays the same for every note, so set once here
        // instead of re-setting on every `cellForItemAt`. Clipping on
        // contentView lets subviews stay square without extra masks.
        contentView.layer.cornerRadius = 5
        contentView.clipsToBounds = true
        addViews()
    }
    
    func addViews() {
        if UIDevice.current.userInterfaceIdiom == .pad {
            textLabel.numberOfLines = 4
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
    
    /// Home-screen-style jiggle for cells selected in multi-select mode.
    /// Symmetric (±1.5°) so the card rocks in place instead of leaning, and
    /// a no-op if already running so re-configuring a cell doesn't restart it
    /// from a new phase.
    func shake() {
        guard layer.animation(forKey: "shaking") == nil else { return }
        let angle = 1.5 * Double.pi / 180
        let shakeAnimation = CABasicAnimation(keyPath: "transform.rotation")
        shakeAnimation.fromValue = -angle
        shakeAnimation.toValue = angle
        shakeAnimation.duration = 0.12
        shakeAnimation.autoreverses = true
        shakeAnimation.repeatCount = .infinity
        // Random phase so neighbouring cards don't move in lockstep.
        shakeAnimation.timeOffset = Double.random(in: 0..<shakeAnimation.duration * 2)
        layer.add(shakeAnimation, forKey: "shaking")
    }

    func stopShaking() {
        layer.removeAnimation(forKey: "shaking")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
