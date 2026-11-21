//
//  GradientAnimator.swift
//  Jotify
//
//  Created by Harrison Leath on 6/20/21.
//

import UIKit

@objc
public enum GradientPoints: Int {
    case left
    case top
    case right
    case bottom
    case topLeft
    case topRight
    case bottomLeft
    case bottomRight

    var point: CGPoint {
        switch self {
        case .left: return CGPoint(x: 0.0, y: 0.5)
        case .top: return CGPoint(x: 0.5, y: 0.0)
        case .right: return CGPoint(x: 1.0, y: 0.5)
        case .bottom: return CGPoint(x: 0.5, y: 1.0)
        case .topLeft: return CGPoint(x: 0.0, y: 0.0)
        case .topRight: return CGPoint(x: 1.0, y: 0.0)
        case .bottomLeft: return CGPoint(x: 0.0, y: 1.0)
        case .bottomRight: return CGPoint(x: 1.0, y: 1.0)
        }
    }
}

/// A full-bleed view that slowly cycles a two-stop gradient through a list
/// of colors, looping forever.
///
/// Each step animates from whatever is on screen *now* (the presentation
/// layer) to the next pair, so changing theme, backgrounding and resuming
/// all blend instead of snapping.
open class GradientAnimator: UIView {
    private let gradient = CAGradientLayer()
    private var step = 0
    private(set) var colors: [UIColor]
    private let stepDuration: TimeInterval
    /// Duration of the blend when `setColors(_:animated:)` switches theme.
    private let themeChangeDuration: TimeInterval = 0.6
    private var observers: [NSObjectProtocol] = []
    /// Set while fading out in `removeGradient`, so a `setGradient` call in
    /// the meantime creates a fresh view instead of reviving this one.
    var isBeingRemoved = false

    private static let animationKey = "colorChange"

    public init(frame: CGRect, theme: GradientThemes, startPoint: GradientPoints, endPoint: GradientPoints, stepDuration: TimeInterval) {
        self.colors = theme.colors()
        self.stepDuration = stepDuration
        super.init(frame: frame)

        autoresizingMask = [.flexibleWidth, .flexibleHeight]
        isUserInteractionEnabled = false

        gradient.startPoint = startPoint.point
        gradient.endPoint = endPoint.point
        gradient.frame = bounds
        gradient.colors = colorPair(at: 0)
        layer.addSublayer(gradient)

        // Core Animation drops running animations when the app is
        // backgrounded. Freeze the current colors on the way out so the
        // switcher snapshot and the first frame back match, then resume from
        // there. Weak captures so the observers don't keep this view alive.
        let center = NotificationCenter.default
        observers.append(center.addObserver(forName: UIApplication.willResignActiveNotification, object: nil, queue: .main) { [weak self] _ in
            self?.freeze()
        })
        observers.append(center.addObserver(forName: UIApplication.didBecomeActiveNotification, object: nil, queue: .main) { [weak self] _ in
            self?.resume()
        })
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        observers.forEach(NotificationCenter.default.removeObserver)
    }

    override open func layoutSubviews() {
        super.layoutSubviews()
        // Sublayers implicitly animate frame changes; keep the gradient glued
        // to the view during rotation and split-view resizes.
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        gradient.frame = bounds
        CATransaction.commit()
    }

    override open func didMoveToWindow() {
        super.didMoveToWindow()
        if window == nil {
            freeze()
        } else {
            resume()
        }
    }

    // MARK: - Public API

    /// Starts cycling from the current colors.
    public func startAnimate() {
        resume()
    }

    /// Switches to a new set of colors, blending from what is currently on
    /// screen rather than cutting.
    public func setColors(_ newColors: [UIColor], animated: Bool) {
        guard !newColors.isEmpty else { return }
        colors = newColors
        step = 0
        if animated && window != nil {
            animate(to: colorPair(at: step), duration: themeChangeDuration)
        } else {
            freeze()
            gradient.colors = colorPair(at: step)
            resume()
        }
    }

    // MARK: - Cycling

    private func colorPair(at index: Int) -> [CGColor] {
        guard !colors.isEmpty else { return [] }
        return [colors[index % colors.count].cgColor,
                colors[(index + 1) % colors.count].cgColor]
    }

    private func advance() {
        step += 1
        animate(to: colorPair(at: step), duration: stepDuration)
    }

    /// Animates from the on-screen colors to `target`. The model value is set
    /// up front, so there's no `fillMode`/`isRemovedOnCompletion` hack and an
    /// interrupted animation leaves the layer at a real value.
    private func animate(to target: [CGColor], duration: TimeInterval) {
        let current = gradient.presentation()?.colors ?? gradient.colors
        gradient.removeAnimation(forKey: Self.animationKey)

        let animation = CABasicAnimation(keyPath: "colors")
        animation.fromValue = current
        animation.toValue = target
        animation.duration = duration
        animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        animation.delegate = self

        CATransaction.begin()
        CATransaction.setDisableActions(true)
        gradient.colors = target
        CATransaction.commit()
        gradient.add(animation, forKey: Self.animationKey)
    }

    /// Pins the layer at its on-screen colors and stops cycling.
    private func freeze() {
        guard gradient.animation(forKey: Self.animationKey) != nil else { return }
        let current = gradient.presentation()?.colors
        gradient.removeAnimation(forKey: Self.animationKey)
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        if let current { gradient.colors = current }
        CATransaction.commit()
    }

    /// Continues toward the current step's colors from wherever we froze.
    private func resume() {
        guard window != nil,
              UIApplication.shared.applicationState != .background,
              gradient.animation(forKey: Self.animationKey) == nil else { return }
        animate(to: colorPair(at: step), duration: stepDuration)
    }
}

extension GradientAnimator: CAAnimationDelegate {
    public func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        // `finished` is false when we replaced or removed the animation
        // ourselves (theme change, freeze); only chain on natural completion.
        if flag {
            advance()
        }
    }
}
