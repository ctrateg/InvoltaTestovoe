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
    private(set) var icon: UIImage?

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

    func configure(message: String, icon: UIImage) {
        messageLabel.text = message
        self.message = message
        configureIconView(icon: icon)
        transform = CGAffineTransform(rotationAngle: CGFloat.pi)
    }

    override func prepareForReuse() {
        messageLabel.text = ""
        iconView.image = nil
    }

}

// MARK: - Private Properties

extension MessageTableViewCell {

    func setupInitialState() {
        messageLabel.numberOfLines = .zero
        messageLabel.textAlignment = .right
        messageLabel.textColor = Colors.whiteColor
        messageLabel.backgroundColor = .none
        messageLabel.paddingLeft = Constants.padding
        messageLabel.paddingRight = Constants.padding

        opaqueView.backgroundColor = Colors.lightGrayColor
        opaqueView.layer.cornerRadius = Constants.cornerRadius

        backgroundColor = Colors.mintColor
    }

    func configureIconView(icon: UIImage) {
        iconView.image = icon
        self.icon = icon
        iconView.layer.cornerRadius = iconView.frame.height / 2
    }

}
