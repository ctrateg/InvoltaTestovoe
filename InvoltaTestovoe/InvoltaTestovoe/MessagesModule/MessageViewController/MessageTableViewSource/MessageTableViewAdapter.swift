//
//  MessageCollectionViewAdapter.swift
//  InvoltaTestovoe
//
//  Created by Евгений Васильев on 20.04.2023.
//

import UIKit

protocol MessageTableViewAdapterDelegate {
    var didSelectItem: ModelBlock<DescriptionModel>? { get set }
    var didLoadMore: IntBlock? { get set }
    func configure()
    func updateMessage(with messages: [String]?, icons: [UIImage]?)
    func addMessage(text: String)
    func clearTable()
    func delete(at index: Int)
}

final class MessageTableViewAdapter: MessageTableViewAdapterDelegate {

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
    private var indexPaths: [IndexPath] = []
    private let tableViewDataSource: MessageDataSource
    private let tableViewDelegate: MessageViewSelectableDelegate
    private var messages: [String] = []

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

    func updateMessage(with messages: [String]?, icons: [UIImage]?) {
        guard
            let messages = messages,
            let icons = icons else {
            return
        }

        var paths: [IndexPath] = []
        
        if indexPaths.count != messages.count {
            for index in (indexPaths.count)...(messages.count - 1) {
                paths.append(IndexPath(row: index, section: 0))
                indexPaths.append(IndexPath(row: index, section: 0))
            }
        }
        
        self.messages = messages
        tableViewDataSource.messages = messages
        tableViewDataSource.icons = icons

        tableView.beginUpdates()
        tableView.insertRows(at: paths, with: .left)
        tableView.endUpdates()
    }

    func addMessage(text: String) {
        tableViewDataSource.addMessage(text: text)
        indexPaths.append(IndexPath(row: indexPaths.count, section: .zero))
        tableView.beginUpdates()
        tableView.insertRows(at: [IndexPath(row: .zero, section: .zero)], with: .left)
        tableView.endUpdates()
    }

    func clearTable() {
        tableViewDataSource.clearData()
    }

    func delete(at index: Int) {
        indexPaths.remove(at: index)
        messages.remove(at: index)
        tableView.beginUpdates()
        tableView.deleteRows(at: [IndexPath(row: index, section: 0)], with: .right)
        tableViewDataSource.messages = messages
        tableView.endUpdates()
    }

}

// MARK: - Private Properties

private extension MessageTableViewAdapter {

    func configureTable() {
        tableView.register(UINib.init(nibName: Constants.cellName, bundle: nil), forCellReuseIdentifier: Constants.cellName)
        tableView.backgroundColor = Colors.mintColor
        tableView.delegate = tableViewDelegate
        tableView.dataSource = tableViewDataSource
        tableView.separatorStyle = .none
        tableView.transform = CGAffineTransform.init(rotationAngle: (-(CGFloat)(Double.pi)))
    }

    func configureActions() {
        tableViewDelegate.didSelectItem = didSelectItem
        tableViewDelegate.didLoadMore = didLoadMore
    }

}
