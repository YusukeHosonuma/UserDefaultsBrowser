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
                    UserDefaultsBrowserView(suiteNames: [groupID])
                }
            }
            .navigationViewStyle(.stack) // ⚠️ This is not work. (SwiftUI bug?)
            .tabItem {
                Label("Example", systemImage: "swift")
            }

            UserDefaultsBrowserView(suiteNames: [groupID])
                .tabItem {
                    Label("Browser", systemImage: "externaldrive")
                }
        }
    }
}
