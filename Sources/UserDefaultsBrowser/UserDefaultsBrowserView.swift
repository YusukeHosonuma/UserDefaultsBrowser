//
//  File.swift
//
//
//  Created by Yusuke Hosonuma on 2022/04/30.
//

import SwiftUI

public struct UserDefaultsBrowserView: View {
    // 💡 iOS 15+: `\.dismiss`
    @Environment(\.presentationMode) private var presentationMode

    private let suiteNames: [String]
    private let accentColor: Color
    private let excludeKeys: (String) -> Bool

    public init(
        suiteNames: [String] = [],
        excludeKeys: @escaping (String) -> Bool = { _ in false },
        accentColor: Color = .accentColor
    ) {
        self.suiteNames = suiteNames
        self.excludeKeys = excludeKeys
        self.accentColor = accentColor
    }

    private var defaults: [UserDefaultsContainer] {
        let standard = UserDefaultsContainer(
            name: "standard",
            defaults: .standard,
            excludeKeys: excludeKeys
        )

        return [standard] + suiteNames.compactMap { name in
            UserDefaults(suiteName: name).map {
                UserDefaultsContainer(
                    name: name,
                    defaults: $0,
                    excludeKeys: excludeKeys
                )
            }
        }
    }

    public var body: some View {
        Group {
            if presentationMode.wrappedValue.isPresented {
                TabView {
                    //
                    // 􀉩 User
                    //
                    tabContent(title: "User") {
                        SearchContainerView(type: .user, defaults: defaults)
                    }
                    .tabItem {
                        Label("User", systemImage: "person")
                    }

                    //
                    // 􀟜 System
                    //
                    tabContent(title: "System") {
                        SearchContainerView(type: .system, defaults: defaults)
                    }
                    .tabItem {
                        Label("System", systemImage: "iphone")
                    }
                }
            } else {
                NavigationView {
                    List {
                        //
                        // 􀉩 User
                        //
                        NavigationLink {
                            SearchContainerView(type: .user, defaults: defaults)
                                .navigationTitle("User")
                        } label: {
                            Label("User", systemImage: "person")
                        }

                        //
                        // 􀟜 System
                        //
                        NavigationLink {
                            SearchContainerView(type: .system, defaults: defaults)
                                .navigationTitle("System")
                        } label: {
                            Label("System", systemImage: "iphone")
                        }
                    }
                    .navigationTitle("UserDefaults Browser")
                    .navigationBarTitleDisplayMode(.inline)
                }
            }
        }
        .accentColor(accentColor)
        .environment(\.customAccentColor, accentColor)
    }

    private func tabContent(title: String, content: () -> SearchContainerView) -> some View {
        NavigationView {
            content()
                .navigationTitle(title)
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .cancellationAction) {
                        Button("Done") {
                            presentationMode.wrappedValue.dismiss()
                        }
                    }
                }
        }
        .navigationViewStyle(.stack)
    }
}
