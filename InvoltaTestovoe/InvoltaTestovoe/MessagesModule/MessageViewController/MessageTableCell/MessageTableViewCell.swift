//
//  MessageTableViewCell.swift
//  InvoltaTestovoe
//
//  Created by Евгений Васильев on 21.04.2023.
//

import UIKit

final class MessageTableViewCell: UITableViewCell {

    // MARK: - Constants
    
    private enum Constants {
        static let cornerRadius: CGFloat = 10
    }

    // MARK: - Properties

    private(set) var message: String?

    // MARK: - IBOutlets

    @IBOutlet private weak var opaqueView: UIView!
    @IBOutlet private weak var messageLabel: PaddingLabel!

    // MARK: - Lifecycle

    override func awakeFromNib() {
        super.awakeFromNib()
        setupInitialState()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
            super.setSelected(selected, animated: animated)
            if selected{
                UIView.animate(withDuration: 0.2, animations: {
                    self.opaqueView.transform = CGAffineTransform(scaleX: 0.97, y: 0.97)
                    self.messageLabel.transform = CGAffineTransform(scaleX: 0.97, y: 0.97)
                }, completion: { finished in
                    UIView.animate(withDuration: 0.2) {
                        self.opaqueView.transform = .identity
                        self.messageLabel.transform = .identity
                    }
                })
            }
        }

    // MARK: - Methods

    func configure(message: String) {
        messageLabel.text = message
        self.message = message
        transform = CGAffineTransform(rotationAngle: CGFloat.pi)
    }

//    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
//        super.preferredLayoutAttributesFitting(layoutAttributes)
//        textLabel.preferredMaxLayoutWidth = layoutAttributes.size.width - contentView.layoutMargins.left - contentView.layoutMargins.left
//        layoutAttributes.bounds.size.height = systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
//
//        transform = CGAffineTransform(rotationAngle: CGFloat.pi)
//
//        return layoutAttributes
//    }

    override func prepareForReuse() {
        super.prepareForReuse()
        messageLabel.text = ""
    }

}

// MARK: - Private Properties

extension MessageTableViewCell {

    func setupInitialState() {
        messageLabel.numberOfLines = .zero
        messageLabel.textAlignment = .right
        messageLabel.textColor = .white
        messageLabel.backgroundColor = .none
        messageLabel.paddingLeft = 8
        messageLabel.paddingRight = 8

        opaqueView.backgroundColor = .lightGray
        opaqueView.layer.cornerRadius = Constants.cornerRadius

        backgroundColor = .systemMint
    }
}
