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

    var didSelectItem: ((String) -> Void)?

    // MARK: - Private Properties

    private var tableView: UITableView
    private lazy var tableViewDataSource = MessageTableViewDataSource(tableView: tableView)
    private lazy var tableViewDelegate = MessageTableViewDelegate()

    // MARK: - Initialization

    init(tableView: UITableView) {
        self.tableView = tableView
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

}

// MARK: - Private Methods

private extension MessageTableViewAdapter {

}
