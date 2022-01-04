//
//  ContentView.swift
//  KeyboardTest
//
//  Created by Harrison Leath on 3/17/21.
//

import SwiftUI

let authController = AuthenticationController()

struct LogInView: View {
    @Environment(\.colorScheme) var colorScheme
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
            HStack {
                Spacer()
                Button(action: {
                    authController.userDidForgetPassword()
                }) {
                    ForgotPasswordContent()
                }
            }
            Spacer()
            DynamicSignInWithApple()
                .frame(width: 280, height: 60)
                .onTapGesture(perform: authController.presentSignInWithApple)
            OrTextView()
            Button(action: {
                authController.userDidSubmitLogIn(email: email, password: password)
            }) {
                LoginButtonContent()
            }
            .padding(.bottom)
            HStack {
                Text("Don't have an account?")
                    .font(.subheadline)
                    .fontWeight(.bold)
                Button(action: {
                    authController.presentSignUp()
                }) {
                    SignUpContent()
                }
            }
            .opacity(colorScheme == .light ? 0.75 : 1.00)
            .padding(.init(top: 20, leading: 0, bottom: 5, trailing: 0))
            
        }
        .padding()
        .dismissKeyboardOnTap()
    }
}

struct LogInView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ForEach(ColorScheme.allCases, id: \.self) {
                LogInView()
                    .preferredColorScheme($0)
                    .previewDevice(PreviewDevice(rawValue: "iPhone 8"))
            }
        }
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

struct JotifyText: View {
    var body: some View {
        Text("Jotify.")
            .font(.system(size: 52))
            .fontWeight(.bold)
            .foregroundColor(Color(UIColor.jotifyBlue))
            .padding(.init(top: 0, leading: 20, bottom: 40, trailing: 20))
    }
}

struct EmailTextField: View {
    @Environment(\.colorScheme) var colorScheme
    @Binding var email: String
    var body: some View {
        return TextField("Email", text: $email)
            .padding()
            .background(colorScheme == .light ? Color(.lightTrail) : Color(.mineShaft))
            .cornerRadius(5.0)
            .padding(.init(top: 0, leading: 20, bottom: 15, trailing: 20))
    }
}

struct PasswordTextField: View {
    @Environment(\.colorScheme) var colorScheme
    @Binding var password: String
    var body: some View {
        return SecureField("Password", text: $password)
            .padding()
            .background(colorScheme == .light ? Color(.lightTrail) : Color(.mineShaft))
            .cornerRadius(5.0)
            .padding(.init(top: 0, leading: 20, bottom: 15, trailing: 20))
    }
}

struct ForgotPasswordContent: View {
    @Environment(\.colorScheme) var colorScheme
    var body: some View {
        Text("Forgot password?")
            .font(.subheadline)
            .fontWeight(.bold)
            .foregroundColor(colorScheme == .light ? .black : .white)
            .opacity(colorScheme == .light ? 0.75 : 1.00)
            .padding(.init(top: 0, leading: 20, bottom: 20, trailing: 20))
    }
}

struct DynamicSignInWithApple: View {
    @Environment(\.colorScheme) var colorScheme
    var body: some View {
        if colorScheme == .light {
            SignInWithAppleBlack()
        } else if colorScheme == .dark {
            SignInWithAppleWhite()
        }
    }
}

struct OrTextView: View {
    @Environment(\.colorScheme) var colorScheme
    var body: some View {
        Text("— or —")
            .font(.headline)
            .fontWeight(.bold)
            .foregroundColor(colorScheme == .light ? .black : .white)
            .opacity(colorScheme == .light ? 0.75 : 1.00)
    }
}

struct LoginButtonContent: View {
    var body: some View {
        Text("Login")
            .font(.system(size: 24))
            .fontWeight(.semibold)
            .foregroundColor(.white)
            .padding()
            .frame(width: 280, height: 60)
            .background(Color(UIColor.jotifyBlue))
            .cornerRadius(10)
    }
}

struct SignUpContent: View {
    var body: some View {
        Text("Sign Up.")
            .font(.subheadline)
            .fontWeight(.bold)
            .foregroundColor(Color(UIColor.jotifyBlue))
    }
}
