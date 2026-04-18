//
//  KeyboardAccessoryView.swift
//  Jotify
//

import UIKit
import SwiftUI

/// Custom keyboard accessory. On iOS 26 it hosts a SwiftUI bar using the
/// native `.buttonStyle(.glass)` pills — same look Apple's own apps get for
/// free on the new Liquid Glass design. On iOS <26 it falls back to a
/// UIStackView of configured `UIButton`s over a thick material.
///
/// The external API (`setItems`, `setHidden`, `setEnabled`, `setTintColor`,
/// `setImage`) is identical across both paths so callers don't care which
/// rendering is active.
final class KeyboardAccessoryView: UIView {

    struct Item {
        let identifier: String
        let image: UIImage?
        let action: () -> Void
    }

    private static let preferredHeight: CGFloat = 64
    private static let symbolConfiguration = UIImage.SymbolConfiguration(
        pointSize: 22, weight: .regular
    )

    // MARK: - State (shared across both renderings)

    private var items: [Item] = []
    private var hiddenIDs: Set<String> = []
    private var disabledIDs: Set<String> = []
    private var perItemTints: [String: UIColor] = [:]

    // MARK: - iOS 26 (SwiftUI) rendering

    private var hostingController: UIHostingController<AnyView>?

    // MARK: - iOS <26 (UIKit) rendering

    private let stackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .horizontal
        sv.distribution = .equalSpacing
        sv.alignment = .center
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.isLayoutMarginsRelativeArrangement = true
        sv.layoutMargins = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        return sv
    }()
    private var buttons: [String: UIButton] = [:]

    private let useSwiftUI: Bool = {
        if #available(iOS 26.0, *) { return true }
        return false
    }()

    // MARK: - Init

    init() {
        super.init(frame: CGRect(x: 0, y: 0,
                                 width: UIScreen.main.bounds.width,
                                 height: Self.preferredHeight))
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .clear
        tintColor = .label

        if useSwiftUI, #available(iOS 26.0, *) {
            installSwiftUIHost()
        } else {
            installUIKitStack()
        }
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) { fatalError("use init()") }

    override var intrinsicContentSize: CGSize {
        CGSize(width: UIView.noIntrinsicMetric, height: Self.preferredHeight)
    }

    override func sizeThatFits(_ size: CGSize) -> CGSize {
        CGSize(width: size.width, height: Self.preferredHeight)
    }

    // MARK: - Public API

    func setItems(_ items: [Item]) {
        self.items = items
        rebuild()
    }

    func setHidden(_ identifier: String, _ hidden: Bool) {
        if hidden { hiddenIDs.insert(identifier) } else { hiddenIDs.remove(identifier) }
        rebuild()
    }

    func setEnabled(_ identifier: String, _ enabled: Bool) {
        if enabled { disabledIDs.remove(identifier) } else { disabledIDs.insert(identifier) }
        rebuild()
    }

    func setTintColor(_ identifier: String, _ color: UIColor?) {
        if let color = color {
            perItemTints[identifier] = color
        } else {
            perItemTints.removeValue(forKey: identifier)
        }
        rebuild()
    }

    func setImage(_ identifier: String, _ image: UIImage?) {
        guard let index = items.firstIndex(where: { $0.identifier == identifier }) else { return }
        let existing = items[index]
        items[index] = Item(identifier: existing.identifier, image: image, action: existing.action)
        rebuild()
    }

    // MARK: - Rebuild dispatch

    private func rebuild() {
        if useSwiftUI, #available(iOS 26.0, *) {
            rebuildSwiftUI()
        } else {
            rebuildUIKit()
        }
    }

    // MARK: - SwiftUI path (iOS 26+)

    @available(iOS 26.0, *)
    private func installSwiftUIHost() {
        let host = UIHostingController(rootView: AnyView(EmptyView()))
        host.view.backgroundColor = .clear
        host.view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(host.view)
        NSLayoutConstraint.activate([
            host.view.leadingAnchor.constraint(equalTo: leadingAnchor),
            host.view.trailingAnchor.constraint(equalTo: trailingAnchor),
            host.view.topAnchor.constraint(equalTo: topAnchor),
            host.view.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        hostingController = host
    }

    @available(iOS 26.0, *)
    private func rebuildSwiftUI() {
        let hidden = hiddenIDs
        let disabled = disabledIDs
        let tints = perItemTints
        let baseTint = self.tintColor

        let bar = KeyboardGlassBar(
            buttons: items.map { item in
                KeyboardGlassBar.Button(
                    id: item.identifier,
                    image: item.image,
                    action: item.action,
                    isHidden: hidden.contains(item.identifier),
                    isDisabled: disabled.contains(item.identifier),
                    tint: tints[item.identifier].map(Color.init) ?? baseTint.map(Color.init)
                )
            }
        )
        hostingController?.rootView = AnyView(bar)
    }

    // MARK: - UIKit path (iOS <26 fallback)

    private func installUIKitStack() {
        let blur = UIVisualEffectView(effect: UIBlurEffect(style: .systemThickMaterial))
        blur.translatesAutoresizingMaskIntoConstraints = false
        addSubview(blur)
        addSubview(stackView)
        NSLayoutConstraint.activate([
            blur.leadingAnchor.constraint(equalTo: leadingAnchor),
            blur.trailingAnchor.constraint(equalTo: trailingAnchor),
            blur.topAnchor.constraint(equalTo: topAnchor),
            blur.bottomAnchor.constraint(equalTo: bottomAnchor),

            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }

    private func rebuildUIKit() {
        stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        buttons.removeAll()
        for item in items {
            let button = makeButton(for: item)
            button.isHidden = hiddenIDs.contains(item.identifier)
            button.isEnabled = !disabledIDs.contains(item.identifier)
            if let tint = perItemTints[item.identifier] {
                button.tintColor = tint
            }
            buttons[item.identifier] = button
            stackView.addArrangedSubview(button)
        }
    }

    private func makeButton(for item: Item) -> UIButton {
        var config = UIButton.Configuration.plain()
        config.image = item.image?.withConfiguration(Self.symbolConfiguration)
        config.cornerStyle = .capsule
        config.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 12,
                                                       bottom: 8, trailing: 12)
        let action = UIAction { _ in item.action() }
        return UIButton(configuration: config, primaryAction: action)
    }
}

// MARK: - SwiftUI bar (iOS 26+)

@available(iOS 26.0, *)
private struct KeyboardGlassBar: View {

    struct Button: Identifiable {
        let id: String
        let image: UIImage?
        let action: () -> Void
        var isHidden: Bool = false
        var isDisabled: Bool = false
        var tint: Color?
    }

    let buttons: [Button]

    var body: some View {
        HStack(spacing: 16) {
            ForEach(buttons) { button in
                if !button.isHidden {
                    SwiftUI.Button {
                        button.action()
                    } label: {
                        if let image = button.image {
                            Image(uiImage: image)
                                .renderingMode(.template)
                        }
                    }
                    .disabled(button.isDisabled)
                    .tint(button.tint ?? .primary)
                }
            }
        }
        .buttonStyle(.glass)
        .buttonBorderShape(.circle)
        .controlSize(.large)
        .font(.title3)
        .frame(maxWidth: .infinity)
        .padding(.vertical, 10)
    }
}
