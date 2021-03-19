//
//  SignUpView.swift
//  KeyboardTest
//
//  Created by Harrison Leath on 3/17/21.
//

import SwiftUI

struct SignUpView: View {
    @State var email: String = ""
    @State var password: String = ""
    
    var body: some View {
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
            Button(action: {
                authController.userDidSubmitSignUp(email: email, password: password)
            }) {
                SignUpButtonContent()
            }
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
            .font(.headline)
            .foregroundColor(.white)
            .padding()
            .frame(width: 200, height: 50)
            .background(Color.blue)
            .cornerRadius(10)
    }
}

struct LogInContent: View {
    var body: some View {
        Text("Log In.")
            .font(.subheadline)
            .fontWeight(.bold)
            .foregroundColor(.blue)
    }
}
