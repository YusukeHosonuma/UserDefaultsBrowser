// swift-tools-version: 5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "UserDefaultsBrowser",
    platforms: [
        .iOS(.v14),
    ],
    products: [
        .library(name: "UserDefaultsBrowser", targets: ["UserDefaultsBrowser"]),
    ],
    dependencies: [
        .package(url: "https://github.com/YusukeHosonuma/SwiftPrettyPrint.git", from: "1.3.0"),
    ],
    targets: [
        .target(name: "UserDefaultsBrowser", dependencies: [
            "SwiftPrettyPrint",
        ]),
        .testTarget(name: "UserDefaultsBrowserTests", dependencies: ["UserDefaultsBrowser"]),
    ]
)
