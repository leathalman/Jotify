//
//  NoteViewController.swift
//  Sticky Notes
//
//  Created by Harrison Leath on 5/11/19.
//  Copyright © 2019 Harrison Leath. All rights reserved.
//

import UIKit
import paper_onboarding

class NoteViewController: UIViewController, UITextFieldDelegate {
    
    fileprivate let items = [
        OnboardingItemInfo(informationImage: Asset.hotels.image,
                           title: "",
                           description: "",
                           pageIcon: Asset.key.image,
                           color: UIColor(red: 0.40, green: 0.56, blue: 0.71, alpha: 1.00),
                           titleColor: UIColor.white, descriptionColor: UIColor.white, titleFont: titleFont, descriptionFont: descriptionFont),
        
        OnboardingItemInfo(informationImage: Asset.banks.image,
                           title: "",
                           description: "",
                           pageIcon: Asset.wallet.image,
                           color: UIColor(red: 0.40, green: 0.69, blue: 0.71, alpha: 1.00),
                           titleColor: UIColor.white, descriptionColor: UIColor.white, titleFont: titleFont, descriptionFont: descriptionFont),
        
        OnboardingItemInfo(informationImage: Asset.stores.image,
                           title: "",
                           description: "",
                           pageIcon: Asset.shoppingCart.image,
                           color: UIColor(red: 0.61, green: 0.56, blue: 0.74, alpha: 1.00),
                           titleColor: UIColor.white, descriptionColor: UIColor.white, titleFont: titleFont, descriptionFont: descriptionFont),

        ]
    
    lazy var inputTextField: UITextField = {
        let textField =  UITextField(frame: CGRect(x: 20, y: 100, width: 300, height: 40))
        textField.placeholder = "Enter text here"
        textField.font = UIFont.systemFont(ofSize: 15)
        textField.borderStyle = UITextField.BorderStyle.roundedRect
        textField.autocorrectionType = UITextAutocorrectionType.no
        textField.keyboardType = UIKeyboardType.default
        textField.clearButtonMode = UITextField.ViewMode.whileEditing
        textField.contentVerticalAlignment = UIControl.ContentVerticalAlignment.center
        return textField
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupPaperOnboardingView()
        
//        self.inputTextField.delegate = self
//        self.view.addSubview(inputTextField)
    }
    
    private func setupPaperOnboardingView() {
        let onboarding = PaperOnboarding()
        onboarding.delegate = self
        onboarding.dataSource = self
        onboarding.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(onboarding)
//        onboarding.currentIndex(1, animated: false)
        
        // Add constraints
        for attribute: NSLayoutConstraint.Attribute in [.left, .right, .top, .bottom] {
            let constraint = NSLayoutConstraint(item: onboarding,
                                                attribute: attribute,
                                                relatedBy: .equal,
                                                toItem: view,
                                                attribute: attribute,
                                                multiplier: 1,
                                                constant: 0)
            view.addConstraint(constraint)
        }
    }
}

// MARK: Actions

extension  NoteViewController {
    
    func example() {
        print("example")
    }
}

// MARK: PaperOnboardingDelegate

extension NoteViewController: PaperOnboardingDelegate {
    
    //    func onboardingWillTransitonToIndex(_ index: Int) {
    //        skipButton.isHidden = index == 2 ? false : true
    //    }
    
    func onboardingDidTransitonToIndex(_: Int) {
    }
    
    func onboardingConfigurationItem(_ item: OnboardingContentViewItem, index: Int) {
        
        // configure item
        //        item.titleLabel?.backgroundColor = .red
        //        item.descriptionLabel?.backgroundColor = .red
        //item.imageView = ...
    }
}

// MARK: PaperOnboardingDataSource

extension NoteViewController: PaperOnboardingDataSource {
    
    func onboardingItem(at index: Int) -> OnboardingItemInfo {
        return items[index]
    }
    
    //number of bubble items on the bottom of the screen
    func onboardingItemsCount() -> Int {
        return 3
    }
    
    //size of unselected bubble items on the bottom of the screen
    //    func onboardinPageItemRadius() -> CGFloat {
    //        return 2
    //    }
    
    //size of selected bubble items on the bottom on the screen
    //    func onboardingPageItemSelectedRadius() -> CGFloat {
    //        return 10
    //    }
    
    //color of bubble items on the bottom of the screen
    //    func onboardingPageItemColor(at index: Int) -> UIColor {
    //        return [UIColor.white, UIColor.red, UIColor.green][index]
    //    }
}


//MARK: Constants
extension NoteViewController {
    
    private static let titleFont = UIFont(name: "Nunito-Bold", size: 36.0) ?? UIFont.boldSystemFont(ofSize: 36.0)
    private static let descriptionFont = UIFont(name: "OpenSans-Regular", size: 14.0) ?? UIFont.systemFont(ofSize: 14.0)
}

