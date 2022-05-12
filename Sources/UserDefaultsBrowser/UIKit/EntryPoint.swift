//
//  File.swift
//
//
//  Created by Yusuke Hosonuma on 2022/05/07.
//

import SwiftUI

private var overlayWindow: UIWindow?
private let overlayWindowSize = CGSize(width: 44, height: 44)

//
// 􀤂 Display launcher icon on leading-bottom.
//
public func setupUserDefaultsBrowserLauncher(
    suiteNames: [String] = [],
    excludeKeys: @escaping (String) -> Bool = { _ in false },
    accentColor: UIColor = .systemBlue,
    imageName: String = "externaldrive",
    displayStyle: DisplayStyle = .sheet
) {
    if let rootWindow = UIApplication.rootWindow, let scene = UIApplication.rootScene {
        let window = UIWindow(windowScene: scene)
        window.backgroundColor = .clear
        window.frame = CGRect(
            origin: CGPoint(
                x: 0,
                y: UIScreen.main.bounds.height - (overlayWindowSize.height + rootWindow.safeAreaInsets.bottom)
            ),
            size: overlayWindowSize
        )
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
