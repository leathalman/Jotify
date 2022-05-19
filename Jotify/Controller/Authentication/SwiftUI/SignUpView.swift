//
//  SignUpView.swift
//  KeyboardTest
//
//  Created by Harrison Leath on 3/17/21.
//

import UIKit
import SwiftUI
import AuthenticationServices

struct SignUpView: View {
    @Environment(\.colorScheme) var colorScheme
    @State var email: String = ""
    @State var password: String = ""
    
    var body: some View {
        ZStack {
            if #available(iOS 14.0, *) {
                if (colorScheme == .light) {
                    Color(UIColor.jotifyGray).ignoresSafeArea()
                } else {
                    //dark
                    Color(UIColor.mineShaft).ignoresSafeArea()
                }
            } else {
                // Fallback on earlier versions
            }
            VStack {
                Spacer()
                HStack {
                    VStack {
                        HStack {
                            WelcomeText()
                            Spacer()
                        }
                        HStack {
                            JotifyText()
                            Spacer()
                        }
                    }
                    Spacer()
                }
                EmailTextField(email: $email)
                PasswordTextField(password: $password)
                Spacer()
                DynamicSignInWithApple()
                    .frame(width: 280, height: 60)
                    .onTapGesture(perform: authController.presentSignInWithApple)
                OrTextView()
                Button(action: {
                    authController.userDidSubmitSignUp(email: email, password: password)
                }) {
                    SignUpButtonContent()
                }
                .padding(.bottom)
                HStack {
                    Text("Already have an account?")
                        .font(.subheadline)
                        .fontWeight(.bold)
                    Button(action: {
                        authController.presentLogIn()
                    }) {
                        LogInContent()
                    }
                }
                .opacity(0.75)
                .padding(.init(top: 20, leading: 0, bottom: 5, trailing: 0))
            }
            .padding()
            .dismissKeyboardOnTap()
        }
    }
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            SignUpView()
                .previewDevice(PreviewDevice(rawValue: "iPhone 8"))
        }
    }
}

struct SignUpButtonContent: View {
    var body: some View {
        Text("Sign Up")
            .font(.system(size: 24))
            .fontWeight(.semibold)
            .foregroundColor(.white)
            .padding()
            .frame(width: 280, height: 60)
            .background(Color(UIColor.jotifyBlue))
            .cornerRadius(10)
    }
}

struct LogInContent: View {
    var body: some View {
        Text("Log In.")
            .font(.subheadline)
            .fontWeight(.bold)
            .foregroundColor(Color(UIColor.jotifyBlue))
    }
}

struct WelcomeText: View {
    var body: some View {
        Text("Welcome to")
            .font(.system(size: 52))
            .fontWeight(.bold)
            .padding(.init(top: 0, leading: 20, bottom: 0, trailing: 20))
    }
}
