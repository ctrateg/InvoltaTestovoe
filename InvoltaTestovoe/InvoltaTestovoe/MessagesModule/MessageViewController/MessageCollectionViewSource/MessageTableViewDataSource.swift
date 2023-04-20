//
//  MessageTableViewDataSource.swift
//  InvoltaTestovoe
//
//  Created by Евгений Васильев on 20.04.2023.
//

import UIKit

final class MessageTableViewDataSource: NSObject, UITableViewDataSource {

    // MARK: - Constants
    
    private enum Constants {
        static let messageCell = "MessageTableViewCell"
    }

    // MARK: - Properties

    var messages: [String]? {
        get {
            return workingMessages
        }
        set {
            workingMessages.append(contentsOf: newValue ?? [])
        }
    }

    // MARK: - Private Properties

    private var workingMessages: [String] = []
    private weak var tableView: UITableView?

    // MARK: - Initialization

    init(tableView: UITableView) {
        self.tableView = tableView
    }

    // MARK: - Methods

    func addMessage(text: String) {
        workingMessages = [text] + workingMessages
        tableView?.reloadData()
    }

    // MARK: - UITableViewDataSource

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return workingMessages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let cell = tableView.dequeueReusableCell(withIdentifier: Constants.messageCell, for: indexPath) as? MessageTableViewCell
        else {
            return UITableViewCell()
        }

        cell.configure(message: workingMessages[indexPath.row])
        cell.selectionStyle = .none

        return cell
    }
    

}
