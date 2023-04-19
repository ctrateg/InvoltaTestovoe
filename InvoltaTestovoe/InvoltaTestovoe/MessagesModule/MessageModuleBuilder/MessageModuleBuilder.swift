//
//  MessageModuleBuilder.swift
//  InvoltaTestovoe
//
//  Created by Евгений Васильев on 20.04.2023.
//

import UIKit

final class MessageModuleBuilder {

    // MARK: - Methods

    func build() -> UIViewController {
        let viewController = MessageViewController()
        let router = MessageRouter()
        let presenter = MessagePresenter(messageService: MessagesService())

        presenter.router = router
        presenter.view = viewController
        router.view = viewController
        viewController.presenter = presenter
        
        return viewController
    }

}
