//
//  MessageCollectionViewAdapter.swift
//  InvoltaTestovoe
//
//  Created by Евгений Васильев on 20.04.2023.
//

import UIKit

final class MessageTableViewAdapter {

    // MARK: - Constants
    
    private enum Constants {
        static let contentEdgeInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        static let minimumInteritemSpacing: CGFloat = 16
        static let cellName = "MessageTableViewCell"
    }

    // MARK: - Properties

    var didSelectItem: ModelBlock<DescriptionModel>?
    var didLoadMore: IntBlock?

    // MARK: - Private Properties

    private var tableView: UITableView
    private let tableViewDataSource: MessageDataSource
    private let tableViewDelegate: MessageViewSelectableDelegate

    // MARK: - Initialization

    init(tableView: UITableView) {
        self.tableView = tableView
        self.tableViewDataSource = MessageTableViewDataSource()
        self.tableViewDelegate = MessageTableViewDelegate()
    }

    // MARK: - Methods

    func configure() {
        configureTable()
        configureActions()
    }

    func updateMessage(with message: [String]?) {
        tableViewDataSource.messages = message
    }

    func addMessage(text: String) {
        tableViewDataSource.addMessage(text: text)
    }

    func clearTable() {
        tableViewDataSource.clearData()
    }

}

// MARK: - Private Properties

private extension MessageTableViewAdapter {

    func configureTable() {
        tableView.register(UINib.init(nibName: Constants.cellName, bundle: nil), forCellReuseIdentifier: Constants.cellName)
        tableView.backgroundColor = .systemMint
        tableView.delegate = tableViewDelegate
        tableView.dataSource = tableViewDataSource
        tableView.separatorStyle = .none
        tableView.transform = CGAffineTransform.init(rotationAngle: (-(CGFloat)(Double.pi)))
    }

    func configureActions() {
        tableViewDataSource.didReloadTable = { [weak self] in
            self?.tableView.reloadData()
        }

        tableViewDelegate.didSelectItem = didSelectItem
        tableViewDelegate.didLoadMore = didLoadMore
    }

}
