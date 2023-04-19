//
//  MessageViewController.swift
//  InvoltaTestovoe
//
//  Created by Евгений Васильев on 20.04.2023.
//

import UIKit

protocol MessageViewDelegate {
    /// Method for setup initial state of view
    func setupInitialState()
    /// Method for update screen with data
    func updateScreen()
}

final class MessageViewController: UIViewController {

    // MARK: - IBOutlets

    @IBOutlet private weak var messageCollectionView: UICollectionView!

    // MARK: - Properties

    var presenter: MessagePresenterDelegate?

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.viewDidLoad()
    }

}

// MARK: - MessageViewDelegate

extension MessageViewController: MessageViewDelegate {

    func setupInitialState() {

    }
    
    func updateScreen() {
        
    }
    
    
}

// MARK: - Private Methods

private extension MessageViewController {

    func configureMessageCollectionView() {
        messageCollectionView.showsVerticalScrollIndicator = false
    }

}
