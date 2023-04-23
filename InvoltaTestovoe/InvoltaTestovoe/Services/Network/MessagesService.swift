//
//  MessagesService.swift
//  InvoltaTestovoe
//
//  Created by Евгений Васильев on 20.04.2023.
//

import Foundation

protocol MessagesServiceDelegate {
    func getMessages(offSet: String, completion: @escaping RequestBlock<String>)
}

final class MessagesService: MessagesServiceDelegate {

    var messages: MessagesRequestModel?

    // MARK: - Methods

    func getMessages(offSet: String, completion: @escaping RequestBlock<String>) {
        MessageRequest().getMessages(offSet: offSet, completion: completion)
    }

}
