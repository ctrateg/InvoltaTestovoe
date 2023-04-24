//
//  SnackMessanger.swift
//  InvoltaTestovoe
//
//  Created by Евгений Васильев on 24.04.2023.
//

import UIKit

public protocol SnackMessengerDelegate: AnyObject {
    func messageWillShow()
    func messageWillHide()
    func messageDidShow()
    func messageDidHide()
}

/// Shows some text message on top of the screen. Simple customize with colors, fonts, padding offsets.
/// Support tap and pan gestures to force closing. Also supports duplicates and "message train" protection.
public final class SnackMessenger {

    // MARK: - Enums

    public enum SnackMessengerStyle {
        case normal
        case normalWithButton(title: String, _ callback: ()-> Void)
        case error
    }

    // MARK: - Constants

    private enum Constants {
        enum Fonts {
            static let main = UIFont.systemFont(ofSize: 12, weight: .regular)
            static let button = UIFont.systemFont(ofSize: 14, weight: .medium)
        }
        enum Color {
            static let text = Colors.mintColor
            static let highlightedButton = Colors.mintColor?.withAlphaComponent(0.6)
            static let normalBackground = Colors.lightGrayColor
            static let errorBackground = Colors.redColor
        }
        enum Offsets {
            static let top: CGFloat = 33.0
            static let bottomWithButton: CGFloat = 9.0
            static let xTop: CGFloat = 56.0
            static let bottom: CGFloat = 18.0
        }
        enum Durations {
            static let animation: TimeInterval = 0.3
            static let snackVisible: TimeInterval = 3
            static let ignoreMessages = 3
            static let previousMessage = 3
        }
        static let defaultTextPaddings: CGFloat = 16.0
    }

    // MARK: - Properties

    public weak var delegate: SnackMessengerDelegate?
    public static var shared = SnackMessenger()

    /// setup text alignment
    public var textAlignment: NSTextAlignment? {
        didSet {
            label.textAlignment = textAlignment ?? .center
        }
    }

    // MARK: - Private Properties

    /// returns true if snack-message is showing
    private(set) var isShowing = false
    /// background view is colored parent view
    private var backgroundView = UIView()
    /// content view contains label and offset from edges with paddings
    private var contentView = UIView()
    /// uilabel contains message text
    private var label = UILabel()
    /// offset from top line of the screen
    private var backgroundViewTopConstraint: NSLayoutConstraint?
    private var button = UIButton()
    /// contains last message start time
    private var snackStartedAt = Date(timeIntervalSince1970: 0)
    /// timer uses for autoremove previous message banner after constant time
    private var messageTimer = Timer()
    /// contains time to remove previous message text
    private var messageTimeout = Constants.Durations.previousMessage
    /// contains true state if snack invalidation forced by user action
    private var forceSnackTimeout = false
    /// contains current message (that will/already show)
    private var message: String?
    /// contains previous message for comparing current message. This needs to avoid duplicate message errors
    private var prevMessage: String?
    /// configure appearance of snack view
    private var style: SnackMessengerStyle = .error
    /// contains worker for current snack message, that will close snack message.
    private var worker: DispatchWorkItem?
    /// The app's key window.
    private let keyWindow = UIApplication.firstKeyWindow
    /// contains top offset depending on phone version
    private var topOffset: CGFloat {
        return Constants.Offsets.xTop
    }
    /// contains bottom offset depending on the chosen style
    private var bottomOffset: CGFloat {
        guard case .normalWithButton = style else {
            return Constants.Offsets.bottom
        }
        return Constants.Offsets.bottomWithButton
    }
    /// property process input message and manage timer
    private var previousMessage: String? {
        set(message) {
            setPreviousMessage(message)
        }
        get {
            return prevMessage
        }
    }

    // MARK: - Public Methods

    public func show(message: String?, style: SnackMessengerStyle = .error, autocomplete: Bool = true) {
        if !canShowMessage(message: message) {
            return
        }

        self.message = message
        self.style = style

        if isShowing {
            // doesn't reach if defaultSnackTimeout == defaultSnackDuration
            hideAnimation { [weak self] in
                self?.configureMessenger()
                self?.showAnimation()
                self?.setupAutocomplete(mustComplete: autocomplete)
                self?.previousMessage = message
            }
        } else {
            resetStateIfNeeded()
            configureMessenger()
            showAnimation()
            setupAutocomplete(mustComplete: autocomplete)
            previousMessage = message
        }
    }

    public func hide() {
        forceClose()
    }

}

// MARK: - Actions

private extension SnackMessenger {

    @objc
    func close() {
        forceClose()
    }

    @objc
    func buttonTapped() {
        forceClose()
        guard case .normalWithButton(_, let callback) = style else {
            return
        }
        callback()
    }

}

// MARK: - Configuration

private extension SnackMessenger {

    func configureMessenger() {
        configureBackgroundView()
        configureContentView()
        configureLabel()
        configureStyle()
        setupInitialState()
    }

    func configureBackgroundView() {
        guard let keyWindow = keyWindow else { return }

        let backgroundView = UIView()
        backgroundView.translatesAutoresizingMaskIntoConstraints = false

        let gesture = UISwipeGestureRecognizer(target: self, action: #selector(self.close))
        gesture.direction = .up
        gesture.numberOfTouchesRequired = 1
        backgroundView.addGestureRecognizer(gesture)

        keyWindow.addSubview(backgroundView)
        self.backgroundView = backgroundView

        configureBackgroundLayout()
    }

    func configureContentView() {
        contentView.translatesAutoresizingMaskIntoConstraints = false
        backgroundView.addSubview(contentView)

        configureContentLayout()
    }

    func configureLabel() {
        label.text = message
        label.textAlignment = textAlignment ?? .center
        label.textColor = Constants.Color.text

        label.numberOfLines = 0
        label.font = Constants.Fonts.main

        label.sizeToFit()
        label.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(label)
        configureLabelLayout()
    }

    func configureStyle() {
        switch style {
        case .normal:
            backgroundView.backgroundColor = Constants.Color.normalBackground
            textAlignment = .center
        case .error:
            backgroundView.backgroundColor = Constants.Color.errorBackground
            textAlignment = .center
        case .normalWithButton(let title, _):
            backgroundView.backgroundColor = Constants.Color.normalBackground
            configureButton(with: title)
        }
    }

    func setupInitialState() {
        guard let keyWindow = keyWindow else { return }
        keyWindow.layoutSubviews()

        backgroundViewTopConstraint?.constant = -backgroundView.frame.height

        keyWindow.layoutIfNeeded()
        keyWindow.setNeedsUpdateConstraints()
        keyWindow.updateConstraints()
        keyWindow.layoutSubviews()

        contentView.layoutIfNeeded()
    }

    func configureButton(with title: String) {
        textAlignment = .left

        button.setTitle(title, for: .normal)
        button.titleLabel?.font = Constants.Fonts.button
        button.setTitleColor(Constants.Color.highlightedButton, for: .highlighted)

        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)

        contentView.addSubview(button)

        configureButtonLayout()
    }

    func setupAutocomplete(mustComplete: Bool) {
        if mustComplete {
            let worker = DispatchWorkItem { [weak self] in
                self?.hideAnimation { [weak self] in
                    self?.resetStateIfNeeded()
                }
            }

            DispatchQueue.main.asyncAfter(deadline: .now() + Constants.Durations.snackVisible, execute: worker)
            self.worker = worker
        }
    }

}

// MARK: - Layout configuration

private extension SnackMessenger {

    func configureBackgroundLayout() {
        guard let keyWindow = keyWindow else { return }

        let topConstraint = backgroundView.topAnchor.constraint(equalTo: keyWindow.topAnchor, constant: 0)
        let leftConstraint = backgroundView.trailingAnchor.constraint(equalTo: keyWindow.trailingAnchor, constant: 0)
        let rightConstraint = backgroundView.leadingAnchor.constraint(equalTo: keyWindow.leadingAnchor, constant: 0)

        NSLayoutConstraint.activate([topConstraint, leftConstraint, rightConstraint])
        backgroundViewTopConstraint = topConstraint
    }

    func configureContentLayout() {
        let leftConstraint = contentView.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor, constant: 0)
        let rightConstraint = contentView.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor, constant: 0)
        let topConstraint = contentView.topAnchor.constraint(equalTo: backgroundView.topAnchor, constant: topOffset)
        let bottomConstraint = contentView.bottomAnchor.constraint(equalTo: backgroundView.bottomAnchor, constant: -bottomOffset)

        NSLayoutConstraint.activate([leftConstraint, rightConstraint, topConstraint, bottomConstraint])
    }

    func configureLabelLayout() {
        let rightConstraint = label.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -Constants.defaultTextPaddings)
        let leftConstraint = label.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: Constants.defaultTextPaddings)
        let topConstraint = label.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0)
        let bottomConstraint = label.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0)

        bottomConstraint.priority = .defaultLow
        NSLayoutConstraint.activate([leftConstraint, rightConstraint, topConstraint, bottomConstraint])
    }

    func configureButtonLayout() {
        let rightConstraint = button.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -Constants.defaultTextPaddings)
        let topConstraint = button.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 0)
        let bottomConstraint = button.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0)

        NSLayoutConstraint.activate([rightConstraint, topConstraint, bottomConstraint])
    }

}

// MARK: - Animations

private extension SnackMessenger {

    func showAnimation() {
        delegate?.messageWillShow()
        isShowing = true

        let animations: () -> Void = {
            self.backgroundViewTopConstraint?.constant = 0
            self.keyWindow?.layoutIfNeeded()
        }

        let completion: (Bool) -> Void = { [weak self] _ in
            self?.delegate?.messageDidShow()
        }
        UIView.animate(withDuration: Constants.Durations.animation, animations: animations, completion: completion)
    }

    func hideAnimation(_ callback: (() -> Void)? = nil) {
        guard isShowing else { return }

        delegate?.messageWillHide()
        isShowing = false

        let animations: () -> Void = {
            self.backgroundViewTopConstraint?.constant = -self.backgroundView.frame.height
            self.keyWindow?.layoutIfNeeded()
        }

        let completion: (Bool) -> Void = { [weak self] _ in
            self?.delegate?.messageDidHide()
            self?.resetStateIfNeeded()
            callback?()
        }

        UIView.animate(withDuration: Constants.Durations.animation, animations: animations, completion: completion)
    }

}

// MARK: - Private Methods

private extension SnackMessenger {

    func resetStateIfNeeded() {
        guard let topConstraint = backgroundViewTopConstraint, let keyWindow = keyWindow else {
            return
        }

        keyWindow.willRemoveSubview(backgroundView)
        topConstraint.isActive = false
        backgroundView.removeFromSuperview()

        self.backgroundViewTopConstraint = nil
        self.backgroundView = UIView()

        self.label = UILabel()
        self.button = UIButton()

        self.previousMessage = nil
        self.isShowing = false
        self.contentView = UIView()

        self.worker?.cancel()
        self.worker = nil
    }

    func forceClose() {
        hideAnimation { [weak self] in
            self?.worker?.cancel()
            self?.forceSnackTimeout = true
            self?.previousMessage = nil
        }
    }

    func resetSnackTimeout() {
        snackStartedAt = Date()
    }

    func canShowMessage(message: String?) -> Bool {
        // if message similar as previous
        if previousMessage == message {
            return false
        }

        // if message push earlier then delay time is out
        // delay time is time between messages, can break by user action
        if forceSnackTimeout || abs(Int(snackStartedAt.timeIntervalSinceNow)) >= Constants.Durations.ignoreMessages {
            forceSnackTimeout = false
            resetSnackTimeout()
            return true
        } else {
            return false
        }
    }

    func setPreviousMessage(_ message: String?) {
        self.prevMessage = message
        guard message != nil else {
            messageTimer.invalidate()
            return
        }

        messageTimer.invalidate()
        messageTimeout = Constants.Durations.previousMessage
        messageTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { _ in
            self.messageTimeout -= 1

            if self.messageTimeout == 0 {
                self.prevMessage = nil
                self.messageTimer.invalidate()
            }
        })
    }

}

