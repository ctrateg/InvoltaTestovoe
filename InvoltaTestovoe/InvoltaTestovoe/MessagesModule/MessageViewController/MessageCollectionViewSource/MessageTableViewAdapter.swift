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

    var didSelectItem: ((DescriptionModel) -> ())?

    // MARK: - Private Properties

    private var tableView: UITableView
    private let tableViewDataSource: MessageDataSource
    private let tableViewDelegate: MessageViewSelectableDelegate

    // MARK: - Initialization

    init(tableView: UITableView) {
        self.tableView = tableView
        self.tableViewDataSource = MessageTableViewDataSource(tableView: tableView)
        self.tableViewDelegate = MessageTableViewDelegate()
    }

    // MARK: - Methods

    func configure() {
        tableView.register(UINib.init(nibName: Constants.cellName, bundle: nil), forCellReuseIdentifier: Constants.cellName)
        tableView.backgroundColor = .systemMint
        tableView.delegate = tableViewDelegate
        tableView.dataSource = tableViewDataSource
        tableView.separatorStyle = .none
        tableView.transform = CGAffineTransform.init(rotationAngle: (-(CGFloat)(Double.pi)))
        
        tableViewDelegate.didSelectItem = didSelectItem
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

// MARK: - Private Methods

private extension MessageTableViewAdapter {

}
