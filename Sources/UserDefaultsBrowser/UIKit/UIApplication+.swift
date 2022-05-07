//
//  File.swift
//
//
//  Created by Yusuke Hosonuma on 2022/05/07.
//

import UIKit

extension UIApplication {
    static var rootWindow: UIWindow? {
        Self.shared.windows.first
    }

    static var rootScene: UIWindowScene? {
        Self.shared.connectedScenes.first as? UIWindowScene
    }
}
