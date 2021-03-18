//
//  WriteNoteController+KeyboardNotifications.swift
//  Jotify
//
//  Created by Harrison Leath on 1/18/21.
//

import UIKit

extension WriteNoteController {
    //view resizing from keyboard
    func setupNotifications() {
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }

    @objc func adjustForKeyboard(notification: Notification) {
        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        let keyboardScreenEndFrame = keyboardValue.cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)

        if notification.name == UIResponder.keyboardWillHideNotification {
            draftView.textField.contentInset = .zero
            draftView.textField.frame = CGRect(x: 0, y: 100, width: view.bounds.width, height: UIScreen.main.bounds.height / 4)
        } else {
            draftView.textField.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height + 42, right: 0)
            draftView.textField.frame = CGRect(x: 0, y: 40, width: view.bounds.width, height: UIScreen.main.bounds.height)
        }

        draftView.textField.scrollIndicatorInsets = draftView.textField.contentInset
        draftView.textField.scrollRangeToVisible(draftView.textField.selectedRange)
    }
}
