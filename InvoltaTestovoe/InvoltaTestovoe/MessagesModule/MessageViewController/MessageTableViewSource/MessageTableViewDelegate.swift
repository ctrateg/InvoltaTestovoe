//
//  MessageTableViewDelegate.swift
//  InvoltaTestovoe
//
//  Created by Евгений Васильев on 20.04.2023.
//

import UIKit

protocol MessageViewSelectableDelegate: UITableViewDelegate {
    var didSelectItem: ModelBlock<DescriptionModel>? { get set }
    var didLoadMore: IntBlock? { get set }
}

final class MessageTableViewDelegate: NSObject, MessageViewSelectableDelegate {

    // MARK: - Properties

    var didSelectItem: ModelBlock<DescriptionModel>?
    var didLoadMore: IntBlock?
    var messages: [String]?
    
    // MARK: - CollectionViewSelectableItemDelegate

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as? MessageTableViewCell
        let model = DescriptionModel(index: indexPath.row, message: cell?.message)
        didSelectItem?(model)
    }

//    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        if indexPath.row % 10 == 0 {
//            didLoadMore?(indexPath.row)
//        }
//    }
    
}
