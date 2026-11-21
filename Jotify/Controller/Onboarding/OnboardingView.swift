//
//  OnboardingView.swift
//  Jotify
//
//  Replaces the Pageboy-based OnboardingController and its page controllers.
//

import SwiftUI

struct OnboardingView: View {

    var onFinish: () -> Void = {}

    @State private var page = 0

    private struct Page {
        let symbol: String?
        let title: String
        let detail: String
    }

    private let pages: [Page] = [
        Page(symbol: nil,
             title: "Welcome to Jotify",
             detail: "The fastest way to jot something down. Open the app and start typing."),
        Page(symbol: "square.and.pencil",
             title: "Write Instantly",
             detail: "Every launch starts on a fresh note. Swipe right to see your saved notes, or add the Jotify widget to your Home Screen."),
        Page(symbol: "arrow.triangle.2.circlepath.icloud.fill",
             title: "Synced and Private",
             detail: "Notes sync in real time across your devices. Sign in with Apple to keep your email private."),
        Page(symbol: "star.circle.fill",
             title: "Go Premium",
             detail: "Unlock reminders, note colors, Face ID lock and more. Or invite 3 friends to get Premium free."),
    ]

    var body: some View {
        VStack(spacing: 0) {
            TabView(selection: $page.animation()) {
                ForEach(pages.indices, id: \.self) { index in
                    pageView(pages[index])
                        .tag(index)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .never))

            // Own page dots: the system ones are white-on-light here, and
            // sit on top of the content instead of above the button.
            HStack(spacing: 8) {
                ForEach(pages.indices, id: \.self) { index in
                    Capsule()
                        .fill(index == page ? Color(UIColor.brandCoral) : Color(UIColor.tertiaryLabel))
                        .frame(width: index == page ? 20 : 8, height: 8)
                }
            }
            .animation(.snappy, value: page)
            .padding(.bottom, 28)
            .accessibilityElement()
            .accessibilityLabel("Page \(page + 1) of \(pages.count)")

            Button {
                UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                if page < pages.count - 1 {
                    withAnimation { page += 1 }
                } else {
                    onFinish()
                }
            } label: {
                Text(page < pages.count - 1 ? "Continue" : "Get Started")
                    .font(.headline)
                    .frame(maxWidth: 420)
                    .padding(.vertical, 6)
            }
            .buttonStyle(.borderedProminent)
            .controlSize(.large)
            .tint(Color(UIColor.brandCoral))
            .padding(.horizontal, 24)
            .padding(.bottom, 16)
        }
        .background(Color(ColorManager.bgColor).ignoresSafeArea())
    }

    private func pageView(_ page: Page) -> some View {
        VStack(spacing: 24) {
            Spacer()
            if let symbol = page.symbol {
                Image(systemName: symbol)
                    .font(.system(size: 88, weight: .regular))
                    .foregroundStyle(Color(UIColor.brandCoral))
                    .frame(height: 140)
                    .accessibilityHidden(true)
            } else {
                Image("BrandIcon")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 140, height: 140)
                    .shadow(color: .black.opacity(0.15), radius: 12, y: 6)
                    .accessibilityHidden(true)
            }
            VStack(spacing: 12) {
                Text(page.title)
                    .font(.largeTitle.bold())
                Text(page.detail)
                    .font(.body)
                    .foregroundStyle(.secondary)
            }
            .multilineTextAlignment(.center)
            .frame(maxWidth: 460)
            Spacer()
        }
        .padding(.horizontal, 32)
    }
}

/// Hosts the onboarding and hands off to sign-up or the app at the end.
final class OnboardingController: UIHostingController<OnboardingView> {

    init() {
        super.init(rootView: OnboardingView())
        rootView = OnboardingView { [weak self] in self?.finish() }
    }

    @MainActor required dynamic init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func finish() {
        if AuthManager().uid.isEmpty {
            //no account yet on this device
            setRootViewController(duration: 0.4, vc: UIHostingController(rootView: SignUpView()))
        } else {
            setRootViewController(duration: 0.4, vc: PageBoyController())
        }
    }
}
