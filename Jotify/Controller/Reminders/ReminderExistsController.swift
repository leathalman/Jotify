//
//  ReminderExistsController.swift
//  Jotify
//
//  Created by Harrison Leath on 9/29/19.
//  Copyright © 2019 Harrison Leath. All rights reserved.
//

import UIKit
import BottomPopup

class ReminderExistsController: BottomPopupViewController {
    
    var noteColor = StoredColors.reminderColor
    var reminderDate = RemindersData.reminderDate
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Reminder already set:"
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 35)
        label.numberOfLines = 0
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    lazy var detailLabel: UILabel = {
        let label = UILabel()
        label.text = "Default text"
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.numberOfLines = 0
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    lazy var confirmButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.setTitle("Confirm", for: .normal)
        button.addTarget(self, action: #selector(setReminder(sender:)), for: .touchUpInside)
        button.backgroundColor = UIColor.black
        button.layer.cornerRadius = 5
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    func setupView() {
        setupDynamicColors()
        
        detailLabel.text = "Would you like to remove this reminder for \(reminderDate)?"
        
        view.addSubview(titleLabel)
        view.addSubview(detailLabel)
        view.addSubview(confirmButton)
        
        titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 25).isActive = true
        titleLabel.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width - 30).isActive = true
        
        detailLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        detailLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20).isActive = true
        detailLabel.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width / 1.15).isActive = true
        
        confirmButton.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height / 11).isActive = true
        confirmButton.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width - 30).isActive = true
        confirmButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        confirmButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20).isActive = true
    }
    
    func setupDynamicColors () {
        if UserDefaults.standard.bool(forKey: "darkModeEnabled") == true {
            view.backgroundColor = .grayBackground
            let confirmButtonColor = UIColor.grayBackground.adjust(by: 3.75)
            confirmButton.backgroundColor = confirmButtonColor
            
        } else if UserDefaults.standard.bool(forKey: "darkModeEnabled") == false {
            view.backgroundColor = noteColor
            confirmButton.backgroundColor = noteColor.adjust(by: -3.75)
        }
    }
    
    @objc func setReminder(sender: UIButton) {
        print("")
    }
    
    override func getPopupHeight() -> CGFloat {
        return UIScreen.main.bounds.height / 3 + 20
    }
}
