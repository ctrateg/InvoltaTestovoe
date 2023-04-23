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
    func updateData(offSet: String)
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
        static let offSetStep = 20
    }
    
    // MARK: - Properties

    var view: MessageViewDelegate?

    // MARK: - Private Properties

    private let messageService: MessagesServiceDelegate
    private let group = DispatchGroup()

    private var localMessagesModel: [MessageStorageModel] = []
    private var messages: [String] = []
    private var iconsUrl: [String] = []
    private var page = 0
    private var offSet = 20

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

        getIcons()

        group.enter()
        messageService.getMessages(offSet: Constants.defaultOffset) { [weak self] response in
            switch response {
            case .success(let result):
                guard let self = self else { return }
                let localMessagesModel = StorageService.shared.load()
                let localMessages = localMessagesModel.map { $0.message }.compactMap{ $0 }
                let messages = localMessages + result
                self.localMessagesModel = localMessagesModel
                self.messages = messages
                self.view?.updateScreen(messages: Array(messages.prefix(self.offSet)), iconsUrl: self.iconsUrl)
                self.view?.loadingState(false)
            case .failure(_):
                self?.view?.openErrorScreen()
            }
            self?.group.leave()
        }

    }

    func updateData(offSet: String) {
        page += 1
        self.offSet += Constants.offSetStep
        getIcons()

        group.enter()
        self.messageService.getMessages(offSet: offSet) { [weak self] response in
            guard let self = self else { return }
            switch response {
            case .success(let result):
                self.messages += result
                self.view?.updateScreen(messages: Array(self.messages.prefix(self.offSet)), iconsUrl: self.iconsUrl)
            case .failure(let error):
                print(error)
            }
            self.group.leave()
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
        view?.updateScreen(messages: messages, iconsUrl: iconsUrl)
    }
    
}

// MARK: - Private Properties

private extension MessagePresenter {

    func getIcons() {
        group.enter()
        messageService.getIcon(page: page) { [weak self] response in
            switch response {
            case .success(let result):
                self?.iconsUrl += result
            case .failure(_):
                self?.view?.openErrorScreen()
            }
            self?.group.leave()
        }
    }

}
