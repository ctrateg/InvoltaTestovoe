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
}

final class MessageViewController: UIViewController {

    // MARK: - Constants
    
    private enum Constants {
        static let titleText = "Тестовое задание"
        static let titleFont: CGFloat = 18
        static let textInFieldPadding: CGFloat = 14
        static let textFieldKeyboardOffset: CGFloat = 35
    }

    // MARK: - IBOutlets

    @IBOutlet private weak var collectionViewButtonSpace: NSLayoutConstraint!
    @IBOutlet private weak var textFieldButtonSpace: NSLayoutConstraint!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var messageField: UITextField!
    @IBOutlet private weak var collectionView: UICollectionView!

    // MARK: - Properties

    var presenter: MessagePresenterDelegate?
    
    // MARK: - Private Properties

    private lazy var collectionDataSource = MessageCollectionViewDataSource(collectionView: collectionView)
    private lazy var collectionDelegate = MessageCollectionViewDelegate()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        addObservers()
        presenter?.viewDidLoad()
    }

}

// MARK: - UITextFieldDelegate

extension MessageViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        textField.text = ""
        return true
    }
    
}

// MARK: - MessageViewDelegate

extension MessageViewController: MessageViewDelegate {

    func setupInitialState() {
        configureMessageCollectionView()
        configureTitle()
        configureTextField()
        hideKeyboardWhenTappedAround()
    }
    
    func updateScreen(messages: [String]?) {
        collectionDataSource.messages = messages
        collectionView.reloadData()
    }
    
    
}

// MARK: - Private Methods

private extension MessageViewController {

    func configureMessageCollectionView() {
        let cellNib = UINib(nibName: "MessageCollectionCell", bundle: nil)
        collectionView.register(cellNib, forCellWithReuseIdentifier: "MessageCollectionCell")
        collectionView.transform = CGAffineTransform.init(rotationAngle: (-(CGFloat)(Double.pi)))
        collectionView.backgroundColor = .systemMint
        collectionView.dataSource = collectionDataSource
        collectionView.delegate = collectionDelegate
    
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.clipsToBounds = false
        collectionView.isPagingEnabled = true

        let layout = UICollectionViewFlowLayout()
        // layout.itemSize = CGSize(width: 300, height: 40)
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width - 16, height: 50)
        layout.minimumInteritemSpacing = 16
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        collectionView.collectionViewLayout = layout
    }

    func configureTitle() {
        titleLabel.text = Constants.titleText
        titleLabel.textAlignment = .center
        titleLabel.font = .systemFont(ofSize: Constants.titleFont, weight: .heavy)
        titleLabel.backgroundColor = .white
    }

    func configureTextField() {
        messageField.delegate = self
        messageField.keyboardType = .default
        messageField.borderStyle = .none
        messageField.backgroundColor = .white
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
                    self.collectionViewButtonSpace.constant += keyboardSize.height - Constants.textFieldKeyboardOffset
                    self.view.layoutIfNeeded()
                }
            }
        }
    }

    func keyboardWillHide(notification: NSNotification) {
        if textFieldButtonSpace.constant != .zero {
            UIView.animate(withDuration: notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double ?? .zero) {
                self.textFieldButtonSpace.constant = .zero
                self.collectionViewButtonSpace.constant = 40
                self.view.layoutIfNeeded()
            }
        }
    }

}
