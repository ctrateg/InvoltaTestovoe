//
//  DescriptionViewController.swift
//  InvoltaTestovoe
//
//  Created by Евгений Васильев on 21.04.2023.
//

import UIKit

final class DescriptionViewController: UIViewController {

    // MARK: - Constants
    
    private enum Constants {
        static let buttonName = "Удалить"
        static let backButtonTitle = "Назад"
    }

    // MARK: - IBOutlets

    @IBOutlet private weak var icon: UIImageView!
    @IBOutlet private weak var date: UILabel!
    @IBOutlet private weak var message: UILabel!
    @IBOutlet private weak var deleteButton: UIButton!

    // MARK: - Properties
    
    var titleMessage: String?

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
    }

}

// MARK: - Private Methods

private extension DescriptionViewController {

    func setupInitialState() {
        self.message.text = titleMessage
        self.date.text = Date().formatted()
        self.deleteButton.titleLabel?.text = Constants.buttonName
        message.font = .systemFont(ofSize: 22, weight: .heavy)
        message.numberOfLines = 0
        date.font = .systemFont(ofSize: 12, weight: .light)
    }

}
