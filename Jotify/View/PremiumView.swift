//
//  PremiumView.swift
//  Jotify
//
//  Created by Harrison Leath on 11/29/19.
//  Copyright © 2019 Harrison Leath. All rights reserved.
//

import UIKit
import StoreKit

class PremiumView {
        
    static let shared = PremiumView()
    
    var products: [SKProduct] = []
        
    func presentPremiumView(viewController: UIViewController) {
        
        requestProducts()
        
        let whatsNew = WhatsNew(
            title: "Get Premium",
            items: [
                WhatsNew.Item(
                    title: "Reminders",
                    subtitle: "Set reminders on all of your notes with ease. Simply tap on the alarm icon, set a date, and wait. All natively supported in Jotify.",
                    image: UIImage(named: "reminder")
                ),
                WhatsNew.Item(
                    title: "Biometric Unlock",
                    subtitle: "Lock and unlock Jotify by using TouchID or FaceID. The ultimate way to make your notes even more private and secure.",
                    image: UIImage(named: "lock")
                ),
                WhatsNew.Item(
                    title: "Themes",
                    subtitle: "Customize the look of your notes with 6 different themes: Default, Sunset, Kypool, Celestial, Scarlet Azure, and Apple Vibrant.",
                    image: UIImage(named: "themes")
                ),
                WhatsNew.Item(
                    title: "Premium Forever",
                    subtitle: "You will have access to all of Jotify's premium features forever. Even when the price of the app increases or new features are added, you will be covered.",
                    image: UIImage(named: "bugFix")
                ),
                WhatsNew.Item(
                    title: "Developer Support",
                    subtitle: "Jotify is an open source app, and it does not receive funding for its development. By buying Jotify premium, you are supporting an independent app developer and helping out the open source community by ensuring that Jotify is available for everyone, always.",
                    image: UIImage(named: "github")
                ),
            ]
        )
        
        var configuration = WhatsNewViewController.Configuration()
        
        if UserDefaults.standard.bool(forKey: "darkModeEnabled") == true {
            configuration.apply(theme: .darkDefault)
            configuration.backgroundColor = UIColor.grayBackground
            
        } else {
            configuration.apply(theme: .default)
        }
        
        if UserDefaults.standard.bool(forKey: "useRandomColor") == true {
            configuration.titleView.titleColor = StoredColors.noteColor
            configuration.detailButton?.titleColor = StoredColors.noteColor
            configuration.completionButton.backgroundColor = StoredColors.noteColor
            
        } else if UserDefaults.standard.bool(forKey: "useRandomColor") == false {
            configuration.titleView.titleColor = StoredColors.staticNoteColor
            configuration.detailButton?.titleColor = StoredColors.staticNoteColor
            configuration.completionButton.backgroundColor = StoredColors.staticNoteColor
        }
        
        configuration.titleView.insets = UIEdgeInsets(top: 40, left: 20, bottom: 15, right: 15)
        configuration.itemsView.titleFont = .boldSystemFont(ofSize: 17)
        configuration.itemsView.imageSize = .preferred
        configuration.completionButton.hapticFeedback = .impact(.medium)
        configuration.completionButton.title = "Buy \(products.first?.localizedPrice ?? "$1.99")"
        configuration.completionButton.insets.bottom = 30
        configuration.apply(animation: .fade)
        
        configuration.completionButton.action = .custom(action: { whatsNewViewController in
            self.buyPremium()
            whatsNewViewController.dismiss(animated: true, completion: nil)
        })

        let whatsNewViewController = WhatsNewViewController(
            whatsNew: whatsNew,
            configuration: configuration
        )
        
        DispatchQueue.main.async {
            viewController.present(whatsNewViewController, animated: true)
        }
    }
    
    func requestProducts() {
        JotifyProducts.store.requestProducts{ [weak self] success, products in
            guard let self = self else { return }
            if success {
                self.products = products!
            }
        }
    }
    
    func buyPremium() {
        guard let product = self.products.first else { return }
        JotifyProducts.store.buyProduct(product)
    }
}
