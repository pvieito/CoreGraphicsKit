// swift-tools-version:5.0

import PackageDescription

let package = Package(
    name: "CoreGraphicsKit",
    platforms: [
        .macOS(.v10_11),
        .iOS(.v9),
    ],
    products: [
        .library(
            name: "CoreGraphicsKit",
            targets: ["CoreGraphicsKit"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/pvieito/FoundationKit.git", .branch("master")),
    ],
    targets: [
        .target(
            name: "CoreGraphicsKit",
            dependencies: ["FoundationKit"],
            path: "CoreGraphicsKit"
        ),
        .testTarget(
            name: "CoreGraphicsKitTests",
            dependencies: ["CoreGraphicsKit", "FoundationKit"]
        )
    ]
)
