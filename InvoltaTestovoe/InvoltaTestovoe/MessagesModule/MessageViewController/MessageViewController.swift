//
//  MessageViewController.swift
//  InvoltaTestovoe
//
//  Created by Евгений Васильев on 20.04.2023.
//

import UIKit

protocol MessageViewDelegate {
    /// Method for setup initial state of view
    func setupInitialState()
    /// Method for update screen with data
    func updateScreen(messages: [String]?)
    /// Setup loading state
    func loadingState(_ isLoading: Bool)
    /// Setup error state
    func openErrorScreen()
}

final class MessageViewController: UIViewController {

    // MARK: - Constants
    
    private enum Constants {
        static let titleText = "Тестовое задание"
        static let placeholderText = "Сообщение"
        static let notificationReload = "ReloadData"
        static let titleFont: CGFloat = 18
        static let textInFieldPadding: CGFloat = 20
        static let textFieldKeyboardOffset: CGFloat = 35
    }

    // MARK: - IBOutlets

    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet private weak var textFieldButtonSpace: NSLayoutConstraint!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var messageField: UITextField!
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var tableViewButtonSpace: NSLayoutConstraint!

    // MARK: - Properties

    var presenter: MessagePresenterDelegate?

    // MARK: - Private Properties

    private lazy var adapter = MessageTableViewAdapter(tableView: tableView)

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        addObservers()
        presenter?.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }

}

// MARK: - UITextFieldDelegate

extension MessageViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if
            let text = textField.text,
            !text.isEmpty
        {
            adapter.addMessage(text: text)
            presenter?.addNewMessage(message: text)
            tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
        }
        textField.text = ""
        return true
    }
    
}

// MARK: - MessageViewDelegate

extension MessageViewController: MessageViewDelegate {

    func setupInitialState() {
        configureTableView()
        configureTitle()
        configureTextField()
        hideKeyboardWhenTappedAround()
    }
    
    func updateScreen(messages: [String]?) {
        adapter.clearTable()
        if let messages = messages {
            adapter.updateMessage(with: messages)
            tableView.reloadData()
        }
    }

    func loadingState(_ isLoading: Bool) {
        isLoading ? activityIndicator.startAnimating() : activityIndicator.stopAnimating()
        activityIndicator.isHidden = !isLoading
        messageField.isEnabled = !isLoading
    }

    func openErrorScreen() {
        let viewController = ErrorViewController()
        viewController.modalPresentationStyle = .fullScreen
        viewController.didTappedRetry = { [weak self] in
            self?.presenter?.setupData()
        }
        navigationController?.pushViewController(viewController, animated: true)
    }

}

// MARK: - Private Methods

private extension MessageViewController {

    func configureTableView() {
        let deleteCompletion: IntBlock = { [weak self] index in
            self?.presenter?.deleteMessage(at: index)
        }
        adapter.didLoadMore = { [weak self] offset in
            self?.presenter?.updateData(offset: String(offset))
        }
        adapter.didSelectItem = { [weak self] model in
            let viewController = DescriptionViewController()
            viewController.modalPresentationStyle = .fullScreen
            viewController.model = model
            viewController.didDeletetMessage = deleteCompletion
            self?.navigationController?.pushViewController(viewController, animated: true)
        }
        adapter.configure()
    }

    func configureTitle() {
        titleLabel.text = Constants.titleText
        titleLabel.textAlignment = .center
        titleLabel.font = .systemFont(ofSize: Constants.titleFont, weight: .heavy)
        titleLabel.backgroundColor = .white
    }

    func configureTextField() {
        messageField.placeholder = Constants.placeholderText
        messageField.delegate = self
        messageField.keyboardType = .default
        messageField.borderStyle = .none
        messageField.backgroundColor = .white
        messageField.returnKeyType = .send
        messageField.setLeftPaddingPoints(Constants.textInFieldPadding)
        messageField.setRightPaddingPoints(Constants.textInFieldPadding)
    }

    func addObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

}

// MARK: - Actions

@objc
private extension MessageViewController {

    func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if self.textFieldButtonSpace.constant == .zero {
                UIView.animate(withDuration: notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double ?? .zero) {
                    self.textFieldButtonSpace.constant += keyboardSize.height - Constants.textFieldKeyboardOffset
                    self.tableViewButtonSpace.constant += keyboardSize.height - Constants.textFieldKeyboardOffset
                    self.view.layoutIfNeeded()
                }
            }
        }
    }

    func keyboardWillHide(notification: NSNotification) {
        if textFieldButtonSpace.constant != .zero {
            UIView.animate(withDuration: notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double ?? .zero) {
                self.textFieldButtonSpace.constant = .zero
                self.tableViewButtonSpace.constant = 40
                self.view.layoutIfNeeded()
            }
        }
    }

}
