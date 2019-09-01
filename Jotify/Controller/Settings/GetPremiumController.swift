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
        label.text = "Unlock dark mode, note themes, static color customization, and more."
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
        button.setTitle("Purchase", for: .normal)
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
        //        titleLabel.widthAnchor.constraint(equalToConstant: 150).isActive = true
        //        titleLabel.heightAnchor.constraint(equalToConstant: 52).isActive = true
        
        detailLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        detailLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10).isActive = true
        detailLabel.widthAnchor.constraint(equalToConstant: screenWidth / 1.15).isActive = true
        //        detailLabel.heightAnchor.constraint(equalToConstant: 52).isActive = true
        
        purchaseButton.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 100).isActive = true
        purchaseButton.topAnchor.constraint(equalTo: detailLabel.bottomAnchor, constant: 30).isActive = true
        purchaseButton.heightAnchor.constraint(equalToConstant: 80).isActive = true
        purchaseButton.widthAnchor.constraint(equalToConstant: 160).isActive = true
        
        cancelButton.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -100).isActive = true
        cancelButton.topAnchor.constraint(equalTo: detailLabel.bottomAnchor, constant: 30).isActive = true
        cancelButton.heightAnchor.constraint(equalToConstant: 80).isActive = true
        cancelButton.widthAnchor.constraint(equalToConstant: 160).isActive = true
    }
    
    @objc func purchasePremium(sender: UIButton) {
        guard let product = products.first else { return }
        JotifyProducts.store.buyProduct(product)
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
                
                print(products?.count as Any)
            }
        }
    }
    
    override func getPopupHeight() -> CGFloat {
        return 280
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
