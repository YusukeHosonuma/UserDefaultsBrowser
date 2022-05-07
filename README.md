# UserDefaultsBrowser

Browse and edit [UserDefaults](https://developer.apple.com/documentation/foundation/userdefaults) on your app.

## Supported types

- [Property List Types](https://developer.apple.com/library/archive/documentation/General/Conceptual/DevPedia-CocoaCore/PropertyList.html)
  - [x] `Array`
  - [x] `Dictionary`
  - [x] `String`
  - [x] `Date`
  - [x] `Int`
  - [x] `Float`
  - [x] `Double`
  - [x] `Bool`
- Other
  - [x] `URL`
  - [x] `UIImage` (Read-only)
- JSON encoded
  - [x] `Data`
  - [x] `String`

[AppGroups](https://developer.apple.com/documentation/bundleresources/entitlements/com_apple_security_application-groups) (`UserDefaults(suiteName: "group.xxx")`) is also supported, please see [Configurations](#Configurations).

## Quick Start

Add `https://github.com/YusukeHosonuma/UserDefaultsBrowser` in the Xcode or `Package.swift`:

```swift
let package = Package(
    dependencies: [
        .package(url: "https://github.com/YusukeHosonuma/UserDefaultsBrowser", from: "xxx"),
    ],
    targets: [
        .target(name: "<your-target-name>", dependencies: [
             "UserDefaultsBrowser",
        ]),
    ]
)
```

### SwiftUI

Surround the root view with `UserDefaultsBrowserContainer`.

```swift
import UserDefaultsBrowser

@main
struct ExampleApp: App {
    var body: some Scene {
        WindowGroup {
            UserDefaultsBrowserContainer {
                ContentView() // 💡 Your root view.
            }
        }
    }
}
```

### UIKit

Call `setupUserDefaultsBrowserLauncher` in `viewDidLoad` of your root ViewController.

```swift
import UserDefaultsBrowser

class ViewController: UIViewController { // 💡 Your root ViewController.

    override func viewDidLoad() {
        super.viewDidLoad()

        UserDefaultsBrowser.setupUserDefaultsBrowserLauncher()
    }
}
```

## Configuration

Both SwiftUI and UIKit have the same options.

```swift
UserDefaultsBrowserContainer(
    suiteNames: ["group.xxx"],                        // AppGroups IDs
    excludeKeys: { $0.hasPrefix("not-display-key") }, // Exclude keys
    accentColor: .orange,                             // Your favorite color (`UIColor` type in UIKit-based API)
    imageName: "wrench.and.screwdriver",              // SFSymbols name
    displayStyle: .fullScreen                         // `.sheet` or `.fullScreen`
) {
    ContentView()
}
```

## Add to some View or ViewController

For example, for tab-based applications, it is useful to have a tab for browsing.

### SwiftUI

```swift
var body: some View {
    TabView {
        ...
        UserDefaultsBrowserView()
            .tabItem {
                Label("Browser", systemImage: "externaldrive")
            }
    }
}
```

### UIKit

```swift
class TabItemViewController: UIViewController {
    override func viewDidLoad() {
        let vc = UserDefaultsBrowserViewController()
        addChild(vc)
        view.addSubview(vc.view)
        vc.didMove(toParent: self)
        
        vc.view.translatesAutoresizingMaskIntoConstraints = false
        vc.view.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0).isActive = true
        vc.view.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0).isActive = true
        vc.view.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
        vc.view.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
    }
}
```

## Requirements

- iOS 14+

## Contributions

Issues and PRs are welcome, even for minor improvements and corrections.

## Author

Yusuke Hosonuma / [@tobi462](https://twitter.com/tobi462)
