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
        super.preferredLayoutAttributesFitting(layoutAttributes)
        textLabel.preferredMaxLayoutWidth = layoutAttributes.size.width - contentView.layoutMargins.left - contentView.layoutMargins.left
        layoutAttributes.bounds.size.height = systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height

        transform = CGAffineTransform(rotationAngle: CGFloat.pi)

        return layoutAttributes
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        textLabel.text = ""
    }

}

// MARK: - Private Properties

extension MessageCollectionCell {

    func setupInitialState() {
        textLabel.numberOfLines = .zero
        textLabel.textAlignment = .center
        textLabel.textColor = .black
        
        backgroundColor = .gray
        layer.cornerRadius = Constants.cornerRadius
    }
}
