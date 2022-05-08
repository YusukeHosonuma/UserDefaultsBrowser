//
//  ExampleApp.swift
//  Shared
//
//  Created by Yusuke Hosonuma on 2022/05/06.
//

import SwiftUI
import UserDefaultsBrowser

let groupID = "group.UserDefaultsBrowser"

@main
struct ExampleApp: App {
    @AppStorage("isFirstLaunch") private var isFirstLaunch = true

    init() {
        setupExampleData()
    }

    var body: some Scene {
        WindowGroup {
            UserDefaultsBrowserContainer(
                suiteNames: [groupID],
                excludeKeys: { $0.hasPrefix("not-display-key") },
                accentColor: .red,
                imageName: "wrench.and.screwdriver",
                displayStyle: .fullScreen
            ) {
                ContentView()
            }
        }
    }

    // MARK: Private

    private func setupExampleData() {
        if isFirstLaunch {
            defer { isFirstLaunch = false }

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
            standard.set([String](), forKey: "emptyArray")
            standard.set(["Apple", "Orange"], forKey: "array")
            standard.set([String: Any](), forKey: "emptyDictionary")
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

            let pngData = UIImage(systemName: "swift")!.pngData()!
            standard.set(pngData, forKey: "imagePngData")

            let jpegData = UIImage(named: "picture")!.jpegData(compressionQuality: 0.7)!
            standard.set(jpegData, forKey: "imageJpegData")

            let stringData = "https://github.com/YusukeHosonuma/UserDefaultsBrowser".data(using: .utf8)!
            standard.set(stringData, forKey: "stringData")
            
            //
            // AppGroup
            //
            guard let group = UserDefaults(suiteName: groupID) else { preconditionFailure() }
            group.set("Goodbye", forKey: "message")
            group.set(42.195, forKey: "number")
        }
    }
}
