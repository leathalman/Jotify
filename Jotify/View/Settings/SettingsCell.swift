//
//  SettingsCell.swift
//  Jotify
//
//  Created by Harrison Leath on 2/1/21.
//

import UIKit

class SettingsCell: UITableViewCell {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension UITableViewCell {
    /// Sets the cell's title using iOS 14+ content configuration API. Replaces
    /// the deprecated `textLabel?.text` / `textLabel?.textColor` path.
    func setTitle(_ text: String, color: UIColor? = nil) {
        var config = defaultContentConfiguration()
        config.text = text
        if let color {
            config.textProperties.color = color
        }
        contentConfiguration = config
    }
}
