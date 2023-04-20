//
//  MessageTableViewDelegate.swift
//  InvoltaTestovoe
//
//  Created by Евгений Васильев on 20.04.2023.
//

import UIKit

protocol CollectionViewSelectableItemDelegate: UITableViewDelegate {
    var didSelectItem: ((String) -> Void)? { get set }
}

final class MessageTableViewDelegate: NSObject, CollectionViewSelectableItemDelegate {

    // MARK: - Properties

    var didSelectItem: ((String) -> Void)?
    
    // MARK: - CollectionViewSelectableItemDelegate

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as? MessageTableViewCell
        didSelectItem?(cell?.message ?? "")
    }
    
}
