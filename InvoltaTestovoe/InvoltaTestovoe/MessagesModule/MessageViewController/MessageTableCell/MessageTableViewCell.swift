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
        static let padding: CGFloat = 8
    }

    // MARK: - Properties

    private(set) var message: String?
    private(set) var image: UIImage?

    // MARK: - IBOutlets

    @IBOutlet private weak var iconView: UIImageView!
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
        messageLabel.paddingLeft = Constants.padding
        messageLabel.paddingRight = Constants.padding

        iconView.layer.cornerRadius = iconView.frame.size.width/2

        opaqueView.backgroundColor = .lightGray
        opaqueView.layer.cornerRadius = Constants.cornerRadius

        backgroundColor = .systemMint
    }
}
