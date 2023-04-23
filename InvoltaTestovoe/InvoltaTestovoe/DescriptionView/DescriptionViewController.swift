//
//  DescriptionViewController.swift
//  InvoltaTestovoe
//
//  Created by Евгений Васильев on 21.04.2023.
//

import UIKit

struct DescriptionModel {
    let index: Int
    let message: String?
}

final class DescriptionViewController: UIViewController {

    // MARK: - Constants
    
    private enum Constants {
        static let buttonName = "Удалить"
        static let backButtonTitle = "Назад"
        static let localMessagesName = "LocalMessages"
        static let notificationReload = "ReloadData"
    }

    // MARK: - IBOutlets

    @IBOutlet private weak var icon: UIImageView!
    @IBOutlet private weak var dateLabel: UILabel!
    @IBOutlet private weak var messageLabel: UILabel!
    @IBOutlet private weak var deleteButton: UIButton!

    // MARK: - Properties
    
    var model: DescriptionModel?
    var didDeletetMessage: ((Int) -> ())?

    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = false

        let backButton = UIBarButtonItem()
        backButton.title = Constants.backButtonTitle
        navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
    
        setupInitialState()
    }

    // MARK: - Actions

    @IBAction private func didSelectDelete(_ sender: Any) {
        guard let index = model?.index else { return }
        didDeletetMessage?(index)
        navigationController?.popViewController(animated: true)
    }

}

// MARK: - Private Methods

private extension DescriptionViewController {

    func setupInitialState() {
        self.messageLabel.text = model?.message
        self.dateLabel.text = Date().formatted()
        self.deleteButton.setTitle(Constants.buttonName, for: .normal)
        messageLabel.font = .systemFont(ofSize: 22, weight: .heavy)
        messageLabel.numberOfLines = 0
        dateLabel.font = .systemFont(ofSize: 12, weight: .light)
    }

}
