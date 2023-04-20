//
//  MessageCollectionViewAdapter.swift
//  InvoltaTestovoe
//
//  Created by Евгений Васильев on 20.04.2023.
//

import UIKit

final class MessageCollectionViewAdapter {

    // MARK: - Constants
    
    private enum Constants {
        static let contentEdgeInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        static let minimumInteritemSpacing: CGFloat = 16
    }

    // MARK: - Private Properties

    private var collectionView: UICollectionView
    private lazy var collectionDataSource = MessageCollectionViewDataSource(collectionView: collectionView)
    private lazy var collectionDelegate = MessageCollectionViewDelegate()

    // MARK: - Initialization

    init(collectionView: UICollectionView) {
        self.collectionView = collectionView
    }

    // MARK: - Methods

    func configure() {
        configureMessageCollectionView()
    }

    func updateMessage(with message: [String]?) {
        collectionDataSource.messages = message
    }

    func addMessage(text: String) {
        collectionDataSource.addMessage(text: text)
    }

}

// MARK: - Private Methods

private extension MessageCollectionViewAdapter {

    func configureMessageCollectionView() {
        let cellNib = UINib(nibName: "MessageCollectionCell", bundle: nil)
        collectionView.register(cellNib, forCellWithReuseIdentifier: "MessageCollectionCell")
        collectionView.backgroundColor = .systemMint
        collectionView.dataSource = collectionDataSource
        collectionView.delegate = collectionDelegate
        
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.clipsToBounds = false
        collectionView.isPagingEnabled = true
        collectionView.semanticContentAttribute = .forceLeftToRight
        configureCollectionLayout()
        collectionView.transform = CGAffineTransform.init(rotationAngle: (-(CGFloat)(Double.pi)))
    }

    func configureCollectionLayout() {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = Constants.minimumInteritemSpacing
        layout.scrollDirection = .vertical
        layout.sectionInset = Constants.contentEdgeInsets
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        collectionView.collectionViewLayout = layout
    }

}
