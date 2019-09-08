//
//  GetPremiumController.swift
//  Jotify
//
//  Created by Harrison Leath on 8/14/19.
//  Copyright © 2019 Harrison Leath. All rights reserved.
//

import UIKit
import StoreKit
import BottomPopup

class GetPremiumController: BottomPopupViewController {
    
    var products: [SKProduct] = []
    
    var rootViewController = UIViewController()
    
    public var screenWidth: CGFloat {
        return UIScreen.main.bounds.width
    }
    
    public var screenHeight: CGFloat {
        return UIScreen.main.bounds.height
    }
    
    lazy var colorView: UIView = {
        let view = UIView()
        let frame = CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight)
        view.frame = frame
        
        return view
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Get Premium."
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 40)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    lazy var detailLabel: UILabel = {
        let label = UILabel()
        label.text = "Unlock dark mode, note themes, static color customization, biometrics, and more."
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.numberOfLines = 0
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    lazy var purchaseButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.setTitle("Buy $1.99", for: .normal)
        button.addTarget(self, action: #selector(purchasePremium(sender:)), for: .touchUpInside)
        button.backgroundColor = UIColor.black
        button.layer.cornerRadius = 5
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    lazy var cancelButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.setTitle("Cancel", for: .normal)
        button.addTarget(self, action: #selector(handleCancel(sender:)), for: .touchUpInside)
        button.backgroundColor = UIColor.black
        button.layer.cornerRadius = 5
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        fetchProducts()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let randomColor = randomColorFromTheme()
        setupView(color: randomColor)
        
        NotificationCenter.default.addObserver(self, selector: #selector(handlePurchaseNotification(_:)), name: .IAPHelperPurchaseNotification, object: nil)
    }
    
    func setupView(color: UIColor) {
        colorView.backgroundColor = color
        purchaseButton.backgroundColor = color.adjust(by: -5)
        cancelButton.backgroundColor = color.adjust(by: -5)
        
        view.addSubview(colorView)
        view.addSubview(titleLabel)
        view.addSubview(detailLabel)
        view.addSubview(purchaseButton)
        view.addSubview(cancelButton)
        
        titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 25).isActive = true
        
        detailLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        detailLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10).isActive = true
        detailLabel.widthAnchor.constraint(equalToConstant: screenWidth / 1.15).isActive = true
        
        purchaseButton.heightAnchor.constraint(equalToConstant: screenHeight / 11).isActive = true
        purchaseButton.widthAnchor.constraint(equalToConstant: screenWidth - 30).isActive = true
        purchaseButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        purchaseButton.bottomAnchor.constraint(equalTo: cancelButton.topAnchor, constant: -15).isActive = true
        
        cancelButton.heightAnchor.constraint(equalToConstant: screenHeight / 11).isActive = true
        cancelButton.widthAnchor.constraint(equalToConstant: screenWidth - 30).isActive = true
        cancelButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        cancelButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -30).isActive = true

    }
    
    @objc func handlePurchaseNotification(_ notification: Notification) {
        print("Notification called")
        purchasePremiumSuccess()
    }
    
    @objc func purchasePremium(sender: UIButton) {
        guard let product = products.first else { return }
        JotifyProducts.store.buyProduct(product)
    }
    
    func purchasePremiumSuccess() {
        dismiss(animated: true, completion: nil)
        let alert = UIAlertController(title: "Thank you for supporting Jotify!", message: "You're awesome. Enjoy premium 😄", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Yay!", style: .cancel, handler: { (UIAlertAction) in
            
        }))
        
        self.view.window?.rootViewController?.present(alert, animated: true)
    }
    
    @objc func handleCancel(sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func fetchProducts() {
        products = []
        
        JotifyProducts.store.requestProducts{ [weak self] success, products in
            guard let self = self else { return }
            if success {
                self.products = products!
            }
        }
    }
    
    override func getPopupHeight() -> CGFloat {
        if screenHeight < 600 {
            return screenHeight / 1.5
        } else {
            return screenHeight / 2
        }
    }
    
    func randomColorFromTheme() -> UIColor {
        let colorTheme = UserDefaults.standard.string(forKey: "noteColorTheme")
        var randomColor: UIColor = .white
        
        if colorTheme == "default" {
            randomColor = Colors.defaultColors.randomElement() ?? UIColor.white
            
        } else if colorTheme == "sunset" {
            randomColor = Colors.sunsetColors.randomElement() ?? UIColor.white
            
        } else if colorTheme == "kypool" {
            randomColor = Colors.kypoolColors.randomElement() ?? UIColor.white
            
        } else if colorTheme == "celestial" {
            randomColor = Colors.celestialColors.randomElement() ?? UIColor.white
            
        } else if colorTheme == "appleVibrant" {
            randomColor = Colors.appleVibrantColors.randomElement() ?? UIColor.white
        }
        
        return randomColor
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .darkContent
    }
    
}
