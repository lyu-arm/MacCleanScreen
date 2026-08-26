// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "MacCleanScreen",
    platforms: [
        .macOS(.v13)
    ],
    products: [
        .executable(name: "MacCleanScreen", targets: ["MacCleanScreen"])
    ],
    targets: [
        .executableTarget(
            name: "MacCleanScreen",
            path: "Sources/MacCleanScreen"
        )
    ]
)
