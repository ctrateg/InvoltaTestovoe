//
//  DescriptionViewController.swift
//  InvoltaTestovoe
//
//  Created by Евгений Васильев on 21.04.2023.
//

import UIKit

struct DescriptionModel {
    let index: Int
    let message: String?
    let icon: UIImage?
}

final class DescriptionViewController: UIViewController, UIGestureRecognizerDelegate {

    // MARK: - Constants
    
    private enum Constants {
        static let buttonName = "Удалить"
        static let backButtonTitle = "Назад"
        static let localMessagesName = "LocalMessages"
        static let notificationReload = "ReloadData"
        static let messageFont: CGFloat = 22
        static let dateFont: CGFloat = 12
        static let cornerRadius: CGFloat = 12
    }

    // MARK: - IBOutlets

    @IBOutlet private weak var iconView: UIImageView!
    @IBOutlet private weak var messageLabel: UILabel!
    @IBOutlet private weak var dateLabel: UILabel!
    @IBOutlet private weak var deleteButton: UIButton!

    // MARK: - Properties
    
    var model: DescriptionModel?
    var didDeletetMessage: IntBlock?

    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDefaultState()
        view.becomeFirstResponder()
        setupInitialState()
        
    }

    // MARK: - Actions

    @IBAction private func didSelectDelete(_ sender: Any) {
        guard let index = model?.index else { return }
        didDeletetMessage?(index)
        navigationController?.popViewController(animated: true)
        
    }

}


// MARK: - Private Methods

private extension DescriptionViewController {

    func setupInitialState() {
        configureNavigationBar()
        configureIconView()
        configureLabels()
        configureButton()
        setupAnimation()
        view.backgroundColor = Colors.mintColor
    }

    func setupDefaultState() {
        iconView.isHidden = true
        messageLabel.isHidden = true
        dateLabel.isHidden = true
        deleteButton.isHidden = true

        iconView.alpha = 0
        messageLabel.alpha = 0
        dateLabel.alpha = 0
        deleteButton.alpha = 0
    }

    func setupAnimation() {
        UIView.animate(withDuration: 1) {
            self.iconView.isHidden = false
            self.iconView.alpha = 1
        }
        UIView.animate(withDuration: 1) {
            self.messageLabel.isHidden = false
            self.messageLabel.alpha = 1
        }
        UIView.animate(withDuration: 1) {
            self.dateLabel.isHidden = false
            self.dateLabel.alpha = 1
        }
        UIView.animate(withDuration: 1) {
            self.deleteButton.isHidden = false
            self.deleteButton.alpha = 1
        }
    }

    func configureNavigationBar() {
        navigationController?.setNavigationBarHidden(false, animated: true)
        let backButton = UIBarButtonItem()
        backButton.title = Constants.backButtonTitle
    
        navigationController?.interactivePopGestureRecognizer?.delegate = self
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }

    func configureIconView() {
        iconView.image = model?.icon
        iconView.layer.cornerRadius = iconView.frame.height / 2
    }

    func configureLabels() {
        messageLabel.text = model?.message
        messageLabel.font = .systemFont(ofSize: Constants.messageFont, weight: .heavy)
        messageLabel.numberOfLines = .zero
        messageLabel.textColor = Colors.blackColor

        dateLabel.text = Date().formatted()
        dateLabel.font = .systemFont(ofSize: Constants.dateFont, weight: .heavy)
        dateLabel.textColor = Colors.blackColor
    }

    func configureButton() {
        deleteButton.setTitle(Constants.buttonName, for: .normal)
        deleteButton.tintColor = Colors.lightGrayColor
        deleteButton.backgroundColor = Colors.lightMintColor
        deleteButton.layer.cornerRadius = Constants.cornerRadius
    }

}
