//
//  File.swift
//
//
//  Created by Yusuke Hosonuma on 2022/05/06.
//

import SwiftUI

extension View {
    func extend<Content: View>(@ViewBuilder _ content: (Self) -> Content) -> some View {
        content(self)
    }
}
