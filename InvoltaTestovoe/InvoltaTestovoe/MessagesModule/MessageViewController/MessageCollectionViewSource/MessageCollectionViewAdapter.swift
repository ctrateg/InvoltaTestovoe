//
//  MessageCollectionViewAdapter.swift
//  InvoltaTestovoe
//
//  Created by Евгений Васильев on 20.04.2023.
//

import UIKit

final class MessageCollectionViewAdapter {

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
        let cell = MessageCollectionCell()
        cell.configure(message: text)
        collectionView.a
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
        // layout.itemSize = CGSize(width: 300, height: 40)
        layout.minimumInteritemSpacing = 16
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 120)
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        layout.sectionInsetReference = .fromLayoutMargins
        collectionView.collectionViewLayout = layout
    }

}
