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
            field.contentInset = .zero
            field.frame = CGRect(x: 0, y: 100, width: view.bounds.width, height: UIScreen.main.bounds.height / 4)
        } else {
            field.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height + 42, right: 0)
            field.frame = CGRect(x: 0, y: 40, width: view.bounds.width, height: UIScreen.main.bounds.height)
        }

        field.scrollIndicatorInsets = field.contentInset
        field.scrollRangeToVisible(field.selectedRange)
    }
}
