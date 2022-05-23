//
//  ReferralSettingsController.swift
//  Jotify
//
//  Created by Harrison Leath on 5/22/22.
//

import UIKit
import MessageUI

class ReferralSettingsController: UIViewController, MFMessageComposeViewControllerDelegate {
    
    lazy var customImg: UIImageView = {
        let customization = UIImage(named: "Referral")
        let image = UIImageView(image: customization)
        image.contentMode = .scaleAspectFit
        image.backgroundColor = .clear
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    let detailText: UITextView = {
        let tv = UITextView()
        tv.font = UIFont.systemFont(ofSize: 20, weight: .bold)
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
        button.addTarget(self, action: #selector(shareReferral), for: .touchUpInside)
        button.setTitle("Invite Someone", for: .normal)
        return button
    }()
    
    let wrapper: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    //press a button to send referral link
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = ColorManager.bgColor
        
        let referrals = User.settings?.referrals ?? 0
        
        if referrals >= 3 {
            detailText.text = "You already have \(referrals) referrals. Congratulations, you have Jotify premium! Thank you for your support :)"
        } else if referrals == 2 {
            detailText.text = "You have \(referrals) referrals. You only need \(3 - referrals) more referral to get Jotify premium. Share Jotify and get rewarded!"
        } else if referrals == 1 {
            detailText.text = "You have \(referrals) referral. You only need \(3 - referrals) more referrals to get Jotify premium. Share Jotify and get rewarded!"
        } else {
            detailText.text = "You have \(referrals) referrals. You only need \(3 - referrals) more referrals to get Jotify premium. Share Jotify and get rewarded!"
        }

        view.addSubview(wrapper)
        view.addSubview(nextButton)
        
        wrapper.addSubview(customImg)
        wrapper.addSubview(detailText)
        
        wrapper.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        wrapper.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        wrapper.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.85).isActive = true
        wrapper.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.80).isActive = true
                
        customImg.centerXAnchor.constraint(equalTo: wrapper.centerXAnchor).isActive = true
        customImg.topAnchor.constraint(equalTo: wrapper.topAnchor, constant: 25).isActive = true
        customImg.heightAnchor.constraint(equalTo: wrapper.heightAnchor, multiplier: 0.50).isActive = true
        customImg.widthAnchor.constraint(equalTo: wrapper.widthAnchor).isActive = true
        
        detailText.centerXAnchor.constraint(equalTo: wrapper.centerXAnchor).isActive = true
        detailText.topAnchor.constraint(equalTo: customImg.bottomAnchor, constant: 50).isActive = true
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
    
    @objc func shareReferral() {
        let invitationLink = User.settings?.referralLink
        let subject = "You should start using Jotify! Use my referreral link: \(invitationLink ?? "nil")"
        
        let messageComposer = MFMessageComposeViewController()
        messageComposer.messageComposeDelegate = self
        messageComposer.body = subject
        
        self.playHapticFeedback()
        
        if MFMessageComposeViewController.canSendText() {
            present(messageComposer, animated: true)
        } else {
            //TODO: Copy the link to the clipboard and present alert to user telling them this.
            UIPasteboard.general.string = subject
            let alertController = UIAlertController(title: "Unable to Send", message: "You cannot message from this device, so Jotify copied the referral link to your clipboard.", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: {(action) in }))
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        if result == .sent {
            dismiss(animated: true)
        } else if result == .cancelled {
            dismiss(animated: true)
        } else {
            dismiss(animated: true)
            //copy link to clipboard and alert user
            let invitationLink = User.settings?.referralLink
            UIPasteboard.general.string = "You should start using Jotify! Use my referreral link: \(invitationLink ?? "nil")"
            let alertController = UIAlertController(title: "Unable to Send", message: "The message failed to send, so Jotify copied the link to your clipboard.", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: {(action) in }))
            self.present(alertController, animated: true, completion: nil)
        }
    }
}
