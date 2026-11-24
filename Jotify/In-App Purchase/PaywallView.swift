//
//  PaywallView.swift
//  Jotify
//
//  Replaces BuyPremiumController.
//

import SwiftUI
import StoreKit

struct PaywallView: View {

    /// Which locked feature brought the user here; sets the headline.
    enum Reason {
        case general, reminders, colors, placeholder, privacy

        var headline: String {
            switch self {
            case .general: return "Get Jotify Premium"
            case .reminders: return "Reminders Are a Premium Feature"
            case .colors: return "Note Colors Are a Premium Feature"
            case .placeholder: return "Make the Blank Page Yours"
            case .privacy: return "Lock Your Notes with Face ID"
            }
        }
    }

    var reason: Reason = .general
    var onUnlock: () -> Void = {}

    @ObservedObject private var store = PremiumStore.shared
    @Environment(\.dismiss) private var dismiss
    @State private var isWorking = false
    @State private var message: AlertMessage?

    var body: some View {
        ScrollView {
            VStack(spacing: 28) {
                hero
                VStack(spacing: 8) {
                    Text(reason.headline)
                        .font(.largeTitle.bold())
                        .multilineTextAlignment(.center)
                    Text("A one-time purchase. Yours on every device.")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                VStack(alignment: .leading, spacing: 20) {
                    Feature(symbol: "bell.badge.fill", title: "Reminders", detail: "Get a notification about any note, right when you need it.")
                    Feature(symbol: "paintpalette.fill", title: "Note Colors", detail: "Choose a color theme for each note.")
                    Feature(symbol: "faceid", title: "Face ID Lock", detail: "Keep your notes private behind Face ID or Touch ID.")
                    Feature(symbol: "character.cursor.ibeam", title: "Custom Placeholder", detail: "Set the prompt you see on a fresh note.")
                }
                .frame(maxWidth: 420, alignment: .leading)

                Text("Or invite 3 friends from Settings › Invite Friends to unlock Premium for free.")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
            }
            .padding(.horizontal, 24)
            .padding(.top, 48)
            .padding(.bottom, 24)
            .frame(maxWidth: .infinity)
        }
        .safeAreaInset(edge: .bottom) { purchaseButtons }
        .overlay(alignment: .topTrailing) {
            Button {
                dismiss()
            } label: {
                Image(systemName: "xmark")
                    .font(.body.weight(.semibold))
                    .frame(width: 32, height: 32)
            }
            .buttonStyle(.bordered)
            .buttonBorderShape(.circle)
            .tint(.secondary)
            .padding(16)
            .accessibilityLabel("Close")
        }
        .background(Color(ColorManager.bgColor).ignoresSafeArea())
        .task { await store.loadProduct() }
        .alert(item: $message) { message in
            Alert(title: Text(message.title), message: Text(message.text), dismissButton: .default(Text("OK")) {
                if message.closesPaywall { dismiss() }
            })
        }
    }

    private var hero: some View {
        Image("BrandIcon")
            .resizable()
            .scaledToFit()
            .frame(width: 120, height: 120)
            .shadow(color: .black.opacity(0.15), radius: 12, y: 6)
            .accessibilityHidden(true)
    }

    private var purchaseButtons: some View {
        VStack(spacing: 12) {
            Button {
                Task { await buy() }
            } label: {
                Group {
                    if isWorking {
                        ProgressView()
                    } else if let product = store.product {
                        Text("Unlock Premium – \(product.displayPrice)")
                    } else if store.isLoadingProduct {
                        Text("Loading…")
                    } else {
                        Text("Unlock Premium")
                    }
                }
                .font(.headline)
                .frame(maxWidth: 420)
                .padding(.vertical, 6)
            }
            .buttonStyle(.borderedProminent)
            .controlSize(.large)
            .tint(Color(UIColor.brandCoral))
            .disabled(isWorking)

            Button("Restore Purchase") {
                Task { await restore() }
            }
            .font(.subheadline)
            .disabled(isWorking)
        }
        .padding(.horizontal, 24)
        .padding(.vertical, 12)
        .background(.bar)
    }

    private func buy() async {
        isWorking = true
        defer { isWorking = false }
        do {
            switch try await store.purchase() {
            case .purchased:
                onUnlock()
                message = AlertMessage(title: "Thank You!", text: "Premium is unlocked. Enjoy Jotify!", closesPaywall: true)
            case .pending:
                message = AlertMessage(title: "Waiting for Approval", text: "Premium will unlock as soon as the purchase is approved.", closesPaywall: true)
            case .cancelled:
                break
            }
        } catch {
            message = AlertMessage(title: "Purchase Failed", text: error.localizedDescription)
        }
    }

    private func restore() async {
        isWorking = true
        defer { isWorking = false }
        do {
            if try await store.restore() {
                onUnlock()
                message = AlertMessage(title: "Purchase Restored", text: "Premium is unlocked. Thanks for supporting Jotify!", closesPaywall: true)
            } else {
                message = AlertMessage(title: "Nothing to Restore", text: "No Premium purchase was found for this Apple Account.")
            }
        } catch {
            message = AlertMessage(title: "Restore Failed", text: error.localizedDescription)
        }
    }

    static func makeController(reason: Reason = .general, onUnlock: @escaping () -> Void = {}) -> UIViewController {
        let controller = UIHostingController(rootView: PaywallView(reason: reason, onUnlock: onUnlock))
        controller.modalPresentationStyle = .pageSheet
        return controller
    }
}

private struct Feature: View {
    let symbol: String
    let title: String
    let detail: String

    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            Image(systemName: symbol)
                .font(.title2)
                .foregroundStyle(Color(UIColor.brandCoral))
                .frame(width: 36)
                .accessibilityHidden(true)
            VStack(alignment: .leading, spacing: 2) {
                Text(title).font(.headline)
                Text(detail).font(.subheadline).foregroundStyle(.secondary)
            }
        }
        .accessibilityElement(children: .combine)
    }
}

/// A simple one-button alert, shared by the SwiftUI screens.
struct AlertMessage: Identifiable {
    let id = UUID()
    var title: String
    var text: String
    var closesPaywall = false
}
