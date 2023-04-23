//
//  SwippingNavigationController.swift
//  InvoltaTestovoe
//
//  Created by Евгений Васильев on 23.04.2023.
//

import UIKit

final class SwippingNavigationController: UINavigationController {
    
    // MARK: - Private Properties
    
    private var duringPushAnimation = false

    override init(rootViewController: UIViewController) {
        super.init(rootViewController: rootViewController)

         delegate = self
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        delegate = self
    }

}

// MARK: - UINavigationControllerDelegate

extension SwippingNavigationController: UINavigationControllerDelegate {
    
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        guard let swipeNavigationController = navigationController as? SwippingNavigationController else { return }
        
        swipeNavigationController.duringPushAnimation = false
    }
    
}

// MARK: - UIGestureRecognizerDelegate

extension SwippingNavigationController: UIGestureRecognizerDelegate {
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        guard gestureRecognizer == interactivePopGestureRecognizer else {
            return true
        }

        return viewControllers.count > 1 && duringPushAnimation == false
    }
}
