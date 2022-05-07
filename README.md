# UserDefaults-Browser

Browse and edit [UserDefaults](https://developer.apple.com/documentation/foundation/userdefaults) on your app that build with SwiftUI or UIKit.

| Browse | Edit (as JSON) | Edit (Date) | Export |
| -- | -- | -- | -- |
|<img width="371" alt="image" src="https://user-images.githubusercontent.com/2990285/167252878-b249117e-cc82-46f4-a983-f200d5a0bbc7.png">|<img width="371" alt="image" src="https://user-images.githubusercontent.com/2990285/167252911-19ecbe95-91d8-406f-88a1-aae6b6ade73a.png">|<img width="371" alt="image" src="https://user-images.githubusercontent.com/2990285/167252933-a024d34f-8442-4105-b1cc-fd6558209a81.png">|<img width="371" alt="image" src="https://user-images.githubusercontent.com/2990285/167252960-b33a9c62-f38d-46fd-a518-874dcf21aad5.png">|

**Note:**

We recommend to use [SwiftUI-Simulator](https://github.com/YusukeHosonuma/SwiftUI-Simulator), if you use it in an app built with SwiftUI.<br>
(This feature is also included)

## Supported Types

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

Both SwiftUI and UIKit have the same options like follows.

```swift
UserDefaultsBrowserContainer(
    suiteNames: ["group.xxx"],                        // AppGroups IDs
    excludeKeys: { $0.hasPrefix("not-display-key") }, // Exclude keys
    accentColor: .orange,                             // Your favorite color (`UIColor` type in UIKit-based API)
    imageName: "wrench.and.screwdriver",              // SFSymbols name
    displayStyle: .fullScreen                         // `.sheet` or `.fullScreen`
)
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
