//
//  File.swift
//
//
//  Created by Yusuke Hosonuma on 2022/05/07.
//

import SwiftUI
import UIKit

//
// 􀤂 Launcher icon on leading-bottom.
//
final class UserDefaultsBrowserLauncherViewController: UIViewController {
    private let rootWindow: UIWindow
    private let suiteNames: [String]
    private let excludeKeys: (String) -> Bool
    private let accentColor: UIColor
    private let imageName: String
    private let displayStyle: DisplayStyle

    init(
        rootWindow: UIWindow,
        suiteNames: [String],
        excludeKeys: @escaping (String) -> Bool,
        accentColor: UIColor,
        imageName: String,
        displayStyle: DisplayStyle
    ) {
        self.rootWindow = rootWindow
        self.suiteNames = suiteNames
        self.excludeKeys = excludeKeys
        self.accentColor = accentColor
        self.imageName = imageName
        self.displayStyle = displayStyle
        super.init(nibName: nil, bundle: nil)
    }

    override func viewDidLoad() {
        let button = ExpansionButton()
        button.setImage(UIImage(systemName: imageName), for: .normal)
        button.tintColor = accentColor
        button.insets = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        view.addSubview(button)

        // Both-center
        button.translatesAutoresizingMaskIntoConstraints = false
        button.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        button.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true

        button.addTarget(self, action: #selector(tapButton), for: .touchUpInside)
    }

    @objc private func tapButton() {
        let vc = UserDefaultsBrowserViewController(
            suiteNames: suiteNames,
            excludeKeys: excludeKeys,
            accentColor: accentColor
        )
        vc.modalPresentationStyle = displayStyle.modalPresentationStyle
        rootWindow.rootViewController?.present(vc, animated: true)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// 🌱 Special Thanks.
// https://qiita.com/KokiEnomoto/items/264f26bfa92d06b1996e
private class ExpansionButton: UIButton {
    var insets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)

    override func point(inside point: CGPoint, with _: UIEvent?) -> Bool {
        var rect = bounds
        rect.origin.x -= insets.left
        rect.origin.y -= insets.top
        rect.size.width += insets.left + insets.right
        rect.size.height += insets.top + insets.bottom
        return rect.contains(point)
    }
}
