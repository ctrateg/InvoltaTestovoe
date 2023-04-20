//
//  MessageCollectionViewDelegate.swift
//  InvoltaTestovoe
//
//  Created by Евгений Васильев on 20.04.2023.
//

import UIKit

protocol CollectionViewSelectableItemDelegate: UICollectionViewDelegateFlowLayout {
    var didSelectItem: ((_ indexPath: IndexPath) -> Void)? { get set }
}

final class MessageCollectionViewDelegate: NSObject, CollectionViewSelectableItemDelegate {

    // MARK: - Properties

    var didSelectItem: ((IndexPath) -> Void)?

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let sectionInset = (collectionViewLayout as! UICollectionViewFlowLayout).sectionInset
        let referenceHeight: CGFloat = 100 
        let referenceWidth = collectionView.safeAreaLayoutGuide.layoutFrame.width
            - sectionInset.left
            - sectionInset.right
            - collectionView.contentInset.left
            - collectionView.contentInset.right
        return CGSize(width: referenceWidth, height: referenceHeight)
    }
    
    // MARK: - CollectionViewSelectableItemDelegate
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        didSelectItem?(indexPath)
    }
    
    
}
