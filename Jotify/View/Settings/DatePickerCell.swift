//
//  DatePickerCell.swift
//  Jotify
//
//  Created by Harrison Leath on 7/20/21.
//

import UIKit

protocol DatePickerDelegate: AnyObject {
    func didChangeDate(date: Date)
}

class DatePickerCell: UITableViewCell {
    
    let picker = UIDatePicker()
    weak var delegate: DatePickerDelegate?
        
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        if #available(iOS 14.0, *) {
            picker.preferredDatePickerStyle = .inline
        } else {
            // Fallback on earlier versions
        }
        
        picker.datePickerMode = .date
        //don't let user select date in the past for reminder
        picker.minimumDate = Date()
        
        contentView.addSubview(picker)
        
        picker.translatesAutoresizingMaskIntoConstraints = false
        
        picker.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        picker.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        picker.widthAnchor.constraint(equalToConstant: 300).isActive = true
        picker.heightAnchor.constraint(equalToConstant: 300).isActive = true
        
        picker.addTarget(self, action: #selector(dateDidChange), for: .valueChanged)
    }
    
    @objc func dateDidChange(_ sender: UIDatePicker) {
        delegate?.didChangeDate(date: sender.date)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
