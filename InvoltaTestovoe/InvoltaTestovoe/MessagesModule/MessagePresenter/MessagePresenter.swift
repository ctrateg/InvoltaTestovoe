//
//  MessagePresenter.swift
//  InvoltaTestovoe
//
//  Created by Евгений Васильев on 20.04.2023.
//

import Foundation
import CoreData

protocol MessagePresenterDelegate {
    /// Notify presenter that view is ready
    func viewDidLoad()
    /// Setup data
    func setupData()
    /// Update data
    func updateData(offset: String)
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
    private var localMessagesModel: [MessageStorageModel] = []
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
        setupData()
    }

    func setupData() {
        view?.loadingState(true)
        self.messageService.getMessages(offSet: Constants.defaultOffset) { [weak self] response in
            switch response {
            case .success(let result):
                let localMessagesModel = StorageService.shared.load()
                let localMessages = localMessagesModel.map { $0.message }.compactMap{ $0 }
                self?.localMessagesModel = localMessagesModel
                self?.messages = localMessages + (result )
                self?.view?.updateScreen(messages: localMessages + result)
                self?.view?.loadingState(false)
            case .failure(_):
                self?.view?.openErrorScreen()
            }
        }
    }

    func updateData(offset: String) {
        self.messageService.getMessages(offSet: offset) { [weak self] response in
            switch response {
            case .success(let result):
                self?.messages += result
                self?.view?.updateScreen(messages: self?.messages)
            case .failure(let error):
                print(error)
            }
        }
    }

    func addNewMessage(message: String) {
        messages.insert(message, at: 0)
        StorageService.shared.save(value: message)
        localMessagesModel = StorageService.shared.load()
    }

    func deleteMessage(at index: Int) {
        if index < localMessagesModel.count {
            StorageService.shared.remove(model: localMessagesModel[index])
            localMessagesModel = StorageService.shared.load()
        }

        messages.remove(at: index)
        view?.updateScreen(messages: messages)
    }
    
}
