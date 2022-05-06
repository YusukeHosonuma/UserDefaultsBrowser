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
        Button("Open UserDefaultsBrowser") {
            isPresented.toggle()
        }
        .sheet(isPresented: $isPresented) {
            UserDefaultsBrowserView(suiteNames: ["group.UserDefaultsBrowser"])
        }
    }
}
