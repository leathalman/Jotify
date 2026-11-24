//
//  SettingsView.swift
//  Jotify
//
//  One SwiftUI Form replacing the Master, General, Customization, Account
//  and Referral settings controllers.
//

import SwiftUI
import LocalAuthentication
import UserNotifications
import StoreKit

struct SettingsView: View {

    let noteCount: Int

    @Environment(\.dismiss) private var dismiss
    @Environment(\.openURL) private var openURL
    @Environment(\.requestReview) private var requestReview

    @AppStorage("defaultView") private var defaultView = 0
    @AppStorage("usePureDarkMode") private var usePureDarkMode = false
    @AppStorage("useHaptics") private var useHaptics = true
    @AppStorage("useBiometrics") private var useBiometrics = false
    @AppStorage("deleteOldNotes") private var deleteOldNotes = false
    @AppStorage("placeholder") private var placeholder = ""

    @State private var hasPremium = User.settings?.hasPremium ?? false
    @State private var paywallReason: PaywallView.Reason?
    @State private var message: AlertMessage?
    @State private var confirmation: Confirmation?
    @State private var isChangingEmail = false
    @State private var newEmail = ""
    @State private var isRestoring = false

    private let email = AuthManager().email

    var body: some View {
        NavigationStack {
            Form {
                premiumSection
                appearanceSection
                privacySection
                notesSection
                accountSection
                dataSection
                supportSection
                aboutSection
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") { dismiss() }
                }
            }
            .sheet(item: $paywallReason) { reason in
                PaywallView(reason: reason) { hasPremium = true }
            }
            .alert(item: $message) { message in
                Alert(title: Text(message.title), message: Text(message.text), dismissButton: .default(Text("OK")))
            }
            .confirmationDialog(confirmation?.title ?? "", isPresented: isConfirming, titleVisibility: .visible, presenting: confirmation) { confirmation in
                Button(confirmation.actionTitle, role: .destructive) { confirmation.action() }
                Button("Cancel", role: .cancel) {}
            } message: { confirmation in
                Text(confirmation.message)
            }
            .alert("Change Email", isPresented: $isChangingEmail) {
                TextField("New email address", text: $newEmail)
                    .keyboardType(.emailAddress)
                    .textContentType(.emailAddress)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
                Button("Cancel", role: .cancel) { newEmail = "" }
                Button("Change") { changeEmail() }
            } message: {
                Text("Enter your new email address. You may need to log in again first.")
            }
            .onAppear { hasPremium = User.settings?.hasPremium ?? false }
        }
        .tint(Color(UIColor.brandCoral))
    }

    // MARK: Sections

    @ViewBuilder private var premiumSection: some View {
        Section {
            if hasPremium {
                Label {
                    Text("Premium Unlocked")
                } icon: {
                    SettingsIcon(symbol: "star.fill", color: Color(UIColor.brandCoral))
                }
            } else {
                Button {
                    paywallReason = .general
                } label: {
                    Label {
                        VStack(alignment: .leading, spacing: 2) {
                            Text("Jotify Premium").foregroundStyle(Color.primary)
                            Text("Reminders, note colors, Face ID lock and more.")
                                .font(.footnote)
                                .foregroundStyle(Color.secondary)
                        }
                    } icon: {
                        SettingsIcon(symbol: "star.fill", color: Color(UIColor.brandCoral))
                    }
                }
            }
            NavigationLink {
                ReferralView(hasPremium: hasPremium)
            } label: {
                Label {
                    Text("Invite Friends")
                } icon: {
                    SettingsIcon(symbol: "gift.fill", color: .purple)
                }
            }
        }
    }

    private var appearanceSection: some View {
        Section("Appearance") {
            Picker(selection: $defaultView) {
                Text("New Note").tag(0)
                Text("Notes").tag(1)
            } label: {
                Label { Text("Open To") } icon: { SettingsIcon(symbol: "rectangle.portrait.on.rectangle.portrait", color: .blue) }
            }
            .onChange(of: defaultView) { _, value in
                sync("defaultView", value)
            }

            Toggle(isOn: $usePureDarkMode) {
                Label { Text("Pure Black in Dark Mode") } icon: { SettingsIcon(symbol: "moon.fill", color: .indigo) }
            }
            .onChange(of: usePureDarkMode) { _, value in
                sync("usePureDarkMode", value)
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "updatePureDarkMode"), object: nil)
            }

            Toggle(isOn: $useHaptics) {
                Label { Text("Haptics") } icon: { SettingsIcon(symbol: "hand.tap.fill", color: .pink) }
            }
            .onChange(of: useHaptics) { _, value in
                sync("useHaptics", value)
            }
        }
    }

    private var privacySection: some View {
        Section {
            Toggle(isOn: biometricsBinding) {
                Label { Text(biometryName + " Lock") } icon: { SettingsIcon(symbol: biometrySymbol, color: .green) }
            }
        } header: {
            Text("Privacy")
        } footer: {
            Text("Require \(biometryName) or your passcode to open Jotify.")
        }
    }

    private var notesSection: some View {
        Section {
            if hasPremium {
                NavigationLink {
                    PlaceholderEditor(placeholder: $placeholder)
                } label: {
                    Label { Text("New Note Prompt") } icon: { SettingsIcon(symbol: "character.cursor.ibeam", color: .orange) }
                }
            } else {
                Button {
                    paywallReason = .placeholder
                } label: {
                    Label { Text("New Note Prompt").foregroundStyle(Color.primary) } icon: { SettingsIcon(symbol: "character.cursor.ibeam", color: .orange) }
                }
            }

            Toggle(isOn: $deleteOldNotes) {
                Label { Text("Delete Notes After 30 Days") } icon: { SettingsIcon(symbol: "calendar.badge.clock", color: .red) }
            }
            .onChange(of: deleteOldNotes) { _, value in
                sync("deleteOldNotes", value)
            }
        } header: {
            Text("Notes")
        } footer: {
            Text("Notes older than 30 days are deleted the next time Jotify opens.")
        }
    }

    private var accountSection: some View {
        Section {
            Button {
                confirmation = Confirmation(title: "Reset Password?", message: "Jotify will email a password reset link to \(email).", actionTitle: "Send Reset Link") {
                    AuthManager.forgotPassword(email: email) { success, error in
                        message = success == true
                            ? AlertMessage(title: "Email Sent", text: "Check \(email) for a link to reset your password.")
                            : AlertMessage(title: "Couldn't Send Email", text: error ?? "Please try again later.")
                    }
                }
            } label: {
                SettingsRow(title: "Reset Password", symbol: "key.fill", color: .gray)
            }
            Button {
                isChangingEmail = true
            } label: {
                SettingsRow(title: "Change Email", symbol: "envelope.fill", color: .blue)
            }
            Button("Log Out", role: .destructive) {
                confirmation = Confirmation(title: "Log Out?", message: "Your notes stay synced to your account.", actionTitle: "Log Out") {
                    AuthManager.signOut()
                    UIApplication.shared.setRootViewController(UIHostingController(rootView: LogInView()))
                }
            }
        } header: {
            Text("Account")
        } footer: {
            Text("Signed in as \(email).")
        }
    }

    private var dataSection: some View {
        Section {
            Button {
                confirmation = Confirmation(title: "Reset Settings?", message: "All settings go back to their defaults. Your notes aren't affected.", actionTitle: "Reset Settings") {
                    resetSettings()
                }
            } label: {
                SettingsRow(title: "Reset Settings", symbol: "arrow.counterclockwise", color: .gray)
            }
            Button("Delete All Notes", role: .destructive) {
                confirmation = Confirmation(title: "Delete All Notes?", message: "All \(noteCount) notes are permanently deleted from every device. This can't be undone.", actionTitle: "Delete All Notes") {
                    deleteAllNotes()
                }
            }
            Button("Delete Account", role: .destructive) {
                confirmation = Confirmation(title: "Delete Your Jotify Account?", message: "Your account, notes and settings are permanently deleted from Jotify's servers. This can't be undone.", actionTitle: "Delete Account") {
                    deleteAccount()
                }
            }
        } header: {
            Text("Data")
        } footer: {
            Text("Deleted notes can't be recovered.")
        }
    }

    private var supportSection: some View {
        Section("Support") {
            Button(action: openSupportEmail) {
                SettingsRow(title: "Contact Support", symbol: "questionmark.bubble.fill", color: .blue)
            }
            Button {
                Task { await restorePurchase() }
            } label: {
                SettingsRow(title: isRestoring ? "Restoring…" : "Restore Purchase", symbol: "arrow.clockwise", color: .green)
            }
            .disabled(isRestoring)
            Button {
                requestReview()
            } label: {
                SettingsRow(title: "Rate Jotify", symbol: "star.fill", color: .yellow)
            }
        }
    }

    private var aboutSection: some View {
        Section("About") {
            LabeledContent("Version", value: Self.version)
            LabeledContent("Build", value: Self.build)
            LabeledContent("Notes", value: "\(noteCount)")
        }
    }

    // MARK: Biometrics

    private var biometryType: LABiometryType {
        let context = LAContext()
        _ = context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil)
        return context.biometryType
    }

    private var biometryName: String {
        switch biometryType {
        case .touchID: return "Touch ID"
        case .opticID: return "Optic ID"
        default: return "Face ID"
        }
    }

    private var biometrySymbol: String {
        switch biometryType {
        case .touchID: return "touchid"
        case .opticID: return "opticid"
        default: return "faceid"
        }
    }

    private var biometricsBinding: Binding<Bool> {
        Binding {
            useBiometrics
        } set: { enabled in
            guard hasPremium else {
                paywallReason = .privacy
                return
            }
            if enabled {
                var error: NSError?
                guard LAContext().canEvaluatePolicy(.deviceOwnerAuthentication, error: &error) else {
                    message = AlertMessage(title: "\(biometryName) Unavailable", text: "Set up \(biometryName) or a passcode in the Settings app to lock Jotify.")
                    return
                }
            }
            useBiometrics = enabled
            sync("useBiometrics", enabled)
        }
    }

    // MARK: Actions

    /// Mirrors a local setting to the user's Firestore settings document.
    private func sync(_ key: String, _ value: Any) {
        DataManager.updateUserSettings(setting: key, value: value) { _ in }
    }

    private func changeEmail() {
        let address = newEmail.trimmingCharacters(in: .whitespaces)
        newEmail = ""
        guard !address.isEmpty else { return }
        AuthManager.changeEmail(email: address) { success, error in
            message = AlertMessage(title: success == true ? "Check Your Email" : "Couldn't Change Email",
                                   text: error ?? "Follow the link sent to \(address) to finish changing your email.")
        }
    }

    private func resetSettings() {
        DataManager.deleteUserSettings { deleted in
            guard deleted == true else {
                message = AlertMessage(title: "Couldn't Reset Settings", text: "Please try again later.")
                return
            }
            DataManager.createUserSettings { created in
                User.updateSettings()
                message = created == true
                    ? AlertMessage(title: "Settings Reset", text: "Your settings are back to their defaults.")
                    : AlertMessage(title: "Couldn't Reset Settings", text: "Please try again later.")
            }
        }
    }

    private func deleteAllNotes() {
        DataManager.deleteAllNotes { success in
            if success {
                //notes are gone, so are their reminders
                UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
                UNUserNotificationCenter.current().setBadgeCount(0)
            }
            message = success
                ? AlertMessage(title: "Notes Deleted", text: "All of your notes were deleted.")
                : AlertMessage(title: "Couldn't Delete Notes", text: "Please try again later.")
        }
    }

    /// Deletes notes and settings while still signed in, then the Firebase
    /// Auth account (after which the data calls would have no user ID).
    private func deleteAccount() {
        // Firebase only deletes accounts shortly after a sign-in; check first
        // so the data isn't wiped and the account left behind.
        guard AuthManager.hasRecentLogin else {
            message = AlertMessage(title: "Log In Again", text: "For your security, log out and back in, then delete your account.")
            return
        }
        let fail = { (text: String) in message = AlertMessage(title: "Couldn't Delete Account", text: text) }

        DataManager.deleteAllNotes { notesDeleted in
            guard notesDeleted else { return fail("Your notes couldn't be deleted, so your account was kept. Please try again later.") }
            UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
            DataManager.deleteUserSettings { settingsDeleted in
                guard settingsDeleted == true else { return fail("Your settings couldn't be deleted, so your account was kept. Please try again later.") }
                AuthManager.deleteUser { deleted, error in
                    guard deleted == true else { return fail(error ?? "Please try again later.") }
                    AuthManager.signOut()
                    UIApplication.shared.setRootViewController(UIHostingController(rootView: LogInView()))
                }
            }
        }
    }

    private func restorePurchase() async {
        isRestoring = true
        defer { isRestoring = false }
        do {
            if try await PremiumStore.shared.restore() {
                hasPremium = true
                message = AlertMessage(title: "Purchase Restored", text: "Premium is unlocked. Thanks for supporting Jotify!")
            } else {
                message = AlertMessage(title: "Nothing to Restore", text: "No Premium purchase was found for this Apple Account. If you think that's wrong, contact support.")
            }
        } catch {
            message = AlertMessage(title: "Restore Failed", text: error.localizedDescription)
        }
    }

    private func openSupportEmail() {
        var components = URLComponents()
        components.scheme = "mailto"
        components.path = "hello@leathalenterprises.com"
        components.queryItems = [
            URLQueryItem(name: "subject", value: "Jotify Support"),
            URLQueryItem(name: "body", value: "\n\n—\nUser ID: \(AuthManager().uid)\nVersion: \(Self.version) (\(Self.build))"),
        ]
        if let url = components.url { openURL(url) }
    }

    private static let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "?"
    private static let build = Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "?"

    private var isConfirming: Binding<Bool> {
        Binding { confirmation != nil } set: { if !$0 { confirmation = nil } }
    }

    static func makeController(noteCount: Int) -> UIViewController {
        let controller = UIHostingController(rootView: SettingsView(noteCount: noteCount))
        controller.modalPresentationStyle = .pageSheet
        return controller
    }
}

extension PaywallView.Reason: Identifiable {
    var id: Self { self }
}

/// A destructive action waiting on a confirmation dialog.
private struct Confirmation {
    var title: String
    var message: String
    var actionTitle: String
    var action: () -> Void
}

/// A tappable Settings row: colored icon and primary-colored title, so a
/// list of actions doesn't read as a wall of tinted text.
struct SettingsRow: View {
    let title: String
    let symbol: String
    let color: Color

    var body: some View {
        Label {
            Text(title).foregroundStyle(Color.primary)
        } icon: {
            SettingsIcon(symbol: symbol, color: color)
        }
    }
}

/// iOS Settings-style icon: a white symbol on a colored rounded square.
struct SettingsIcon: View {
    let symbol: String
    let color: Color

    var body: some View {
        Image(systemName: symbol)
            .font(.system(size: 14, weight: .semibold))
            .foregroundStyle(.white)
            .frame(width: 28, height: 28)
            .background(color, in: RoundedRectangle(cornerRadius: 7, style: .continuous))
    }
}

/// Edits the prompt shown on a fresh note.
private struct PlaceholderEditor: View {
    @Binding var placeholder: String
    @State private var draft = ""
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        Form {
            Section {
                TextField("Start typing, or swipe right for your notes…", text: $draft, axis: .vertical)
                    .lineLimit(2...4)
            } footer: {
                Text("Shown on the write page before you start typing.")
            }
        }
        .navigationTitle("New Note Prompt")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                Button("Save") {
                    let text = draft.trimmingCharacters(in: .whitespacesAndNewlines)
                    guard !text.isEmpty else { return }
                    placeholder = text
                    DataManager.updateUserSettings(setting: "placeholder", value: text) { _ in }
                    dismiss()
                }
                .disabled(draft.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
            }
        }
        .onAppear { draft = placeholder }
    }
}

/// Invite friends: three sign-ups with your link unlock Premium.
private struct ReferralView: View {
    let hasPremium: Bool
    private let referrals = User.settings?.referrals ?? 0
    private let link = User.settings?.referralLink ?? ""

    var body: some View {
        Form {
            Section {
                VStack(spacing: 16) {
                    Image(systemName: "gift.fill")
                        .font(.system(size: 48))
                        .foregroundStyle(Color(UIColor.brandCoral))
                        .accessibilityHidden(true)
                    Text("Invite Friends, Get Premium")
                        .font(.title2.bold())
                        .multilineTextAlignment(.center)
                    Text(summary)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                    if !hasPremium {
                        ProgressView(value: Double(min(referrals, 3)), total: 3) {
                            Text("\(min(referrals, 3)) of 3 friends joined")
                                .font(.footnote)
                        }
                        .tint(Color(UIColor.brandCoral))
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
            }

            Section {
                if let url = URL(string: link), !link.isEmpty {
                    ShareLink(item: url, message: Text("I've been using Jotify for quick notes. Try it with my invite link:")) {
                        Label("Share Invite Link", systemImage: "square.and.arrow.up")
                    }
                } else {
                    Text("Your invite link is being created. Check back in a moment.")
                        .foregroundStyle(.secondary)
                }
            } footer: {
                Text("A friend counts once they sign up for Jotify using your link.")
            }
        }
        .navigationTitle("Invite Friends")
        .navigationBarTitleDisplayMode(.inline)
    }

    private var summary: String {
        if hasPremium {
            return "You already have Premium. Thanks for sharing Jotify anyway!"
        }
        let remaining = max(0, 3 - referrals)
        return "When \(remaining) more \(remaining == 1 ? "friend signs" : "friends sign") up with your link, Premium unlocks for free."
    }
}
