// swift-tools-version:5.4

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
        ),
        .library(
            name: "CoreGraphicsKitMac",
            targets: ["CoreGraphicsKitMac"]
        ),
    ],
    dependencies: [
        .package(url: "git@github.com:pvieito/FoundationKit.git", .branch("master")),
    ],
    targets: [
        .target(
            name: "CoreGraphicsKit",
            dependencies: ["FoundationKit"],
            path: "CoreGraphicsKit"
        ),
        .target(
            name: "CoreGraphicsKitMac",
            dependencies: [.product(name: "FoundationKitMac", package: "FoundationKit")],
            path: "CoreGraphicsKitMac"
        ),
        .testTarget(
            name: "CoreGraphicsKitTests",
            dependencies: ["CoreGraphicsKit", "FoundationKit"]
        )
    ]
)
