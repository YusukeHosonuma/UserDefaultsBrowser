//
//  ContentView.swift
//  Shared
//
//  Created by Yusuke Hosonuma on 2022/05/06.
//

import SwiftUI
import UserDefaultsBrowser

struct ContentView: View {
    @State private var isPresented = false

    var body: some View {
        TabView {
            NavigationView {
                Button("Open Browser") {
                    isPresented.toggle()
                }
                .navigationTitle("Example")
                .sheet(isPresented: $isPresented) {
                    UserDefaultsBrowserView(
                        suiteNames: [groupID],
                        excludeKeys: { $0.hasPrefix("not-display-key") },
                        accentColor: .orange
                    )
                }
            }
            .navigationViewStyle(.stack) // ⚠️ This is not work. (SwiftUI bug?)
            .tabItem {
                Label("Example", systemImage: "swift")
            }

            UserDefaultsBrowserView(
                suiteNames: [groupID],
                excludeKeys: { $0.hasPrefix("not-display-key") },
                accentColor: .orange
            )
            .tabItem {
                Label("Browser", systemImage: "externaldrive")
            }
        }
    }
}
