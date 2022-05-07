# UserDefaultsBrowser

A description of this package.

### Add Launcher Icon

```swift
import UserDefaultsBrowser

class ViewController: UIViewController { // Your root ViewController

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //
        // ✅ All arguments are optional.
        //
        UserDefaultsBrowser.setupUserDefaultsBrowserLauncher(
            suiteNames: ["group.xxx"],                        // AppGroups IDs
            excludeKeys: { $0.hasPrefix("not-display-key") }, // Exclude keys
            accentColor: .systemPurple,                       // Your favorite color
            imageName: "wrench.and.screwdriver",              // SFSymbols name
            displayStyle: .fullScreen                         // `.sheet` or `.fullScreen`
        )
    }
}
```

<img width="250" alt="image" src="https://user-images.githubusercontent.com/2990285/167238791-e15f66d4-0f03-4503-a9fd-141c55f60bfa.png">

### Add Browser to ViewController

For example:

```swift
class TabItemViewController: UIViewController {
    override func viewDidLoad() {
        //
        // ✅ All arguments are optional.
        //
        let vc = UserDefaultsBrowserViewController(
            suiteNames: ["group.xxx"],                        // AppGroups IDs
            excludeKeys: { $0.hasPrefix("not-display-key") }, // Exclude keys
            accentColor: .systemPurple                        // Your favorite color
        )

        //
        // 💡 Add your view. (for example)
        //
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

<img width="250" alt="image" src="https://user-images.githubusercontent.com/2990285/167238851-b287e307-5482-49d4-a2ec-05bef78269cd.png">
