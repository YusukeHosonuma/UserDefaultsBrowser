//
//  File.swift
//
//
//  Created by Yusuke Hosonuma on 2022/05/07.
//

import SwiftUI

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
        let button = UIButton()
        button.setImage(UIImage(systemName: imageName), for: .normal)
        button.tintColor = accentColor
        view.addSubview(button)

        button.translatesAutoresizingMaskIntoConstraints = false
        button.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0).isActive = true
        button.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
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
