//
//  MessagesService.swift
//  InvoltaTestovoe
//
//  Created by Евгений Васильев on 20.04.2023.
//

import Foundation

protocol MessagesServiceDelegate {
    func getMessages(offSet: String, completion: @escaping (MessagesModel) -> Void)
}

final class MessagesService: MessagesServiceDelegate {

    var messages: MessagesModel?

    // MARK: - Methods

    func getMessages(offSet: String, completion: @escaping (MessagesModel) -> Void) {
        MessageRequest().getMessages(offSet: offSet, completion: completion)
    }

}
