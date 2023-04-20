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

    // MARK: - IBOutlets

    @IBOutlet private weak var messageCollectionView: UICollectionView!

    // MARK: - Properties

    var presenter: MessagePresenterDelegate?
    
    // MARK: - Private Properties

    private lazy var collectionDataSource = MessageCollectionViewDataSource(collectionView: messageCollectionView)
    private var collectionDelegate = MessageCollectionViewDelegate()
    private var collectionLayout = MessageCollectionViewLayout()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.viewDidLoad()
    }

}

// MARK: - MessageViewDelegate

extension MessageViewController: MessageViewDelegate {

    func setupInitialState() {
        messageCollectionView.backgroundColor = .lightGray
    }
    
    func updateScreen(messages: [String]?) {
        collectionDataSource.messages = messages
        messageCollectionView.reloadData()
    }
    
    
}

// MARK: - Private Methods

private extension MessageViewController {

    func configureMessageCollectionView() {
        messageCollectionView.dataSource = collectionDataSource
        messageCollectionView.delegate = collectionDelegate
        messageCollectionView.collectionViewLayout = collectionLayout
        messageCollectionView.showsVerticalScrollIndicator = false
    }

}
