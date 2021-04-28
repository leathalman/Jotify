//
//  NoteOptionMenu.swift
//  Jotify
//
//  Created by Harrison Leath on 4/27/21.
//

import UIKit
import SwiftMessages

class NoteOptionMenu: MessageView {
    
    @IBOutlet weak var button1: PassableUIButton!
    @IBOutlet weak var button2: PassableUIButton!
    @IBOutlet weak var button3: PassableUIButton!
    @IBOutlet weak var button4: PassableUIButton!
    
    /*
     MARK: - Identifiable
     */
    
    open override var id: String {
        get {
            return customId ?? "MessageView:title=\(String(describing: titleLabel?.text)), button1:title=\(String(describing:button1.title)),button2:title=\(String(describing:button1.title)),button3:title=\(String(describing:button1.title)),button4:title=\(String(describing:button1.title))"
        }
        set {
            customId = newValue
        }
    }
    
    private var customId: String?
    
    /*
     MARK: - AccessibleMessage
     */

    /**
     An optional prefix for the `accessibilityMessage` that can
     be used to futher clarify the message for VoiceOver. For example,
     the view's background color or icon might convey that a message is
     a warning, in which case one may specify the value "warning".
     */

    open override var accessibilityMessage: String? {
        let components = [accessibilityPrefix, titleLabel?.text, button1?.titleLabel?.text, button2.titleLabel?.text, button3.titleLabel?.text, button4.titleLabel?.text].compactMap { $0 }
        guard components.count > 0 else { return nil }
        return components.joined(separator: ", ")
    }

    open override var additonalAccessibilityElements: [NSObject]? {
        var elements: [NSObject] = []
        func getAccessibleSubviews(view: UIView) {
            for subview in view.subviews {
                if subview.isAccessibilityElement {
                    elements.append(subview)
                } else {
                    // Only doing this for non-accessible `subviews`, which avoids
                    // including button labels, etc.
                    getAccessibleSubviews(view: subview)
                }
            }
        }
        getAccessibleSubviews(view: self.backgroundView)
        return elements
    }
    
    
}
