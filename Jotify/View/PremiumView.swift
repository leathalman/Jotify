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
                    title: "Features",
                    subtitle: "You can now delete multiple notes at once! Simply long press a note, click \"select multiple\", and then delete as many as your heart desires.",
                    image: UIImage(named: "write")
                ),
                WhatsNew.Item(
                    title: "Improvements",
                    subtitle: "Added an additional dark mode icon for Jotify! To check it out, click on the gear icon, then about, and finally tap on the large icon image. Also added automatic saving for notes whenever the app enters multitasking.",
                    image: UIImage(named: "add")
                ),
                WhatsNew.Item(
                    title: "Bug Fixes",
                    subtitle: "Fixed a bug where notes would incorrectly order themselves after sorting. Also fixed an issue where navigation bar would update with the wrong color in dark mode.",
                    image: UIImage(named: "bugFix")
                ),
            ]
        )
        
        var configuration = WhatsNewViewController.Configuration()
        
        if UserDefaults.standard.bool(forKey: "darkModeEnabled") == true {
            configuration.apply(theme: .darkDefault)
            configuration.backgroundColor = .grayBackground
            
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
        configuration.completionButton.title = "Buy $1.99"
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
