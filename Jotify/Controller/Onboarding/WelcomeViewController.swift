//
//  WelcomeViewController.swift
//  Jotify
//
//  Created by Harrison Leath on 1/13/22.
//

import UIKit

class WelcomeViewController: UIViewController {
    
    let tv: UITextView = {
        let tv = UITextView()
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.text = "Welcome to"
        tv.font = UIFont.systemFont(ofSize: 42, weight: .heavy)
        tv.textAlignment = .center
        tv.textColor = .white
        tv.backgroundColor = .clear
        tv.isUserInteractionEnabled = false
        return tv
    }()
    
    let tv2: UITextView = {
        let tv = UITextView()
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.text = "Jotify"
        tv.font = UIFont.systemFont(ofSize: 42, weight: .heavy)
        tv.textAlignment = .center
        tv.textColor = .jotifyBlue
        tv.backgroundColor = .clear
        tv.isUserInteractionEnabled = false
        return tv
    }()
    
    let title1: UITextView = {
        let tv = UITextView()
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.text = "Write a Note"
        tv.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        tv.textAlignment = .left
        tv.textColor = .white
        tv.backgroundColor = .clear
        tv.isUserInteractionEnabled = false
        return tv
    }()
    
    let detail1: UITextView = {
        let tv = UITextView()
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.text = "These are words that are very important to tell users because they won't figure it out on thier own."
        tv.font = UIFont.systemFont(ofSize: 12, weight: .bold)
        tv.textAlignment = .left
        tv.textColor = .white
        tv.backgroundColor = .clear
        tv.isUserInteractionEnabled = false
        tv.textContainerInset = .zero
        return tv
    }()
    
    let title2: UITextView = {
        let tv = UITextView()
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.text = "Reminders"
        tv.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        tv.textAlignment = .left
        tv.textColor = .white
        tv.backgroundColor = .clear
        tv.isUserInteractionEnabled = false
        return tv
    }()
    
    let detail2: UITextView = {
        let tv = UITextView()
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.text = "These are words that are very important to tell users because they won't figure it out on thier own."
        tv.font = UIFont.systemFont(ofSize: 12, weight: .bold)
        tv.textAlignment = .left
        tv.textColor = .white
        tv.backgroundColor = .clear
        tv.isUserInteractionEnabled = false
        tv.textContainerInset = .zero
        return tv
    }()
    
    let title3: UITextView = {
        let tv = UITextView()
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.text = "Reimagined"
        tv.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        tv.textAlignment = .left
        tv.textColor = .white
        tv.backgroundColor = .clear
        tv.isUserInteractionEnabled = false
        return tv
    }()
    
    let detail3: UITextView = {
        let tv = UITextView()
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.text = "Something, something, completely new visuals, incredible syncing performance, and improved user interactability"
        tv.font = UIFont.systemFont(ofSize: 12, weight: .bold)
        tv.textAlignment = .left
        tv.textColor = .white
        tv.backgroundColor = .clear
        tv.isUserInteractionEnabled = false
        tv.textContainerInset = .zero
        return tv
    }()
    
    let jotifyIconView: UIImageView = {
        let view = UIImageView(image: UIImage(named: "icon"))
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 20
        view.clipsToBounds = true
        return view
    }()
    
    let writeIcon: UIImageView = {
        let view = UIImageView(image: UIImage(systemName: "square.and.pencil"))
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        view.tintColor = .jotifyBlue
        return view
    }()
    
    let timerIcon: UIImageView = {
        let view = UIImageView(image: UIImage(systemName: "timer"))
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        view.tintColor = .jotifyBlue
        return view
    }()
    
    let docIcon: UIImageView = {
        let view = UIImageView(image: UIImage(systemName: "doc.plaintext"))
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        view.tintColor = .jotifyBlue
        return view
    }()
    
    let nextButton: UIButton = {
        let button = UIButton()
        button.setTitle("Next", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(scrollToNextPage), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor.jotifyBlue
        button.layer.cornerRadius = 10
       return button
    }()
    
    let section1: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        return view
    }()
    
    let section2: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        return view
    }()
    
    let section3: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        return view
    }()
    
    override func viewDidLoad() {
        setupView()
    }
    
    func setupView() {
        view.backgroundColor = .black
        
        view.addSubview(nextButton)
        view.addSubview(jotifyIconView)
        view.addSubview(tv)
        view.addSubview(tv2)
        
        //section 1
        section1.addSubview(writeIcon)
        section1.addSubview(title1)
        section1.addSubview(detail1)
        view.addSubview(section1)
        
        //section 2
        section2.addSubview(timerIcon)
        section2.addSubview(title2)
        section2.addSubview(detail2)
        view.addSubview(section2)
        
        //section 3
        section3.addSubview(docIcon)
        section3.addSubview(title3)
        section3.addSubview(detail3)
        view.addSubview(section3)
        
        setupConstraints()
    }
    
    func setupConstraints() {
        let spacingFromIcons: CGFloat = 20
        
        jotifyIconView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        jotifyIconView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -275).isActive = true
        jotifyIconView.widthAnchor.constraint(equalToConstant: 83).isActive = true
        jotifyIconView.heightAnchor.constraint(equalToConstant: 83).isActive = true
        
        tv.topAnchor.constraint(equalTo: jotifyIconView.bottomAnchor, constant: 10).isActive = true
        tv.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        tv.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, constant: 10).isActive = true
        tv.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        tv2.topAnchor.constraint(equalTo: tv.bottomAnchor, constant: 0).isActive = true
        tv2.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        tv2.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, constant: 10).isActive = true
        tv2.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        //section 1
        section1.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        section1.topAnchor.constraint(equalTo: tv2.bottomAnchor, constant: 35).isActive = true
        section1.heightAnchor.constraint(equalToConstant: 85).isActive = true
        if UIDevice.current.userInterfaceIdiom == .pad {
            section1.widthAnchor.constraint(equalToConstant: 500).isActive = true
        } else if UIDevice.current.userInterfaceIdiom == .phone {
            section1.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.92).isActive = true
        }
        
        writeIcon.leftAnchor.constraint(equalTo: section1.leftAnchor, constant: 10).isActive = true
        writeIcon.centerYAnchor.constraint(equalTo: section1.centerYAnchor, constant: 0).isActive = true
        writeIcon.widthAnchor.constraint(equalToConstant: 40).isActive = true
        writeIcon.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        title1.leftAnchor.constraint(equalTo: writeIcon.rightAnchor, constant: spacingFromIcons).isActive = true
        title1.topAnchor.constraint(equalTo: writeIcon.topAnchor, constant: -25).isActive = true
        title1.widthAnchor.constraint(equalTo: section1.widthAnchor, multiplier: 0.72).isActive = true
        title1.heightAnchor.constraint(equalToConstant: 35).isActive = true
        
        detail1.leftAnchor.constraint(equalTo: writeIcon.rightAnchor, constant: spacingFromIcons).isActive = true
        detail1.topAnchor.constraint(equalTo: title1.bottomAnchor, constant: 0).isActive = true
        detail1.widthAnchor.constraint(equalTo: section1.widthAnchor, multiplier: 0.72).isActive = true
        detail1.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        //section 2
        section2.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        section2.topAnchor.constraint(equalTo: section1.bottomAnchor, constant: 20).isActive = true
        section2.heightAnchor.constraint(equalToConstant: 85).isActive = true
        if UIDevice.current.userInterfaceIdiom == .pad {
            section2.widthAnchor.constraint(equalToConstant: 500).isActive = true
        } else if UIDevice.current.userInterfaceIdiom == .phone {
            section2.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.92).isActive = true
        }
        
        timerIcon.leftAnchor.constraint(equalTo: section2.leftAnchor, constant: 10).isActive = true
        timerIcon.centerYAnchor.constraint(equalTo: section2.centerYAnchor, constant: 0).isActive = true
        timerIcon.widthAnchor.constraint(equalToConstant: 40).isActive = true
        timerIcon.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        title2.leftAnchor.constraint(equalTo: timerIcon.rightAnchor, constant: spacingFromIcons).isActive = true
        title2.topAnchor.constraint(equalTo: timerIcon.topAnchor, constant: -25).isActive = true
        title2.widthAnchor.constraint(equalTo: section2.widthAnchor, multiplier: 0.72).isActive = true
        title2.heightAnchor.constraint(equalToConstant: 35).isActive = true
        
        detail2.leftAnchor.constraint(equalTo: timerIcon.rightAnchor, constant: spacingFromIcons).isActive = true
        detail2.topAnchor.constraint(equalTo: title2.bottomAnchor, constant: 0).isActive = true
        detail2.widthAnchor.constraint(equalTo: section2.widthAnchor, multiplier: 0.72).isActive = true
        detail2.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        //section 3
        section3.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        section3.topAnchor.constraint(equalTo: section2.bottomAnchor, constant: 20).isActive = true
        section3.heightAnchor.constraint(equalToConstant: 85).isActive = true
        if UIDevice.current.userInterfaceIdiom == .pad {
            section3.widthAnchor.constraint(equalToConstant: 500).isActive = true
        } else if UIDevice.current.userInterfaceIdiom == .phone {
            section3.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.92).isActive = true
        }
        
        docIcon.leftAnchor.constraint(equalTo: section3.leftAnchor, constant: 10).isActive = true
        docIcon.centerYAnchor.constraint(equalTo: section3.centerYAnchor, constant: 0).isActive = true
        docIcon.widthAnchor.constraint(equalToConstant: 40).isActive = true
        docIcon.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        title3.leftAnchor.constraint(equalTo: docIcon.rightAnchor, constant: spacingFromIcons).isActive = true
        title3.topAnchor.constraint(equalTo: docIcon.topAnchor, constant: -25).isActive = true
        title3.widthAnchor.constraint(equalTo: section3.widthAnchor, multiplier: 0.72).isActive = true
        title3.heightAnchor.constraint(equalToConstant: 35).isActive = true
        
        detail3.leftAnchor.constraint(equalTo: docIcon.rightAnchor, constant: spacingFromIcons).isActive = true
        detail3.topAnchor.constraint(equalTo: title3.bottomAnchor, constant: 0).isActive = true
        detail3.widthAnchor.constraint(equalTo: section3.widthAnchor, multiplier: 0.72).isActive = true
        detail3.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        nextButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        nextButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -75).isActive = true
        nextButton.widthAnchor.constraint(equalToConstant: 250).isActive = true
        nextButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    @objc func scrollToNextPage() {
        let rootVC = self.rootViewController as! OnboardingController
        rootVC.scrollToNextPage()
        self.playHapticFeedback()
    }
    
    @objc func skipPressed() {
        print("Skip pressed.")
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .darkContent
    }
}
