//
//  BuyPremiumController.swift
//  Jotify
//
//  Created by Harrison Leath on 5/23/22.
//

import UIKit

class BuyPremiumController: UIViewController {
    
    lazy var customImg: UIImageView = {
        let customization = UIImage(named: "IAP")
        let image = UIImageView(image: customization)
        image.contentMode = .scaleAspectFit
        image.backgroundColor = .clear
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    let titleText: UITextView = {
        let tv = UITextView()
        tv.font = UIFont.systemFont(ofSize: 28, weight: .bold)
        tv.textAlignment = .center
        tv.backgroundColor = .clear
        tv.isUserInteractionEnabled = false
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.text = "Get Premium Today!"
        return tv
    }()
    
    let detailText: UITextView = {
        let tv = UITextView()
        tv.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        tv.textAlignment = .center
        tv.backgroundColor = .clear
        tv.isUserInteractionEnabled = false
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.text = "Unlock unlimited notes with instant syncing, a brilliantly fast interface, reminders, customization, and so much more. Or refer 3 friends and get premium for free! Already have premium? Restore your purchase in settings."
        return tv
    }()
    
    lazy var nextButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor.jotifyBlue
        button.layer.cornerRadius = 10
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(initiatePurchase), for: .touchUpInside)
        button.setTitle("Buy", for: .normal)
        return button
    }()
    
    let wrapper: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let price = IAPManager.shared.getPriceFormatted(for: IAPManager.products[0]) else { return }
        nextButton.setTitle("Buy for \(price)", for: .normal)
        
        setStyle()
        setupContraints()
    }
    
    func updateStatusBar(style: UIStatusBarStyle) {
        let rootVC = UIApplication.shared.windows.first!.rootViewController as! PageBoyController
        rootVC.statusBarStyle = style
        rootVC.setNeedsStatusBarAppearanceUpdate()
    }
    
    func setStyle() {
        if traitCollection.userInterfaceStyle == .light {
            view.backgroundColor = .jotifyGray
            updateStatusBar(style: .darkContent)
        } else {
            //dark
            view.backgroundColor = .mineShaft
            updateStatusBar(style: .lightContent)
        }
    }
    
    func setupContraints() {
        view.addSubview(wrapper)
        view.addSubview(nextButton)
        
        wrapper.addSubview(customImg)
        wrapper.addSubview(titleText)
        wrapper.addSubview(detailText)
        
        wrapper.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        wrapper.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        wrapper.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.85).isActive = true
        wrapper.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.80).isActive = true
        
        customImg.centerXAnchor.constraint(equalTo: wrapper.centerXAnchor).isActive = true
        customImg.topAnchor.constraint(equalTo: wrapper.topAnchor).isActive = true
        customImg.heightAnchor.constraint(equalTo: wrapper.heightAnchor, multiplier: 0.50).isActive = true
        customImg.widthAnchor.constraint(equalTo: wrapper.widthAnchor).isActive = true
        
        titleText.centerXAnchor.constraint(equalTo: wrapper.centerXAnchor).isActive = true
        titleText.topAnchor.constraint(equalTo: customImg.bottomAnchor, constant: 50).isActive = true
        titleText.heightAnchor.constraint(equalToConstant: 50).isActive = true
        titleText.widthAnchor.constraint(equalTo: wrapper.widthAnchor).isActive = true
        
        detailText.centerXAnchor.constraint(equalTo: wrapper.centerXAnchor).isActive = true
        detailText.topAnchor.constraint(equalTo: titleText.bottomAnchor).isActive = true
        detailText.heightAnchor.constraint(equalToConstant: 150).isActive = true
        
        //to make the text fit relatively ok on iPad
        if view.bounds.width * 0.85 > 500 {
            detailText.widthAnchor.constraint(equalToConstant: 500).isActive = true
        } else {
            detailText.widthAnchor.constraint(equalTo: wrapper.widthAnchor).isActive = true
        }
        
        nextButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        nextButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -75).isActive = true
        nextButton.widthAnchor.constraint(equalToConstant: 250).isActive = true
        nextButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
    }
    
    @objc func initiatePurchase() {
        self.playHapticFeedback()
        if IAPManager.shared.purchase(product: IAPManager.products[0]) {
            //TODO: Give the user feedback and tell them how much you appreciate it
            //and also change hasPremium to true
            DataManager.updateUserSettings(setting: "hasPremium", value: true) { success in
                if success! {
                    User.updateSettings()
                } else {
                    print("Error updating Firestore when enabling premium")
                }
            }
            self.dismiss(animated: true)
        } else {
            print("error purchasing IAP")
        }
    }
    
    //traitcollection: dynamic iPad layout and light/dark mode support
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        setStyle()
    }
}
