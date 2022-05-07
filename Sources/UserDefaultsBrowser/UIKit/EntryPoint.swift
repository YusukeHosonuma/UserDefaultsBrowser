//
//  File.swift
//
//
//  Created by Yusuke Hosonuma on 2022/05/07.
//

import SwiftUI

private var overlayWindow: UIWindow?

//
// 􀤂 Display launcher icon on leading-bottom.
//
public func setupUserDefaultsBrowserLauncher(
    suiteNames: [String] = [],
    excludeKeys: @escaping (String) -> Bool = { _ in false },
    accentColor: UIColor = .blue,
    imageName: String = "externaldrive",
    displayStyle: DisplayStyle = .sheet
) {
    if let rootWindow = UIApplication.rootWindow, let scene = UIApplication.rootScene {
        let window = UIWindow(windowScene: scene)
        window.backgroundColor = .clear
        window.frame = CGRect(x: 16, y: (UIScreen.main.bounds.height - 24) - 16, width: 24, height: 24)
        window.windowLevel = .alert + 1

        let vc = UserDefaultsBrowserLauncherViewController(
            rootWindow: rootWindow,
            suiteNames: suiteNames,
            excludeKeys: excludeKeys,
            accentColor: accentColor,
            imageName: imageName,
            displayStyle: displayStyle
        )
        window.rootViewController = vc

        window.makeKeyAndVisible()
        overlayWindow = window
    }
}
