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

    @State private var value: ValueType = .unknown
    @State private var isValid = true
    @State private var isPresentedConfirmDelete = false

    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                Text("\(key): \(value.typeName)")
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
                    .disabled(value.isUnknown || isValid == false)
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
        switch value {
        case .string:
            if let binding = $value.case(/ValueType.string) {
                TextEditor(text: binding)
                    .style(.valueEditor)
                    .padding([.horizontal, .bottom])
            }

        case .bool:
            if let binding = $value.case(/ValueType.bool) {
                BoolEditor(value: binding)
                    .padding([.horizontal, .bottom])
            }

        case .int:
            if let binding = $value.case(/ValueType.int) {
                StringRepresentableEditor(binding, isValid: $isValid)
            }

        case .float:
            if let binding = $value.case(/ValueType.float) {
                StringRepresentableEditor(binding, isValid: $isValid)
            }

        case .double:
            if let binding = $value.case(/ValueType.double) {
                StringRepresentableEditor(binding, isValid: $isValid)
            }

        case .url:
            if let binding = $value.case(/ValueType.url) {
                StringRepresentableEditor(binding, isValid: $isValid, style: .multiline)
            }

        case .date:
            if let binding = $value.case(/ValueType.date) {
                DateEditor(date: binding, isValid: $isValid)
            }

        case .array:
            if let binding = $value.case(/ValueType.array) {
                jsonEditor(
                    binding.map(get: ArrayWrapper.init, set: { $0.array })
                )
            }

        case .dictionary:
            if let binding = $value.case(/ValueType.dictionary) {
                jsonEditor(
                    binding.map(get: DictionaryWrapper.init, set: { $0.dictionary })
                )
            }

        case .jsonData:
            if let binding = $value.case(/ValueType.jsonData) {
                jsonEditor(
                    binding.map(
                        get: { DictionaryWrapper($0.dictionary) },
                        set: { JSONData(dictionary: $0.dictionary) }
                    )
                )
            }

        case .jsonString:
            if let binding = $value.case(/ValueType.jsonString) {
                jsonEditor(
                    binding.map(
                        get: { DictionaryWrapper($0.dictionary) },
                        set: { JSONString(dictionary: $0.dictionary) }
                    )
                )
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
        switch defaults.lookup(forKey: key) {
        case let v as String:
            value = .string(v)

        case let v as Bool:
            value = .bool(v)

        case let v as Int:
            value = .int(v)

        case let v as Float:
            value = .float(v)

        case let v as Double:
            value = .double(v)

        case let v as URL:
            value = .url(v)

        case let v as Date:
            value = .date(v)

        case let v as [Any]:
            value = .array(v)

        case let v as [String: Any]:
            value = .dictionary(v)

        case let v as JSONData:
            value = .jsonData(v)

        case let v as JSONString:
            value = .jsonString(v)

        default:
            let object = defaults.object(forKey: key)
            value = .unknown
            print("type: \(String(describing: object.self))")
        }
    }

    private func save() {
        func write<T>(_ value: T?) {
            defaults.set(value, forKey: key)
        }

        switch value {
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
