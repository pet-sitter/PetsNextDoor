//
//  UIWindow+Extension.swift
//  PetsNextDoor
//
//  Created by kevinkim2586 on 2023/06/25.
//

import UIKit

extension UIWindow {
    static var key: UIWindow? {
        UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .flatMap    { $0.windows }
            .first      { $0.isKeyWindow }
    }
}
