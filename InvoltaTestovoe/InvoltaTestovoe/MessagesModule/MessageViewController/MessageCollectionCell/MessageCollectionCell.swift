//
//  MessageCollectionCell.swift
//  InvoltaTestovoe
//
//  Created by Евгений Васильев on 20.04.2023.
//

import UIKit

final class MessageCollectionCell: UICollectionViewCell {

    // MARK: - Constants
    
    private enum Constants {
        static let cornerRadius: CGFloat = 10
    }

    // MARK: - IBOutlets

    @IBOutlet private weak var textLabel: UILabel!

    // MARK: - Lifecycle

    override func awakeFromNib() {
        super.awakeFromNib()
        setupInitialState()
    }

    // MARK: - Methods

    func configure(message: String) {
        textLabel.text = message
    }

    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        textLabel.preferredMaxLayoutWidth = layoutAttributes.size.width - contentView.layoutMargins.left - contentView.layoutMargins.left
        layoutAttributes.bounds.size.height = systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
        layoutAttributes.bounds.size.width = systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).width
        
        transform = CGAffineTransform(rotationAngle: CGFloat.pi)
        return layoutAttributes
    }

}

// MARK: - Private Properties

extension MessageCollectionCell {

    func setupInitialState() {
        textLabel.numberOfLines = .zero
        textLabel.textAlignment = .right
        textLabel.textColor = .black
        
        backgroundColor = .gray
        layer.cornerRadius = Constants.cornerRadius
    }
}
