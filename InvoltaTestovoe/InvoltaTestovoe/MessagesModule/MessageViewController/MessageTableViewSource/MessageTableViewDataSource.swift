//
//  MessageTableViewDataSource.swift
//  InvoltaTestovoe
//
//  Created by Евгений Васильев on 20.04.2023.
//

import UIKit

protocol MessageDataSource: UITableViewDataSource {
    var messages: [String]? { get set }
    var didReloadTable: EmptyBlock? { get set }
    func addMessage(text: String)
    func clearData()
}

final class MessageTableViewDataSource: NSObject, MessageDataSource {

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

    var didReloadTable: EmptyBlock?

    // MARK: - Private Properties

    private var workingMessages: [String] = []

    // MARK: - Methods

    func addMessage(text: String) {
        workingMessages = [text] + workingMessages
        didReloadTable?()
    }

    func clearData() {
        workingMessages = []
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
