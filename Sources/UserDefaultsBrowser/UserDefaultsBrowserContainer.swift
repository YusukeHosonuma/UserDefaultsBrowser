//
//  File.swift
//
//
//  Created by Yusuke Hosonuma on 2022/05/06.
//

import SwiftUI

public struct UserDefaultsBrowserContainer<Content: View>: View {
    private let suiteNames: [String]
    private let excludeKeys: (String) -> Bool
    private let accentColor: Color
    private let imageName: String
    private let displayStyle: DisplayStyle
    private var content: () -> Content

    public init(
        suiteNames: [String] = [],
        excludeKeys: @escaping (String) -> Bool = { _ in false },
        accentColor: Color = .blue,
        imageName: String = "externaldrive",
        displayStyle: DisplayStyle = .sheet,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.suiteNames = suiteNames
        self.excludeKeys = excludeKeys
        self.accentColor = accentColor
        self.imageName = imageName
        self.displayStyle = displayStyle
        self.content = content
    }

    @State private var isPresentedSheet = false
    @State private var isPresentedFullScreenCover = false

    public var body: some View {
        ZStack(alignment: .bottomLeading) {
            content()

            Button {
                isPresentedSheet.toggle()
            } label: {
                Image(systemName: imageName)
                    .padding()
                    .contentShape(Rectangle())
            }
            .accentColor(accentColor)
        }
        .extend { parent in
            switch displayStyle {
            case .sheet:
                parent
                    .sheet(isPresented: $isPresentedSheet) {
                        browser()
                    }
            case .fullScreen:
                parent
                    .fullScreenCover(isPresented: $isPresentedSheet) {
                        browser()
                    }
            }
        }
    }

    private func browser() -> some View {
        UserDefaultsBrowserView(
            suiteNames: suiteNames,
            excludeKeys: excludeKeys,
            accentColor: accentColor
        )
    }
}
