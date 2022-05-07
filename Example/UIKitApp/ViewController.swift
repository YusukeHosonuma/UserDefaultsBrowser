//
//  ViewController.swift
//  UIKitApp
//
//  Created by Yusuke Hosonuma on 2022/05/06.
//

import SwiftUI
import UIKit
import UserDefaultsBrowser

let groupID = "group.UserDefaultsBrowser"

class ViewController: UIViewController {
    var window: UIWindow!
    var coveringWindow: UIWindow?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupExampleData()
        UserDefaultsBrowser.setupUserDefaultsBrowserLauncher(
            suiteNames: [groupID],
            excludeKeys: { $0.hasPrefix("not-display-key") },
            accentColor: .systemPurple,
            imageName: "wrench.and.screwdriver",
            displayStyle: .fullScreen
        )
    }

    @IBAction func tapOpenBrowserButton(_: Any) {
        let vc = UserDefaultsBrowserViewController(
            suiteNames: [groupID],
            excludeKeys: { $0.hasPrefix("not-display-key") },
            accentColor: .systemPurple
        )
        vc.modalPresentationStyle = .pageSheet
        present(vc, animated: true)
    }

    // MARK: Private

    private func setupExampleData() {
        struct User: Codable {
            let name: String
            let age: Int
            let date: Date
            let url: URL
        }

        //
        // UserDefaults.standard
        //
        let standard = UserDefaults.standard
        standard.set("Hello!", forKey: "message")
        standard.set("Not display in browser", forKey: "not-display-key")
        standard.set(7.5, forKey: "number")
        standard.set(URL(string: "https://github.com/YusukeHosonuma/UserDefaultsBrowser")!, forKey: "url")
        standard.set(Date(), forKey: "date")
        standard.set(["Apple", "Orange"], forKey: "array")
        standard.set([
            "int": 42,
            "float": Float(3.14),
            "bool": true,
            "string": "String",
            "array": ["one", "two"],
        ], forKey: "dictionary")

        let user = User(
            name: "tobi462",
            age: 17,
            date: Date(),
            url: URL(string: "https://github.com/YusukeHosonuma/UserDefaultsBrowser")!
        )
        let data = try! JSONEncoder().encode(user)
        standard.set(data, forKey: "user")

        //
        // AppGroup
        //
        guard let group = UserDefaults(suiteName: groupID) else { preconditionFailure() }
        group.set("Goodbye", forKey: "message")
        group.set(42.195, forKey: "number")
    }
}
