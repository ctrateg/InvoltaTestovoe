//
//  UIApplication.swift
//  InvoltaTestovoe
//
//  Created by Евгений Васильев on 24.04.2023.
//

import UIKit

extension UIApplication {

    static var firstKeyWindow: UIWindow? {
        if #available(iOS 13.0, *) {
            return UIApplication
                .shared
                .connectedScenes
                .flatMap { ($0 as? UIWindowScene)?.windows ?? [] }
                .first { $0.isKeyWindow }
        } else {
            return UIApplication.shared.keyWindow
        }
    }

}
