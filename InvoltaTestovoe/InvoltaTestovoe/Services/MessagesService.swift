//
//  MessagesService.swift
//  InvoltaTestovoe
//
//  Created by Евгений Васильев on 20.04.2023.
//

import Foundation

protocol MessagesServiceDelegate {
    func getMessages(offSet: String, completion: @escaping (MessagesRequestModel) -> Void)
}

final class MessagesService: MessagesServiceDelegate {

    var messages: MessagesRequestModel?

    // MARK: - Methods

    func getMessages(offSet: String, completion: @escaping (MessagesRequestModel) -> Void) {
        MessageRequest().getMessages(offSet: offSet, completion: completion)
    }

}
