//
//  File.swift
//
//
//  Created by Yusuke Hosonuma on 2022/04/10.
//

import CasePaths
import SwiftUI

extension Binding {
    //
    // `Binding<T?>` -> `Binding<T>?`
    //
    func wrappedBinding<Wrapped>() -> Binding<Wrapped>? where Value == Wrapped? {
        if let value = wrappedValue {
            return .init(
                get: { value },
                set: { self.wrappedValue = $0 }
            )
        } else {
            return nil
        }
    }

    //
    // `Binding<Enum>` -> `Binding<AssociatedValue>?`
    //
    func `case`<RawValue>(_ path: CasePath<Value, RawValue>) -> Binding<RawValue>? {
        if let value = path.extract(from: wrappedValue) {
            return .init(
                get: { value },
                set: { wrappedValue = path.embed($0) }
            )
        } else {
            return nil
        }
    }

    func map<NewValue>(get: @escaping (Value) -> NewValue, set: @escaping (NewValue) -> Value) -> Binding<NewValue> {
        .init(
            get: { get(wrappedValue) },
            set: { wrappedValue = set($0) }
        )
    }
}
