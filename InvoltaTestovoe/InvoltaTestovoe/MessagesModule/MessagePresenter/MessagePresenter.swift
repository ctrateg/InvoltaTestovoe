//
//  MessagePresenter.swift
//  InvoltaTestovoe
//
//  Created by Евгений Васильев on 20.04.2023.
//

import Foundation
import UIKit

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
        static let snackMessage = "Иконки не смогли загрузится"
        static let defaultOffset = "0"
        static let baseCountMessages = 14
        static let offSetStep = 20
        static let page = 1
    }
    
    // MARK: - Properties

    var view: MessageViewDelegate?

    // MARK: - Private Properties

    private let messageService: MessagesServiceDelegate
    private let group: DispatchGroup
    private var localMessagesModel: [MessageStorageModel] = []
    private var messages: [String] = []
    private var images: [UIImage] = []
    private var page = 0
    private var offSet = 20

    // MARK: - Initialization

    init(messageService: MessagesServiceDelegate) {
        self.messageService = messageService
        self.group = DispatchGroup()
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

        group.enter()
        var iconsUrl: [String] = []
        messageService.getIcon(page: Constants.page) { [weak self] response in
            switch response {
            case .success(let result):
                self?.group.enter()
                DispatchQueue.main.async {
                    iconsUrl.append(contentsOf: result)
                    self?.load(urls: iconsUrl.map { URL(string: $0) })
                    self?.group.leave()
                }
            case .failure(_):
                DispatchQueue.main.async { [weak self] in
                    self?.view?.openErrorScreen()
                }
            }
            self?.group.leave()
        }

        group.enter()
        messageService.getMessages(offSet: Constants.defaultOffset) { [weak self] response in
            self?.group.enter()
            switch response {
            case .success(let result):
                DispatchQueue.main.async {
                    guard let self = self else { return }
                    let localMessagesModel = StorageService.shared.load()
                    let localMessages = localMessagesModel.map { $0.message }.compactMap{ $0 }
                    self.localMessagesModel = localMessagesModel
                    self.messages = localMessages + result
                    self.group.leave()
                }
            case .failure(_):
                DispatchQueue.main.async {
                    self?.view?.loadingState(false)
                    self?.view?.openErrorScreen()
                    self?.group.leave()
                }
            }
            self?.group.leave()
        }

        group.notify(queue: DispatchQueue.main) { [weak self] in
            guard
                let messages = self?.messages,
                let offSet = self?.offSet,
                let images = self?.images
            else {
                return
            }

            self?.view?.updateScreen(messages: Array(messages.prefix(offSet)), icons: images)
            self?.view?.loadingState(false)
        }
    }

    func updateData(offSet: String) {
        group.enter()
        self.offSet += Constants.offSetStep
        self.messageService.getMessages(offSet: offSet) { [weak self] response in
            self?.group.enter()
            switch response {
            case .success(let result):
                DispatchQueue.main.async {
                    guard let self = self else { return }
                    self.messages += result
                    self.group.leave()
                }
            case .failure(_):
                SnackMessenger.shared.show(message: Constants.snackMessage, autocomplete: true)
                self?.group.leave()
            }
            self?.group.leave()
        }

        group.notify(queue: DispatchQueue.main) { [weak self] in
            guard
                let messages = self?.messages,
                let offSet = self?.offSet,
                let images = self?.images
            else {
                return
            }

            self?.view?.updateScreen(messages: Array(messages.prefix(offSet)), icons: images)
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
    }
    
}

// MARK: - Private Properties

private extension MessagePresenter {

    func load(urls: [URL?]) {
        for url in urls {
            group.enter()
            DispatchQueue.global().async { [weak self] in
                if
                    let unwarperUrl = url,
                        let data = try? Data(contentsOf: unwarperUrl)
                {
                    if let image = UIImage(data: data) {
                        self?.group.enter()
                        DispatchQueue.main.async {
                            self?.images.append(image)
                            self?.group.leave()
                        }
                    }
                }
                self?.group.leave()
            }
        }
    }
}
