//
//  BrowserViewController.swift
//  UIKitApp
//
//  Created by Yusuke Hosonuma on 2022/05/07.
//

import UIKit
import UserDefaultsBrowser

class BrowserViewController: UIViewController {
    override func viewDidLoad() {
        let vc = UserDefaultsBrowserViewController(
            suiteNames: [groupID],
            excludeKeys: { $0.hasPrefix("not-display-key") },
            accentColor: .systemPurple
        )

        addChild(vc)
        view.addSubview(vc.view)
        vc.didMove(toParent: self)

        //
        // Same size of self.
        //
        vc.view.translatesAutoresizingMaskIntoConstraints = false
        vc.view.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0).isActive = true
        vc.view.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0).isActive = true
        vc.view.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
        vc.view.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
    }
}
