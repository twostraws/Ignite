// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Ignite",
    platforms: [.macOS(.v13)],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(name: "Ignite", targets: ["Ignite"]),
        .executable(name: "IgniteCLI", targets: ["IgniteCLI"])
    ],
    dependencies: [
        .package(url: "https://github.com/swiftlang/swift-markdown.git", from: "0.6.0"),
        .package(url: "https://github.com/apple/swift-argument-parser.git", from: "1.5.0"),
        .package(url: "https://github.com/apple/swift-collections.git", from: "1.1.4"),
        .package(url: "https://github.com/scinfu/SwiftSoup.git", from: "2.7.5")
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "Ignite",
            dependencies: [
                .product(name: "Markdown", package: "swift-markdown"),
                .product(name: "Collections", package: "swift-collections"),
                .product(name: "SwiftSoup", package: "swiftsoup")
            ],
            resources: [
                .copy("Resources")
            ]
        ),
        .executableTarget(
            name: "IgniteCLI",
            dependencies: [
                .product(name: "ArgumentParser", package: "swift-argument-parser")
            ]
        ),
        .testTarget(
            name: "IgniteTesting",
            dependencies: ["Ignite"])
    ]
)
