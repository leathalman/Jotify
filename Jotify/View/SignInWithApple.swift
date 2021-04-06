//
//  SignInWithAppleView.swift
//  Jotify
//
//  Created by Harrison Leath on 4/5/21.
//

import SwiftUI
import AuthenticationServices

final class SignInWithAppleBlack: UIViewRepresentable {
  
  func makeUIView(context: Context) -> ASAuthorizationAppleIDButton {
    let button = ASAuthorizationAppleIDButton(type: .signIn, style: .black)
    button.cornerRadius = 10
    return button
  }
  
  func updateUIView(_ uiView: ASAuthorizationAppleIDButton, context: Context) {}
}

final class SignInWithAppleWhite: UIViewRepresentable {
  
  func makeUIView(context: Context) -> ASAuthorizationAppleIDButton {
    let button = ASAuthorizationAppleIDButton(type: .signIn, style: .white)
    button.cornerRadius = 10
    return button
  }
  
  func updateUIView(_ uiView: ASAuthorizationAppleIDButton, context: Context) {}
}
