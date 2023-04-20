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
            workingMessages.append(contentsOf: newValue ?? [])
        }
    }

    // MARK: - Private Properties

    private var workingMessages: [String] = []
    private weak var collectionView: UICollectionView?

    // MARK: - Initialization

    init(collectionView: UICollectionView) {
        self.collectionView = collectionView
    }

    // MARK: - Methods

    func addMessage(text: String) {
        workingMessages = [text] + workingMessages
        collectionView?.reloadData()
    }

    // MARK: - UICollectionViewDataSource

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return workingMessages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.messageCell, for: indexPath) as? MessageCollectionCell
        else {
            return UICollectionViewCell()
        }

        cell.configure(message: workingMessages[indexPath.row])
    
        cell.transform = CGAffineTransform(rotationAngle: CGFloat.pi)

        return cell
    }
    
}
