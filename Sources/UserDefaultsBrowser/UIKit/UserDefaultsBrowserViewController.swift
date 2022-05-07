//
//  File.swift
//
//
//  Created by Yusuke Hosonuma on 2022/05/07.
//

import SwiftUI

//
// Wrapper of `UserDefaultsBrowserView`.
//
public class UserDefaultsBrowserViewController: UIViewController {
    private let suiteNames: [String]
    private let excludeKeys: (String) -> Bool
    private let accentColor: UIColor

    public init(
        suiteNames: [String],
        excludeKeys: @escaping (String) -> Bool,
        accentColor: UIColor
    ) {
        self.suiteNames = suiteNames
        self.excludeKeys = excludeKeys
        self.accentColor = accentColor
        super.init(nibName: nil, bundle: nil)
    }

    override public func viewDidLoad() {
        let browserView = UserDefaultsBrowserView(
            suiteNames: suiteNames,
            excludeKeys: excludeKeys,
            accentColor: Color(accentColor)
        )

        let vc = UIHostingController(rootView: browserView)
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

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
