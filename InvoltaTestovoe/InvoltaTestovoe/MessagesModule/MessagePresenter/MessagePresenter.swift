//
//  MessagePresenter.swift
//  InvoltaTestovoe
//
//  Created by Евгений Васильев on 20.04.2023.
//

import Foundation

protocol MessagePresenterDelegate {
    /// Notify presenter that view is ready
    func viewDidLoad()
    /// Update data
    func update(offset: String)
}

final class MessagePresenter {

    // MARK: - Constants
    
    private enum Constants {
        static let defaultOffset = "0"
    }
    
    // MARK: - Properties

    var router: MessageRouterDelegate?
    var view: MessageViewDelegate?

    // MARK: - Private Properties

    private let messageService: MessagesServiceDelegate

    // MARK: - Initialization

    init(messageService: MessagesServiceDelegate) {
        self.messageService = messageService
    }

}

// MARK: - MessagePresenterDelegate

extension MessagePresenter: MessagePresenterDelegate {

    func viewDidLoad() {
        view?.setupInitialState()
        update(offset: Constants.defaultOffset)
    }

    func update(offset: String) {
        messageService.getMessages(offSet: offset) { model in
            DispatchQueue.main.async(flags: .barrier) {
                self.view?.updateScreen(messages: model.result)
            }
        }
    }
    
}
