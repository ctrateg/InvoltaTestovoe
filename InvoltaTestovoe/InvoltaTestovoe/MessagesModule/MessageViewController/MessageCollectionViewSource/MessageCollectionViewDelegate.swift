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
//    var didPaggination: ((String)->())?

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

//    // MARK: - Private Properties
//
//    private weak var collectionView: UICollectionView?
////    private var isPageRefreshing = false
////    private var pagginationOffset = 0
//
//    // MARK: - Initialization
//
//    init(collectionView: UICollectionView) {
//        self.collectionView = collectionView
//    }

    // MARK: - CollectionViewSelectableItemDelegate
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        didSelectItem?(indexPath)
    }

//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        if(self.collectionView?.contentOffset.y ?? 0 >= (self.collectionView?.contentSize.height - self.collectionView?.bounds.size.height)) {
//           if !isPageRefreshing {
//               isPageRefreshing = true
//               self.pagginationOffset = self.pagginationOffset + 1
//               didPaggination?(String(self.pagginationOffset))
//           }
//       }
//   }
    
}
