//
//  MessageTableViewDelegate.swift
//  InvoltaTestovoe
//
//  Created by Евгений Васильев on 20.04.2023.
//

import UIKit

protocol MessageViewSelectableDelegate: UITableViewDelegate {
    /// Action called then cell tapped
    var didSelectItem: ModelBlock<DescriptionModel>? { get set }
    /// Action call then top of table for load more
    var didLoadMore: IntBlock? { get set }
}

final class MessageTableViewDelegate: NSObject, MessageViewSelectableDelegate {

    // MARK: - Constants
    
    private enum Constants {
        static let spinnerHeight: CGFloat = 44
        static let offSetForRequests = 20
    }

    // MARK: - Properties

    var didSelectItem: ModelBlock<DescriptionModel>?
    var didLoadMore: IntBlock?
    var messages: [String]?

    // MARK: - Private Properties

    private var offSetForRequests: Int = .zero
    
    // MARK: - UITableViewDelegate

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as? MessageTableViewCell
        let model = DescriptionModel(index: indexPath.row, message: cell?.message)
        didSelectItem?(model)
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let lastSectionIndex = tableView.numberOfSections - 1
        let lastRowIndex = tableView.numberOfRows(inSection: lastSectionIndex) - 1
        if indexPath.section ==  lastSectionIndex && indexPath.row == lastRowIndex {
            let spinner = UIActivityIndicatorView(style: .medium)
            spinner.startAnimating()
            spinner.frame = CGRect(x: .zero, y: .zero, width: tableView.bounds.width, height: Constants.spinnerHeight)

            tableView.tableFooterView = spinner
            tableView.tableFooterView?.isHidden = false
            offSetForRequests += Constants.offSetForRequests
            didLoadMore?(offSetForRequests)
        }
    }

}
