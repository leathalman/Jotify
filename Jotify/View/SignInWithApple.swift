//
//  SignInWithApple.swift
//  Jotify
//
//  Created by Harrison Leath on 4/5/21.
//

import SwiftUI
import AuthenticationServices

/// Apple's own Sign in with Apple button, as a capsule to match the app's
/// other primary buttons. Taps are handled by the caller.
struct SignInWithAppleButtonView: UIViewRepresentable {
    var style: ASAuthorizationAppleIDButton.Style

    func makeUIView(context: Context) -> ASAuthorizationAppleIDButton {
        let button = ASAuthorizationAppleIDButton(type: .signIn, style: style)
        button.cornerRadius = 25
        return button
    }

    func updateUIView(_ uiView: ASAuthorizationAppleIDButton, context: Context) {}
}
