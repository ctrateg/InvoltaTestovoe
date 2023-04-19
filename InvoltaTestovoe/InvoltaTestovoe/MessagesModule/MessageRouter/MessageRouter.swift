//
//  MessageRouter.swift
//  InvoltaTestovoe
//
//  Created by Евгений Васильев on 20.04.2023.
//

import Foundation

protocol MessageRouterDelegate {
    func openMessageDiscribtion()
}

final class MessageRouter {

    // MARK: - Properties

    var view: MessageViewDelegate?

}

// MARK: - MessageRouterDelegate

extension MessageRouter: MessageRouterDelegate {

    func openMessageDiscribtion() {
        
    }

}
