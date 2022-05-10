//
//  File.swift
//
//
//  Created by Yusuke Hosonuma on 2022/05/03.
//

import CasePaths
import SwiftUI

private enum ValueType: Identifiable {
    case string(String)
    case bool(Bool)
    case int(Int)
    case float(Float)
    case double(Double)
    case url(URL)
    case date(Date)
    case array([Any])
    case dictionary([String: Any])
    case jsonData(JSONData)
    case jsonString(JSONString)
    case unknown

    var typeName: String {
        switch self {
        case .string: return "String"
        case .bool: return "Bool"
        case .int: return "Int"
        case .float: return "Float"
        case .double: return "Double"
        case .url: return "URL"
        case .date: return "Date"
        case .array: return "[Any]"
        case .dictionary: return "[String: Any]"
        case .jsonData: return "Data"
        case .jsonString: return "String"
        case .unknown: return "(Unkonwn)"
        }
    }

    var id: String { typeName }

    var isUnknown: Bool {
        if case .unknown = self {
            return true
        } else {
            return false
        }
    }
}

struct ValueEditView: View {
    // 💡 iOS 15+: `\.dismiss`
    @Environment(\.presentationMode) private var presentationMode

    private let name: String
    private let defaults: UserDefaults
    private let key: String

    init(defaults: UserDefaultsContainer, key: String) {
        name = defaults.name
        self.defaults = defaults.defaults
        self.key = key
    }

    @State private var valueType: ValueType = .unknown
    @State private var isValid = true
    @State private var isPresentedConfirmDelete = false

    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                Text("\(key): \(valueType.typeName)")
                    .font(.system(size: 14, weight: .bold, design: .monospaced))
                    .foregroundColor(.gray)
                    .padding(.horizontal)

                valueEditor()
            }
            .navigationTitle(name)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItemGroup(placement: .destructiveAction) {
                    Button("Save") {
                        save()
                        presentationMode.wrappedValue.dismiss()
                    }
                    .disabled(valueType.isUnknown || isValid == false)
                }
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
                ToolbarItem(placement: .bottomBar) {
                    //
                    // ⚠️ SwiftUI Bug: Not align to trailing on iPhone XS (15.4.1) of real-device.
                    // (No problem in the simulator)
                    //
                    HStack {
                        Spacer()
                        Button {
                            isPresentedConfirmDelete.toggle()
                        } label: {
                            Image(systemName: "trash")
                        }
                    }
                }
            }
        }
        .onAppear {
            load()
        }
        //
        // ⚠️ Delete Key?
        //
        .alert(isPresented: $isPresentedConfirmDelete) {
            Alert(
                title: Text("Delete Key?"),
                message: Text("Are you delete '\(key)'?"),
                primaryButton: .cancel(),
                secondaryButton: .destructive(Text("Delete"), action: {
                    delete()
                    presentationMode.wrappedValue.dismiss()
                })
            )
        }
    }

    // MARK: Editor

    @ViewBuilder
    private func valueEditor() -> some View {
        switch valueType {
        case .string:
            if let binding = $valueType.caseBinding(/ValueType.string) {
                TextEditor(text: binding)
                    .style(.valueEditor)
                    .padding([.horizontal, .bottom])
            }

        case .bool:
            if let binding = $valueType.caseBinding(/ValueType.bool) {
                BoolEditor(value: binding)
                    .padding([.horizontal, .bottom])
            }

        case .int:
            if let binding = $valueType.caseBinding(/ValueType.int) {
                StringRepresentableEditor(binding, isValid: $isValid)
            }

        case .float:
            if let binding = $valueType.caseBinding(/ValueType.float) {
                StringRepresentableEditor(binding, isValid: $isValid)
            }

        case .double:
            if let binding = $valueType.caseBinding(/ValueType.double) {
                StringRepresentableEditor(binding, isValid: $isValid)
            }

        case .url:
            if let binding = $valueType.caseBinding(/ValueType.url) {
                StringRepresentableEditor(binding, isValid: $isValid, style: .multiline)
            }

        case .date:
            if let binding = $valueType.caseBinding(/ValueType.date) {
                DateEditor(date: binding, isValid: $isValid)
            }

        case .array:
            if let binding = $valueType.caseBinding(/ValueType.array) {
                jsonEditor(.init(
                    get: { ArrayWrapper(binding.wrappedValue) },
                    set: { binding.wrappedValue = $0.array }
                ))
            }

        case .dictionary:
            if let binding = $valueType.caseBinding(/ValueType.dictionary) {
                jsonEditor(.init(
                    get: { DictionaryWrapper(binding.wrappedValue) },
                    set: { binding.wrappedValue = $0.dictionary }
                ))
            }

        case .jsonData:
            if let binding = $valueType.caseBinding(/ValueType.jsonData) {
                jsonEditor(.init(
                    get: { DictionaryWrapper(binding.wrappedValue.dictionary) },
                    set: { binding.wrappedValue = JSONData(dictionary: $0.dictionary) }
                ))
            }

        case .jsonString:
            if let binding = $valueType.caseBinding(/ValueType.jsonString) {
                jsonEditor(.init(
                    get: { DictionaryWrapper(binding.wrappedValue.dictionary) },
                    set: { binding.wrappedValue = JSONString(dictionary: $0.dictionary) }
                ))
            }

        case .unknown:
            VStack(spacing: 16) {
                Text("This type was not supported yet.")
                Text("Contributions are welcome!")
                Link("YusukeHosonuma/SwiftUI-Simulator",
                     destination: URL(string: "https://github.com/YusukeHosonuma/SwiftUI-Simulator")!)
            }
            .font(.system(size: 14, weight: .regular, design: .monospaced))
            .padding()
        }
    }

    private func jsonEditor<Value: StringEditable>(_ binding: Binding<Value>) -> some View {
        VStack {
            StringRepresentableEditor(binding, isValid: $isValid, style: .multiline)
            Text("Please input as JSON.")
                .font(.footnote)
                .foregroundColor(.gray)
                .padding(.bottom)
        }
    }

    // MARK: Load / Save

    private func load() {
        let value = defaults.lookup(forKey: key)

        switch value {
        case let value as String:
            valueType = .string(value)

        case let value as Bool:
            valueType = .bool(value)

        case let value as Int:
            valueType = .int(value)

        case let value as Float:
            valueType = .float(value)

        case let value as Double:
            valueType = .double(value)

        case let value as URL:
            valueType = .url(value)

        case let value as Date:
            valueType = .date(value)

        case let value as [Any]:
            valueType = .array(value)

        case let value as [String: Any]:
            valueType = .dictionary(value)

        case let value as JSONData:
            valueType = .jsonData(value)

        case let value as JSONString:
            valueType = .jsonString(value)

        default:
            let object = defaults.object(forKey: key)
            valueType = .unknown
            print("type: \(String(describing: object.self))")
        }
    }

    private func save() {
        func write<T>(_ value: T?) {
            defaults.set(value, forKey: key)
        }

        switch valueType {
        case let .string(value):
            write(value)

        case let .bool(value):
            write(value)

        case let .int(value):
            write(value)

        case let .float(value):
            write(value)

        case let .double(value):
            write(value)

        case let .url(value):
            //
            // ⚠️ This code cause crash, why?
            //
            // write(valueURL)
            //
            defaults.set(value, forKey: key)

        case let .date(value):
            write(value)

        case let .array(value):
            write(value)

        case let .dictionary(value):
            write(value)

        case let .jsonData(value):
            if let data = value.dictionary.prettyJSON.data(using: .utf8) {
                write(data)
            } else {
                preconditionFailure("Can't save JSON as `Data` type.")
            }

        case let .jsonString(value):
            if let json = value.dictionary.serializedJSON {
                write(json)
            } else {
                preconditionFailure("Can't save JSON as `String` type.")
            }

        case .unknown:
            return
        }
    }

    private func delete() {
        defaults.removeObject(forKey: key)
    }
}
