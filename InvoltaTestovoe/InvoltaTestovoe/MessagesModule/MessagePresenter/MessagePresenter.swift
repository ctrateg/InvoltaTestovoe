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
    /// Notify presenter that view did appear
    func viewDidAppear()
}

final class MessagePresenter {
    
    // MARK: - Properties

    var router: MessageRouterDelegate?
    var view: MessageViewDelegate?

    // MARK: - Private Properties

    private let messageService: MessagesServiceDelegate

    // MARK: - Init

    init(messageService: MessagesServiceDelegate) {
        self.messageService = messageService
    }

}

// MARK: - MessagePresenterDelegate

extension MessagePresenter: MessagePresenterDelegate {

    func viewDidLoad() {
        messageService.getMessages(offSet: "0") { result in
            print(result)
        }
    }
    
    func viewDidAppear() {
        
    }
    
    
}
