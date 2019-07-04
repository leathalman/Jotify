//
//  SettingsController.swift
//  Sticky Notes
//
//  Created by Harrison Leath on 5/12/19.
//  Copyright © 2019 Harrison Leath. All rights reserved.
//

import UIKit
import QuickTableViewController

class SettingsController: QuickTableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        
        tableContents = [
            Section(title: "Switch", rows: [
                SwitchRow(text: "Setting 1", switchValue: true, action: { _ in }),
                SwitchRow(text: "Use Static Gradient", switchValue: false, action: { _ in })
                ]),
            
            Section(title: "Appearance", rows: [
                NavigationRow(text: "App Icon", detailText: .value1(""), icon: .named("NAME OF IMAGE HERE"), action: { _ in }),
                NavigationRow(text: "Themes", detailText: .value1(""), icon: .named("NAME OF IMAGE HERE"), action: { _ in }),
                ], footer: "Select color for gradient."),
            
        ]
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
//        navigationController?.navigationBar.backgroundColor = StoredColors.noteColor
//        navigationController?.navigationBar.tintColor = StoredColors.noteColor
//        navigationController?.navigationBar.barTintColor = StoredColors.noteColor

    }
    
    func setupView() {
        navigationItem.title = "Settings"
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationController?.navigationBar.isTranslucent = false
//        navigationItem.largeTitleDisplayMode = .always
        
        //this is a bad implementation of this because it updates slowly, fix before release
        navigationController?.navigationBar.backgroundColor = UIColor(named: "viewBackgroundColor")
        navigationController?.view.backgroundColor = UIColor(named: "viewBackgroundColor")
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isUserInteractionEnabled = true
        
        setupSwipes()
    }
    
    @objc func handleSwipes(_ gesture: UISwipeGestureRecognizer) {
        if gesture.direction == .left {
            
        } else if gesture.direction == .right {
            tabBarController?.selectedIndex = 1
            
        }
    }
    
    func setupSwipes() {
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(self.handleSwipes(_:)))
        swipeLeft.direction = .left
        view.addGestureRecognizer(swipeLeft)
        view.isUserInteractionEnabled = true
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(self.handleSwipes(_:)))
        swipeRight.direction = .right
        view.addGestureRecognizer(swipeRight)
        view.isUserInteractionEnabled = true
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            let themeSelectionViewController = ThemeSelectionController()
            navigationController?.pushViewController(themeSelectionViewController, animated: true)
        case 1:
            let themeSelectionViewController = ThemeSelectionController()
            navigationController?.pushViewController(themeSelectionViewController, animated: true)
        case 2:
            print("3")
        default:
            break
        }
    }
    
    @objc func actionEdit() {
        dismiss(animated: true, completion: nil)
    }
    
}
