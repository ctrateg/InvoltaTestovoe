//
//  MessageTableViewDataSource.swift
//  InvoltaTestovoe
//
//  Created by Евгений Васильев on 20.04.2023.
//

import UIKit

protocol MessageDataSource: UITableViewDataSource {
    var messages: [String]? { get set }
    var icons: [UIImage]? { get set }
    func addMessage(text: String)
    func clearData()
}

final class MessageTableViewDataSource: NSObject, MessageDataSource {

    // MARK: - Constants
    
    private enum Constants {
        static let messageCell = "MessageTableViewCell"
    }

    // MARK: - Properties

    var messages: [String]?
    var icons: [UIImage]?

    // MARK: - Methods

    func addMessage(text: String) {
        messages?.insert(text, at: 0)
    }

    func clearData() {
        messages = []
    }

    // MARK: - UITableViewDataSource

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let cell = tableView.dequeueReusableCell(withIdentifier: Constants.messageCell, for: indexPath) as? MessageTableViewCell
        else {
            return UITableViewCell()
        }
        if
            let messages = self.messages,
            let icons = self.icons
        {
            cell.configure(message: messages[indexPath.row], icon: icons[Int.random(in: 0...19)])
            cell.selectionStyle = .none
        }

        return cell
    }

}
