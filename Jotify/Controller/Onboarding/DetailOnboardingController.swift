//
//  DetailOnboardingController.swift
//  Jotify
//
//  Created by Harrison Leath on 5/19/22.
//

import UIKit
import SwiftUI

class DetailOnboardingController: UIViewController {
    
    var tText: String
    var dText: String
    var imgName: String
    var finalVC: Bool
    
    lazy var customImg: UIImageView = {
        let customization = UIImage(named: "Welcome")
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
        return tv
    }()
    
    let detailText: UITextView = {
        let tv = UITextView()
        tv.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        tv.textAlignment = .center
        tv.backgroundColor = .clear
        tv.isUserInteractionEnabled = false
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()
    
    lazy var nextButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor.jotifyBlue
        button.layer.cornerRadius = 10
        button.translatesAutoresizingMaskIntoConstraints = false
        if finalVC {
            button.addTarget(self, action: #selector(displaySignUp), for: .touchUpInside)
            button.setTitle("Get Started", for: .normal)
        } else {
            button.addTarget(self, action: #selector(scrollToNextPage), for: .touchUpInside)
            button.setTitle("Next", for: .normal)
        }
        return button
    }()
    
    let wrapper: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    init(tText: String, dText: String, imgName: String, finalVC: Bool) {
        self.tText = tText
        self.dText = dText
        self.imgName = imgName
        self.finalVC = finalVC
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //bring in init values
        titleText.text = tText
        detailText.text = dText
        customImg.image = UIImage(named: imgName)
        
        setStyle()
        setupContraints()
    }
    
    func updateStatusBar(style: UIStatusBarStyle) {
        let rootVC = UIApplication.shared.windows.first!.rootViewController as! OnboardingController
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
        customImg.topAnchor.constraint(equalTo: wrapper.topAnchor, constant: 25).isActive = true
        customImg.heightAnchor.constraint(equalTo: wrapper.heightAnchor, multiplier: 0.35).isActive = true
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
        nextButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50).isActive = true
        nextButton.widthAnchor.constraint(equalToConstant: 250).isActive = true
        nextButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
    }
    
    @objc func scrollToNextPage() {
        let rootVC = self.rootViewController as! OnboardingController
        rootVC.scrollToNextPage()
        self.playHapticFeedback()
    }
    
    @objc func displaySignUp() {
        self.playHapticFeedback()
        if (AuthManager().uid == "") {
            //not logged in or hasn't made an account before
            setRootViewController(duration: 0.4, vc: UIHostingController(rootView: SignUpView()))
        } else {
            //already logged in and already has an account
            setRootViewController(duration: 0.4, vc: PageBoyController())
        }
    }
    
    //traitcollection: dynamic iPad layout and light/dark mode support
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        setStyle()
    }
    
}
