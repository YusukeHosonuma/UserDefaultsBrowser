//
//  File.swift
//
//
//  Created by Yusuke Hosonuma on 2022/05/07.
//

import UIKit

extension DisplayStyle {
    var modalPresentationStyle: UIModalPresentationStyle {
        switch self {
        case .sheet: return .pageSheet
        case .fullScreen: return .fullScreen
        }
    }
}
