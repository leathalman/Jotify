//
//  TimePickerCell.swift
//  Jotify
//
//  Created by Harrison Leath on 7/20/21.
//

import UIKit

protocol TimePickerDelegate: AnyObject {
    func didChangeTime(date: Date)
}

class TimePickerCell: UITableViewCell {
    
    let picker = UIDatePicker()
    weak var delegate: TimePickerDelegate?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        if #available(iOS 14.0, *) {
            picker.preferredDatePickerStyle = .wheels
        } else {
            // Fallback on earlier versions
        }
        
        picker.datePickerMode = .time
        
        contentView.addSubview(picker)
        
        picker.translatesAutoresizingMaskIntoConstraints = false
        
        picker.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        picker.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        picker.widthAnchor.constraint(equalToConstant: 250).isActive = true
        picker.heightAnchor.constraint(equalToConstant: 250).isActive = true
        
        picker.addTarget(self, action: #selector(dateDidChange), for: .valueChanged)
    }
    
    @objc func dateDidChange(_ sender: UIDatePicker) {
        delegate?.didChangeTime(date: sender.date)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
