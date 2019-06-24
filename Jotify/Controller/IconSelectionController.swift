//
//  IconSelectionController.swift
//  Jotify
//
//  Created by Harrison Leath on 6/23/19.
//  Copyright © 2019 Harrison Leath. All rights reserved.
//

import UIKit
import QuickTableViewController

class IconSelectionController: QuickTableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    func setupView() {
        navigationItem.title = "Icons"
        navigationController?.navigationBar.prefersLargeTitles = false
        tableView.isUserInteractionEnabled = true
    }
}

