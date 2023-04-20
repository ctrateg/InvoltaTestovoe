//
//  MessageCollectionViewDataSource.swift
//  InvoltaTestovoe
//
//  Created by Евгений Васильев on 20.04.2023.
//

import UIKit

final class MessageCollectionViewDataSource: NSObject, UICollectionViewDataSource {

    // MARK: - Constants
    
    private enum Constants {
        static let messageCell = "MessageCollectionCell"
    }
    // MARK: - Properties

    var messages: [String]? {
        get {
            return workingMessages
        }
        set {
            workingMessages?.append(contentsOf: newValue ?? [])
        }
    }

    // MARK: - Private Properties

    private var workingMessages: [String]?
    private weak var collectionView: UICollectionView?

    // MARK: - Initialization

    init(collectionView: UICollectionView) {
        self.collectionView = collectionView
    }

    // MARK: - UICollectionViewDataSource

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return workingMessages?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.messageCell, for: indexPath) as? MessageCollectionCell,
            let message = workingMessages?[indexPath.row]
        else {
            return UICollectionViewCell()
        }

        cell.configure(message: message)

        return cell
    }
    
}
