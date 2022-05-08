//
//  File.swift
//
//
//  Created by Yusuke Hosonuma on 2022/05/03.
//

import SwiftPrettyPrint
import SwiftUI

private enum Value {
    case text(String)
    case url(URL)
    case decodedJSON(String, String)
    case image(UIImage)
    case data(String)

    var isEditable: Bool {
        switch self {
        case .image, .data:
            return false
        case .text, .url, .decodedJSON:
            return true
        }
    }

    var exportString: String {
        switch self {
        case let .text(text):
            return text

        case let .url(url):
            return url.absoluteString
            
        case let .decodedJSON(text, message):
            return
                """
                \(text)
                \(message)
                """

        case .image:
            return "<Image Data>"

        case let .data(text):
            return text
        }
    }
}

struct RowView: View {
    @Environment(\.customAccentColor) private var customAccentColor

    private var defaults: UserDefaultsContainer
    private var key: String
    private var onUpdate: () -> Void

    init(defaults: UserDefaultsContainer, key: String, onUpdate: @escaping () -> Void) {
        self.defaults = defaults
        self.key = key
        self.onUpdate = onUpdate
    }

    @State private var isPresentedEditSheet = false

    private var value: Value {
        let value = defaults.lookup(forKey: key)

        switch value {
        //
        // 💡 Note:
        // `Array` and `Dictionary` are display as JSON string.
        // Because editor of `[String: Any]` is input as JSON.
        //
        case let value as [Any]:
            return .text(value.prettyJSON)
        case let value as [String: Any]:
            return .text(value.prettyJSON)
        case let value as JSONData:
            return .decodedJSON(value.dictionary.prettyJSON, "<Decoded JSON Data>")
        case let value as JSONString:
            return .decodedJSON(value.dictionary.prettyJSON, "<Decoded JSON String>")
        case let value as UIImage:
            return .image(value)
        case let value as Date:
            return .text(value.toString())
        case let value as URL:
            return .url(value)
        case _ as Data:
            return .data(prettyString(value))
        default:
            return .text(prettyString(value))
        }
    }

    private var exportString: String {
        """

        \(key):
        \(value.exportString)
        """
    }

    var body: some View {
        GroupBox {
            content()
                .padding(.top, 2)
        } label: {
            HStack {
                Text(key)
                    .font(.system(size: 14, weight: .bold, design: .monospaced))
                    .lineLimit(1)
                    .truncationMode(.middle)
                    .foregroundColor(.gray)
                Spacer()

                Group {
                    //
                    // 􀩼 Console
                    //
                    Button {
                        print(exportString)
                    } label: {
                        Image(systemName: "terminal")
                    }
                    .padding(.trailing, 2)

                    //
                    // 􀉁 Copy
                    //
                    Button {
                        UIPasteboard.general.string = exportString
                    } label: {
                        Image(systemName: "doc.on.doc")
                    }
                    .padding(.trailing, 2)

                    //
                    // 􀈊 Edit
                    //
                    Button {
                        isPresentedEditSheet.toggle()
                    } label: {
                        Image(systemName: "pencil")
                    }
                    .enabled(value.isEditable)
                }
                .font(.system(size: 16, weight: .regular))
            }
        }
        .sheet(isPresented: $isPresentedEditSheet, onDismiss: { onUpdate() }) {
            ValueEditView(defaults: defaults, key: key)
                //
                // ⚠️ SwiftUI Bug: AccentColor is not inherited to sheet.
                //
                .accentColor(customAccentColor)
        }
    }

    @ViewBuilder
    func content() -> some View {
        HStack {
            VStack(alignment: .leading) {
                switch value {
                case let .text(text):
                    Text(text)
                    
                case let .decodedJSON(text, message):
                    Text(text)
                    Text(message)
                        .foregroundColor(.gray)
                        .padding(.top, 2)
                
                case let .url(url):
                    Link(url.absoluteString, destination: url)
                    
                case let .image(uiImage):
                    if uiImage.size.width < 200 {
                        Image(uiImage: uiImage)
                    } else {
                        Image(uiImage: uiImage)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 200)
                    }
                
                case let .data(text):
                    Text(text)
                        .lineLimit(1)
                    Text("<Data>")
                        .foregroundColor(.gray)
                        .padding(.top, 2)
                }
            }
            Spacer()
        }
        .lineLimit(nil)
        .fixedSize(horizontal: false, vertical: true)
        .font(.codeStyle)
    }
}

private func prettyString(_ value: Any?) -> String {
    guard let value = value else { return "nil" }

    var option = Pretty.sharedOption
    option.indentSize = 2

    var output = ""
    Pretty.prettyPrintDebug(value, option: option, to: &output)
    return output
}
