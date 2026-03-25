// swift-tools-version: 5.4

import PackageDescription

let package = Package(
    name: "fanguolai",
    platforms: [.macOS(.v11)],
    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser.git", from: "1.2.0"),
    ],
    targets: [
        .executableTarget(
            name: "fanguolai",
            dependencies: [
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
            ],
            path: "Sources/fanguolai"
        ),
    ]
)
