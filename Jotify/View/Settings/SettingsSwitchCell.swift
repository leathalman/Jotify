//
//  SettingsSwitchCell.swift
//  Jotify
//
//  Created by Harrison Leath on 2/1/21.
//

import UIKit

class SettingsSwitchCell: UITableViewCell {
    let switchButton = UISwitch()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        // `.subtitle` preserves `detailTextLabel` support used by
        // ReminderController for showing picked date/time strings. The switch
        // itself is now placed via `accessoryView` so UIKit handles trailing
        // inset, RTL mirroring, and dynamic type — no more manual 70pt offset.
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        accessoryView = switchButton
        selectionStyle = .none
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        switchButton.removeTarget(nil, action: nil, for: .allEvents)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
