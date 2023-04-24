//
//  ErrorViewController.swift
//  InvoltaTestovoe
//
//  Created by Евгений Васильев on 23.04.2023.
//

import UIKit

final class ErrorViewController: UIViewController {

    // MARK: - Constants
    
    private enum Constants {
        static let titleFont: CGFloat = 22
        static let cornerRadius: CGFloat = 12
        static let title = "Нет доступа к интернету или сервер недоступен"
        static let buttonTitle = "Повторить"
    }

    // MARK: - IBOutlets

    @IBOutlet weak var retryButton: UIButton!
    @IBOutlet private weak var titleLabel: UILabel!

    // MARK: - Properties

    var didTappedRetry: EmptyBlock?

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupInitialState()
    }

    // MARK: - Actions

    @IBAction func tapRertyButton(_ sender: Any) {
        didTappedRetry?()
        navigationController?.popViewController(animated: true)
    }

}

// MARK: - Private Properties

private extension ErrorViewController {

    func setupInitialState() {
        configureView()
        configureTitle()
        configureRetryButton()
    }

    func configureView() {
        navigationController?.navigationBar.isHidden = true
        view.backgroundColor = Colors.mintColor
    }

    func configureTitle() {
        titleLabel.text = Constants.title
        titleLabel.font = .systemFont(ofSize: Constants.titleFont, weight: .heavy)
        titleLabel.textColor = Colors.redColor
        titleLabel.numberOfLines = .zero
    }

    func configureRetryButton() {
        retryButton.setTitle(Constants.buttonTitle, for: .normal)
        retryButton.tintColor = Colors.whiteColor
        retryButton.backgroundColor = Colors.lightGrayColor
        retryButton.layer.cornerRadius = Constants.cornerRadius
    }

}
