// swift-tools-version:5.0

import PackageDescription

let package = Package(
    name: "CoreGraphicsKit",
    platforms: [
        .macOS(.v10_12),
        .iOS(.v12),
        .tvOS(.v12),
        .watchOS(.v5),
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
