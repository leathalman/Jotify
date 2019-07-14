//
//  AboutSettingsController.swift
//  Jotify
//
//  Created by Harrison Leath on 7/13/19.
//  Copyright © 2019 Harrison Leath. All rights reserved.
//

import UIKit

class AboutSettingsController: UIViewController {
    
    let aboutSettingsView = AboutSettingsView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.white
        
        navigationItem.title = "About"
                
        view = aboutSettingsView
    }
    
}
