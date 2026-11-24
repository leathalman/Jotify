//
//  LogInView.swift
//  Jotify
//
//  Created by Harrison Leath on 3/17/21.
//

import SwiftUI

let authController = AuthenticationController()

struct LogInView: View {
    var body: some View {
        AuthFormView(mode: .logIn)
    }
}

/// Shared layout for the log-in and sign-up screens: app icon, title,
/// Sign in with Apple first, then email and password.
struct AuthFormView: View {

    enum Mode {
        case logIn, signUp

        var title: String { self == .logIn ? "Welcome Back" : "Create Your Account" }
        var subtitle: String {
            self == .logIn ? "Log in to get to your notes." : "Your notes, synced and private on every device."
        }
        var action: String { self == .logIn ? "Log In" : "Sign Up" }
        var switchPrompt: String { self == .logIn ? "Don't have an account?" : "Already have an account?" }
        var switchAction: String { self == .logIn ? "Sign Up" : "Log In" }
    }

    let mode: Mode

    @Environment(\.colorScheme) private var colorScheme
    @State private var email = ""
    @State private var password = ""
    @FocusState private var focusedField: Field?

    private enum Field { case email, password }

    private var canSubmit: Bool {
        !email.trimmingCharacters(in: .whitespaces).isEmpty && !password.isEmpty
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 28) {
                header

                SignInWithAppleButtonView(style: colorScheme == .dark ? .white : .black)
                    .frame(height: 50)
                    .id(colorScheme) // the UIKit button can't restyle itself
                    .onTapGesture(perform: authController.presentSignInWithApple)
                    .accessibilityAddTraits(.isButton)
                    .accessibilityLabel("Sign in with Apple")

                divider

                VStack(spacing: 12) {
                    TextField("Email", text: $email)
                        .keyboardType(.emailAddress)
                        .textContentType(.emailAddress)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()
                        .submitLabel(.next)
                        .focused($focusedField, equals: .email)
                        .onSubmit { focusedField = .password }
                        .modifier(AuthFieldStyle())

                    SecureField("Password", text: $password)
                        .textContentType(mode == .logIn ? .password : .newPassword)
                        .submitLabel(.go)
                        .focused($focusedField, equals: .password)
                        .onSubmit(submit)
                        .modifier(AuthFieldStyle())

                    if mode == .logIn {
                        Button("Forgot Password?", action: authController.userDidForgetPassword)
                            .font(.footnote.weight(.semibold))
                            .frame(maxWidth: .infinity, alignment: .trailing)
                    }
                }

                Button(action: submit) {
                    Text(mode.action)
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 6)
                }
                .buttonStyle(.borderedProminent)
                .buttonBorderShape(.capsule)
                .controlSize(.large)
                .disabled(!canSubmit)
            }
            .padding(.horizontal, 24)
            .padding(.top, 48)
            .frame(maxWidth: 440)
            .frame(maxWidth: .infinity)
        }
        .scrollDismissesKeyboard(.interactively)
        .safeAreaInset(edge: .bottom) {
            HStack(spacing: 4) {
                Text(mode.switchPrompt)
                    .foregroundStyle(.secondary)
                Button(mode.switchAction) {
                    mode == .logIn ? authController.presentSignUp() : authController.presentLogIn()
                }
                .fontWeight(.semibold)
            }
            .font(.subheadline)
            .padding(.vertical, 12)
        }
        .background(Color(ColorManager.bgColor).ignoresSafeArea())
        .tint(Color(UIColor.brandCoral))
    }

    private var header: some View {
        VStack(spacing: 16) {
            Image("BrandIcon")
                .resizable()
                .scaledToFit()
                .frame(width: 88, height: 88)
                .shadow(color: .black.opacity(0.12), radius: 10, y: 4)
                .accessibilityHidden(true)
            VStack(spacing: 6) {
                Text(mode.title)
                    .font(.largeTitle.bold())
                Text(mode.subtitle)
                    .font(.body)
                    .foregroundStyle(.secondary)
            }
            .multilineTextAlignment(.center)
        }
    }

    private var divider: some View {
        HStack(spacing: 12) {
            Rectangle().fill(.separator).frame(height: 1)
            Text("or").font(.footnote).foregroundStyle(.secondary)
            Rectangle().fill(.separator).frame(height: 1)
        }
    }

    private func submit() {
        guard canSubmit else { return }
        focusedField = nil
        let address = email.trimmingCharacters(in: .whitespaces)
        if mode == .logIn {
            authController.userDidSubmitLogIn(email: address, password: password)
        } else {
            authController.userDidSubmitSignUp(email: address, password: password)
        }
    }
}

private struct AuthFieldStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding(.horizontal, 16)
            .frame(height: 50)
            .background(Color(UIColor.secondarySystemGroupedBackground),
                        in: RoundedRectangle(cornerRadius: 12, style: .continuous))
    }
}

#Preview("Log In") { LogInView() }
