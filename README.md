# UserDefaults-Browser

Browse and edit [UserDefaults](https://developer.apple.com/documentation/foundation/userdefaults) on your app. (SwiftUI or UIKit)

| Browse | Edit (as JSON) | Edit (Date) | Export |
| -- | -- | -- | -- |
|<img width="415" alt="image" src="https://user-images.githubusercontent.com/2990285/167282478-3d4c17bf-40fd-47fd-bc1e-647002f9b7dc.png">|<img width="415" alt="image" src="https://user-images.githubusercontent.com/2990285/167282487-da0de277-917e-4032-8f7d-b027c0ea1690.png">|<img width="415" alt="image" src="https://user-images.githubusercontent.com/2990285/167282490-0281e64a-9b9f-44e7-bfea-f9f27772aeae.png">|<img width="415" alt="image" src="https://user-images.githubusercontent.com/2990285/167282492-034ccd01-742b-49b6-ab65-7492ebc34984.png">|


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

1. Add `https://github.com/YusukeHosonuma/UserDefaultsBrowser` in the Xcode or `Package.swift`:

```swift
let package = Package(
    dependencies: [
        .package(url: "https://github.com/YusukeHosonuma/UserDefaultsBrowser", from: "1.0.0"),
    ],
    targets: [
        .target(name: "<your-target-name>", dependencies: [
             "UserDefaultsBrowser",
        ]),
    ]
)
```

2. Setup launcher button.

**SwiftUI:** Surround the root view with `UserDefaultsBrowserContainer`.

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

**UIKit:** Call `setupUserDefaultsBrowserLauncher` in `viewDidLoad` of your root ViewController.

```swift
import UserDefaultsBrowser

class ViewController: UIViewController { // 💡 Your root ViewController.

    override func viewDidLoad() {
        super.viewDidLoad()

        UserDefaultsBrowser.setupUserDefaultsBrowserLauncher()
    }
}
```

3. Tap launcher button at leading bottom.

![image](https://user-images.githubusercontent.com/2990285/167282686-e53f6621-d6d5-47bb-9f77-e62de33a41f3.png)

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
