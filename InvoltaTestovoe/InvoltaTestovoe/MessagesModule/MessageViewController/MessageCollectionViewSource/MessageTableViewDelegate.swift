//
//  MessageTableViewDelegate.swift
//  InvoltaTestovoe
//
//  Created by Евгений Васильев on 20.04.2023.
//

import UIKit

protocol MessageViewSelectableDelegate: UITableViewDelegate {
    var didSelectItem: ((DescriptionModel) -> ())? { get set }
}

final class MessageTableViewDelegate: NSObject, MessageViewSelectableDelegate {

    // MARK: - Properties

    var didSelectItem: ((DescriptionModel) -> ())?
    var messages: [String]?
    
    // MARK: - CollectionViewSelectableItemDelegate

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as? MessageTableViewCell
        let model = DescriptionModel(index: indexPath.row, message: cell?.message)
        didSelectItem?(model)
    }
    
}
