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
        NavigationView {
            Button("Open UserDefaultsBrowser") {
                isPresented.toggle()
            }
            .navigationTitle("Example")
            .sheet(isPresented: $isPresented) {
                UserDefaultsBrowserView(suiteNames: ["group.UserDefaultsBrowser"])
            }
        }
        .navigationViewStyle(.stack)
    }
}
