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
                NavigationRow(text: "Themes", detailText: .value1(""), icon: .named("NAME OF IMAGE HERE"), action: { _ in }),
                ], footer: ""),
            
            RadioSection(title: "Radio Buttons", options: [
                OptionRow(text: "Option 1", isSelected: true, action: didToggleSelection()),
                OptionRow(text: "Option 2", isSelected: false, action: didToggleSelection()),
                OptionRow(text: "Option 3", isSelected: false, action: didToggleSelection())
                ], footer: "See RadioSection for more details.")
        ]
    }
    
    func setupView() {
        navigationItem.title = "Settings"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.isTranslucent = false
        
        //this is a bad implementation of this because it updates slowly, fix before release
        navigationController?.navigationBar.backgroundColor = UIColor(named: "viewBackgroundColor")
        navigationController?.view.backgroundColor = UIColor(named: "viewBackgroundColor")
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isUserInteractionEnabled = true
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            print("1")
        case 1:
            let themeSelectionViewController = ThemeSelectionController()
//            present(UINavigationController(rootViewController: themeSelectionViewController), animated: true)
            navigationController?.pushViewController(themeSelectionViewController, animated: true)
        case 2:
            print("3")
        default:
            break
        }
        
    }
    
    private func showAlert(_ sender: Row) {
        // ...
        
        print("hello")
    }
    
    private func didToggleSelection() -> (Row) -> Void {
        return { [weak self] row in
            // ...
        }
    }
    
}
