// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Ignite",
    platforms: [.macOS(.v13)],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "Ignite",
            targets: ["Ignite"])
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-markdown.git", branch: "main")
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "Ignite",
            dependencies: [
                    .product(name: "Markdown", package: "swift-markdown")
                ],
            resources: [
                .copy("Resources")
            ]
        ),
        .testTarget(
            name: "IgniteTests",
            dependencies: ["Ignite"])
    ]
)
