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
    /// Add message for storage
    func addNewMessage(message: String)
    /// Delete message from storage
    func deleteMessage(at index: Int)
}

final class MessagePresenter {

    // MARK: - Constants
    
    private enum Constants {
        static let defaultOffset = "0"
        static let baseCountMessages = 14
    }
    
    // MARK: - Properties

    var view: MessageViewDelegate?

    // MARK: - Private Properties

    private let messageService: MessagesServiceDelegate
    private var localMessages: [String] = []
    private var messages: [String] = []

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
        self.localMessages = StorageService.shared.load(key: .messages)
        self.messageService.getMessages(offSet: offset) { model in
            DispatchQueue.main.async { [weak self] in
                self?.messages = (self?.localMessages ?? []) + (model.result ?? [])
                self?.view?.updateScreen(messages: self?.messages)
            }
        }
    }

    func addNewMessage(message: String) {
        messages.insert(message, at: 0)
        StorageService.shared.save(value: localMessages, key: .messages)
    }

    func deleteMessage(at index: Int) {
        if index < localMessages.count {
            StorageService.shared.delete(for: .messages, at: index)
            localMessages = StorageService.shared.load(key: .messages)
        }

        messages.remove(at: index)
        view?.updateScreen(messages: messages)
    }
    
}
