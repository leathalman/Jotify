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
        navigationItem.title = "About"
        
        self.navigationItem.rightBarButtonItem
            = UIBarButtonItem(title: "Restore", style: .plain, target: self, action: #selector(restorePurchases))
        
        view = aboutSettingsView
        aboutSettingsView.versionLabel.textColor = InterfaceColors.fontColor
        aboutSettingsView.backgroundColor = InterfaceColors.viewBackgroundColor
    }
    
    @objc func restorePurchases() {
        JotifyProducts.store.restorePurchases()
        
        let alert = UIAlertController(title: "Wait for it...", message: "Let's see if you already purchased Jotify premium.", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "I'm waiting", style: .cancel, handler: { (UIAlertAction) in
            self.successfullyRestoredPurchase()

        }))
        
        self.present(alert, animated: true)
    }
    
    func successfullyRestoredPurchase() {
        print(UserDefaults.standard.bool(forKey: "com.austinleath.Jotify.premium"))
        if UserDefaults.standard.bool(forKey: "com.austinleath.Jotify.premium") == true {
            
            let alert = UIAlertController(title: "Congratulations!", message: "You successfully restored your purchase! Enjoy Jotify premium!", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Yay!", style: .cancel, handler: { (UIAlertAction) in

            }))
            self.present(alert, animated: true)
            
        } else if UserDefaults.standard.bool(forKey: "com.austinleath.Jotify.premium") == false {
            
            let alert = UIAlertController(title: "Not quite.", message: "It looks like you have not bought premium yet. Please consider supporting Jotify!", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { (UIAlertAction) in

            }))
            self.present(alert, animated: true)
        }
    }
    
}
