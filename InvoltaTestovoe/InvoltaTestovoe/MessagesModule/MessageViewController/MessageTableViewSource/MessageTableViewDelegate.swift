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
        static let offSetForMessageRequests = 20
    }

    // MARK: - Properties

    var didSelectItem: ModelBlock<DescriptionModel>?
    var didLoadMore: IntBlock?

    // MARK: - Private Properties

    private var offSetForMessageRequests: Int = .zero
    private var pagesForIconRequest = 0
    
    // MARK: - UITableViewDelegate

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? MessageTableViewCell else { return }
        let model = DescriptionModel(index: indexPath.row, message: cell.message, icon: cell.icon)

        didSelectItem?(model)
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let lastSectionIndex = tableView.numberOfSections - 1
        let lastRowIndex = tableView.numberOfRows(inSection: lastSectionIndex) - 1
        if indexPath.section ==  lastSectionIndex && indexPath.row == lastRowIndex {
            offSetForMessageRequests += Constants.offSetForMessageRequests
            didLoadMore?(offSetForMessageRequests)
        }
    }

}
