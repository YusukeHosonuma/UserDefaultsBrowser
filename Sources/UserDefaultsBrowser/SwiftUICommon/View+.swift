import SwiftUI

extension View {
    func enabled(_ enabled: Bool) -> some View {
        disabled(enabled == false)
    }

    func extend<Content: View>(@ViewBuilder transform: (Self) -> Content) -> some View {
        transform(self)
    }

    func frame(size: CGSize?) -> some View {
        frame(width: size?.width, height: size?.height)
    }

    func onChangeSize(perform: @escaping (CGSize) -> Void) -> some View {
        sizePreference()
            .onChangeSizePreference(perform: perform)
    }

    func sizePreference() -> some View {
        background(
            GeometryReader { local in
                Color.clear
                    .preference(key: SizeKey.self, value: local.size)
            }
        )
    }

    func onChangeSizePreference(perform: @escaping (CGSize) -> Void) -> some View {
        onPreferenceChange(SizeKey.self) { size in
            if let size = size {
                perform(size)
            }
        }
    }
}

private struct SizeKey: PreferenceKey {
    static var defaultValue: CGSize?

    static func reduce(value: inout CGSize?, nextValue: () -> CGSize?) {
        value = nextValue()
    }
}
