//
//  WelcomeViewController.swift
//  Jotify
//
//  Created by Harrison Leath on 5/19/22.
//

import UIKit

class WelcomeViewOnboardingController: UIViewController {
    
    lazy var welcomeImg: UIImageView = {
        let welcome = UIImage(named: "Welcome")
        let image = UIImageView(image: welcome)
        image.contentMode = .scaleAspectFit
        image.backgroundColor = .clear
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    lazy var titleView: UITextView = {
        let view = UITextView()
        view.backgroundColor = .clear
        view.isScrollEnabled = false
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let detailText: UITextView = {
        let tv = UITextView()
        tv.text = "Welcome to the latest version of Jotify! Packed with new features and visual improvements. Follow along for a brief overview of the changes."
        tv.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        tv.textAlignment = .center
        tv.backgroundColor = .clear
        tv.isUserInteractionEnabled = false
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()
    
    lazy var nextButton: UIButton = {
        let button = UIButton()
        button.setTitle("Next", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(scrollToNextPage), for: .touchUpInside)
        button.backgroundColor = UIColor.jotifyBlue
        button.layer.cornerRadius = 10
        button.translatesAutoresizingMaskIntoConstraints = false
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
        
        //handle attributed string for titleView
        var textColor: UIColor = .white
        if traitCollection.userInterfaceStyle == .light {
            textColor = .black
        }
        
        let text = "Welcome to "
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 50, weight: .bold),
            .foregroundColor: textColor,
        ]
        let attributed = NSMutableAttributedString(string: text, attributes: attributes)
        
        let text2 = "Jotify."
        let attributes2: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 50, weight: .bold),
            .foregroundColor: UIColor.jotifyBlue,
        ]
        let attributed2 = NSMutableAttributedString(string: text2, attributes: attributes2)
        
        attributed.append(attributed2)
        
        titleView.attributedText = attributed
        titleView.textAlignment = .center
    }
    
    func setupContraints() {
        view.addSubview(wrapper)
        view.addSubview(nextButton)
        
        wrapper.addSubview(titleView)
        wrapper.addSubview(welcomeImg)
        wrapper.addSubview(detailText)
        
        wrapper.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        wrapper.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        wrapper.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.90).isActive = true
        wrapper.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.80).isActive = true
                
        welcomeImg.centerXAnchor.constraint(equalTo: wrapper.centerXAnchor).isActive = true
        welcomeImg.centerYAnchor.constraint(equalTo: wrapper.centerYAnchor, constant: 25).isActive = true
        welcomeImg.heightAnchor.constraint(equalTo: wrapper.heightAnchor, multiplier: 0.50).isActive = true
        welcomeImg.widthAnchor.constraint(equalTo: wrapper.widthAnchor).isActive = true
        
        titleView.centerXAnchor.constraint(equalTo: wrapper.centerXAnchor).isActive = true
        titleView.topAnchor.constraint(equalTo: wrapper.topAnchor).isActive = true
        titleView.bottomAnchor.constraint(equalTo: welcomeImg.topAnchor, constant: 0).isActive = true
        titleView.widthAnchor.constraint(equalTo: wrapper.widthAnchor).isActive = true
        
        nextButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        nextButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -75).isActive = true
        nextButton.widthAnchor.constraint(equalToConstant: 250).isActive = true
        nextButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
    }
    
    @objc func scrollToNextPage() {
        let rootVC = self.rootViewController as! OnboardingController
        rootVC.scrollToNextPage()
        self.playHapticFeedback()
    }
    
    //traitcollection: dynamic iPad layout and light/dark mode support
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        setStyle()
    }
    
}
